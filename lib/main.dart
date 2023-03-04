import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/Management/examDate_mng.dart';
import 'package:scheduletdl/sch-management/edit-schedule.dart';
import 'package:scheduletdl/sch-management/schedule-management.dart';
import 'package:scheduletdl/sch-view/schedule-view.dart';
import 'Reg-Sign/Register.dart';
import 'Reg-Sign/SignIn.dart';
import 'todolist/listview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Schedule'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Schedule',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignIn());
  }
}
