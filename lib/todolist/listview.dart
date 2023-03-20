import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduletdl/todolist/addtask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduletdl/todolist/edittask.dart';

class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  User? user = FirebaseAuth.instance.currentUser;
  List tasks = [];

  getdata() async {
    // Initialize Firebase

    await Firebase.initializeApp();

    final CollectionReference taskstdl = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks');

    final snapshot = await taskstdl.get();
    setState(() {
      tasks = snapshot.docs.map((e) => e.data()).toList();
      tasks = tasks[0]['tasks'];
    });
    // print(tasks);
    // [{tasks: [{taskstatus: 12, taskdescription: 12, tasktime: 3:02 PM, taskname: 12, taskdate: 2023-03-09, taskpriority: 12}, {taskstatus: sd, taskdescription: asd, tasktime: 3:03 PM, taskname: ad, taskdate: 2023-03-09, taskpriority: sd}]}]
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTask()));
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView.builder(
              // add top margin
              padding: const EdgeInsets.only(top: 20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Card(
                      // add color to card that have red yellow green purple blue
                      color: tasks[index]['taskcolor'] == 'red'
                          ? Colors.red
                          : tasks[index]['taskcolor'] == 'yellow'
                              ? Colors.yellow
                              : tasks[index]['taskcolor'] == 'green'
                                  ? Colors.green
                                  : tasks[index]['taskcolor'] == 'purple'
                                      ? Colors.purple
                                      : tasks[index]['taskcolor'] == 'blue'
                                          ? Colors.blue
                                          : Colors.white,

                      elevation: 5,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(tasks[index]['taskname']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Description: '),
                                        Text(tasks[index]['taskdescription']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Date: '),
                                        Text(tasks[index]['taskdate']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Time: '),
                                        Text(tasks[index]['tasktime']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('Priority: '),
                                        Text(tasks[index]['taskpriority']),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditTask(
                                                  taskname: tasks[index]
                                                      ['taskname'],
                                                  taskdescription: tasks[index]
                                                      ['taskdescription'],
                                                  taskdate: tasks[index]
                                                      ['taskdate'],
                                                  tasktime: tasks[index]
                                                      ['tasktime'],
                                                  taskpriority: tasks[index]
                                                      ['taskpriority'],
                                                  taskstatus: tasks[index]
                                                      ['taskstatus'],
                                                  index: index,
                                                )));
                                  },
                                  iconSize: 30,
                                  color: Colors.blue,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    // alert for confirmation
                                    AlertDialog alert = AlertDialog(
                                      title: const Text('Delete Task'),
                                      content: const Text(
                                          'Are you sure you want to delete this task?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              tasks.removeAt(index);
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(user!.uid)
                                                  .collection('tasks')
                                                  .doc('task')
                                                  .set({'tasks': tasks},
                                                      SetOptions(merge: true));
                                            });
                                            Navigator.pop(context);
                                            Fluttertoast.showToast(
                                                msg: 'Task Deleted',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 20.0);
                                          },
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alert;
                                      },
                                    );
                                    // show toast message for notification of deletion
                                  },
                                  iconSize: 30,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            leading: IconButton(
                              icon: Icon(
                                tasks[index]["taskstatus"] == "Incomplete"
                                    ? Icons.check_box_outline_blank
                                    : Icons.check_box,
                                // add style to the icon
                              ),
                              color: tasks[index]["taskstatus"] == "Incomplete"
                                  ? Colors.black
                                  : Colors.green,
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  if (tasks[index]["taskstatus"] ==
                                      "Incomplete") {
                                    tasks[index]["taskstatus"] = "Complete";
                                  } else {
                                    tasks[index]["taskstatus"] = "Incomplete";
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
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
