import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  // List<dynamic> tasks = [
  //   {
  //     "taskname": "Math",
  //     "taskdescription": "Do math homework",
  //     "taskdate": "2021-10-10",
  //     "tasktime": "10:00",
  //     "taskpriority": "High",
  //     "taskstatus": "Incomplete"
  //   },
  //   {
  //     "taskname": "English",
  //     "taskdescription": "Do english homework",
  //     "taskdate": "2021-10-10",
  //     "tasktime": "10:00",
  //     "taskpriority": "High",
  //     "taskstatus": "Incomplete"
  //   }
  // ];
  List tasks = [];

  getdata() async {
    // Initialize Firebase

    await Firebase.initializeApp();

    final CollectionReference taskstdl =
        FirebaseFirestore.instance.collection('Todolist');
    final snapshot = await taskstdl.get();
    setState(() {
      tasks = snapshot.docs.map((e) => e.data()).toList();
    });
    print(tasks);
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error initializing Firebase'),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Todo List'),
              // actions: [
              //   BackButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //     },
              //   ),
              // ],
            ),
            //tasks is flutter: [{0: {"taskstatus": "Incomplete", "tasktime": "10:00", "taskdate": "2021-10-10",       "taskname":  "English", "taskdescription": "Do english homework", "taskpriority": "High"}}]
            body: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index]
                    [index.toString()]; // get the task data from the list
                return Card(
                  child: ListTile(
                    title: Text(
                        task['taskname'] ?? "no data"), // display task name
                    subtitle: Text(task['taskdescription'] ??
                        "no data"), // display task description
                    trailing: Text(
                        task['taskdate'] ?? "no data"), // display task date
                  ),
                );
              },
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
