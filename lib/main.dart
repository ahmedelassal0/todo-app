import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todolist/layout/home_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeLayout(),
    debugShowCheckedModeBanner: false,);
  }
}
