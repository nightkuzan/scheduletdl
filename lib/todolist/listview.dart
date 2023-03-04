import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List tasks = [];

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

  void getdata() {
    // ignore: unused_local_variable
    Future<FirebaseApp> firebase = Firebase.initializeApp();
    // ignore: no_leading_underscores_for_local_identifiers
    final CollectionReference _tasks =
        FirebaseFirestore.instance.collection('TodoList');
    _tasks.get().then((QuerySnapshot snapshot) {
      tasks = snapshot.docs.map((e) => e.data()).toList();
    });
    
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // todolist app

      title: 'Schedule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Schedule'),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.menu),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const Todolist()),
            //     );
            //   },
            // ),
            BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Todo List",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            // create a listview to show the list of tasks
            ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(tasks[index]["taskname"]),
                    subtitle: Text(tasks[index]["taskdescription"]),
                    // trailing: Text(tasks[index]["taskdate"]),
                    // add button to delete the task
                    leading: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        tasks[index]["taskstatus"] == "Incomplete"
                            ? Icons.check_box_outline_blank
                            : Icons.check_box,
                      ),
                      onPressed: () {
                        setState(() {
                          if (tasks[index]["taskstatus"] == "Incomplete") {
                            tasks[index]["taskstatus"] = "Complete";
                          } else {
                            tasks[index]["taskstatus"] = "Incomplete";
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
