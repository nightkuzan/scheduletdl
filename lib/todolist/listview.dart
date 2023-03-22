import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/menu/menu.dart';
import 'package:scheduletdl/todolist/addtask.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduletdl/todolist/edittask.dart';

import '../theme/theme_management.dart';

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
        if (snapshot.connectionState == ConnectionState.done && tasks.isEmpty) {
          return Consumer<ThemeService>(builder: (_, themeService, __) {
            return Scaffold(
              backgroundColor: themeService.subColor,
              appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {},
                    icon: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Menu()));
                        },
                        icon: const Icon(Icons.arrow_back_ios_new)),
                    color: Colors.black,
                  ),
                  // backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Todo",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "List",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B4EFF)),
                      ),
                    ],
                  )),
              body: const Center(
                child: Text(
                  "No Task",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff6B4EFF)),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTask()));
                },
                backgroundColor: const Color(0xff6B4EFF),
                child: const Icon(Icons.add),
              ),
            );
          });
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<ThemeService>(builder: (_, themeService, __) {
            return Scaffold(
              backgroundColor: themeService.subColor,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Menu()));
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  color: Colors.black,
                ),
                // backgroundColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Todo",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "List",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6B4EFF)),
                    ),
                  ],
                ),
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
                            ? Colors.red[300]
                            : tasks[index]['taskcolor'] == 'yellow'
                                ? Colors.yellow[300]
                                : tasks[index]['taskcolor'] == 'green'
                                    ? Colors.green[200]
                                    : tasks[index]['taskcolor'] == 'purple'
                                        ? Colors.purple[300]
                                        : tasks[index]['taskcolor'] == 'blue'
                                            ? Colors.blue[300]
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
                                                    tasks: tasks,
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
                                                    .set({
                                                  'tasks': tasks
                                                }, SetOptions(merge: true));
                                              });
                                              Navigator.pop(context);
                                              Fluttertoast.showToast(
                                                  msg: 'Task Deleted',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
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
                                color:
                                    tasks[index]["taskstatus"] == "Incomplete"
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
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTask()));
                },
                backgroundColor: const Color(0xff6B4EFF),
                child: const Icon(Icons.add),
              ),
            );
          });
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
