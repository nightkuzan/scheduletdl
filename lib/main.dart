import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/Management/examDate_mng.dart';
import 'package:scheduletdl/sch-management/edit-schedule.dart';
import 'package:scheduletdl/sch-management/schedule-management.dart';
import 'package:scheduletdl/sch-view/schedule-view.dart';
import 'Reg-Sign/Register.dart';
import 'Reg-Sign/SignIn.dart';
import 'todolist/listview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: MyHomePage(title: 'Schedule'),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignIn(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignIn(),
    );
  }
}
