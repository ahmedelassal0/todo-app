import 'package:flutter/material.dart';
import 'package:todolist/modules/archived_task/archived_tasks.dart';
import 'package:todolist/modules/done_tasks/done_tasks.dart';

import '../modules/new_tasks/new_tasks.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screen =
  [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "todo App"
        ),
      ),
      body: screen[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:
        [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Icon(
            Icons.check_circle_outline
          ),
            label: "Done"
          ),
          BottomNavigationBarItem(
            icon: Icon(
            Icons.archive_outlined
          ),
            label: "Archived"
          ),
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
}
