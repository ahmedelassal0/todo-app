import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/modules/archived_task/archived_tasks.dart';
import 'package:todolist/modules/done_tasks/done_tasks.dart';
import 'package:todolist/shared/components/components.dart';

import '../modules/new_tasks/new_tasks.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final bottomSheetFormKey = GlobalKey<FormState>();
  var addTaskTitleController = TextEditingController();
  var addTaskTimeController = TextEditingController();
  var addTaskDateController = TextEditingController();
  bool isBottomSheetClosed = true;
  Icon fabIcon = const Icon(Icons.edit);

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("todo App"),
      ),
      body: screen[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetClosed) {
            isBottomSheetClosed = false;
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: bottomSheetFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      regularTextFormField(
                          controller: addTaskTitleController,
                          text: "Title",
                          icon: Icons.title,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field can'T be empty";
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 15.0,
                      ),
                      regularTextFormField(
                          controller: addTaskTimeController,
                          text: "Time",
                          icon: Icons.watch_later_outlined,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field can't be empty";
                            }
                            return null;
                          },
                          onTap: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((value) {
                              addTaskTimeController.text =
                                  value!.format(context).toString();
                            });
                          }),
                      const SizedBox(
                        height: 15.0,
                      ),
                      regularTextFormField(
                          controller: addTaskDateController,
                          text: "Date",
                          icon: Icons.watch_later_outlined,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "This field can't be empty";
                            }
                            return null;
                          },
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030))
                                .then((value) {
                              addTaskDateController.text =
                                  DateFormat.yMMMd().format(value!);
                            });
                          }),
                    ],
                  ),
                ),
              ),
            );
            setState(() {
              fabIcon = const Icon(Icons.add);
            });
          } else {
            insertToDatabase(
                    title: addTaskTitleController.text,
                    time: addTaskTimeController.text,
                    date: addTaskDateController.text)
                .then((value) {
              if (bottomSheetFormKey.currentState!.validate()) {
                isBottomSheetClosed = true;
                Navigator.pop(context);
                setState(() {
                  fabIcon = const Icon(Icons.edit);
                });
              }
            });
          }
        },
        child: fabIcon,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: "Done"),
          BottomNavigationBarItem(
              icon: Icon(Icons.archive_outlined), label: "Archived"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
      ),
    );
  }

  openTodoDatabase() async {
    Database database = await openDatabase('todoListApp.db');
    return database;
  }

  createDatabase() async {
    Database database = await openDatabase(
      'todoListApp.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) => print('table created'))
            .catchError((error) => print(error));
      },
      onOpen: (db) {
        // db is an object from database
        print('database opened');
      },
    );
  }

  insertToDatabase({required title, required date, required time}) async {
    Database database = await openTodoDatabase();
    database.transaction((txn) async {
      txn.rawInsert('''INSERT INTO tasks(title, date, time, status)
           VALUES("$title", "$date", "$time", "waited")''').then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('error is $error');
      });
    });
    return database;
  }
}
