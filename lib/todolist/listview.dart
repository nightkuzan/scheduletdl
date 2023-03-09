import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduletdl/todolist/addtask.dart';

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

    // await Firebase.initializeApp();

    // final CollectionReference taskstdl =
    //     FirebaseFirestore.instance.collection('Todolist');
    // final snapshot = await taskstdl.get();
    // setState(() {
    //   tasks = snapshot.docs.map((e) => e.data()).toList();
    // });
    // print(tasks[0]['1']['taskstatus']);
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
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTask()));
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(tasks[index]['taskname']),
                    subtitle: Text(tasks[index]['taskdescription']),
                    trailing: Text(tasks[index]['taskstatus']),
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
