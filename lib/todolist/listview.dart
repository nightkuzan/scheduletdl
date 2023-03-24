// ---------------------------------------------------------------------------
// listview.dart
// Aekkarit Surit 630510607
// ---------------------------------------------------------------------------
// This file contains the code for the ListView widget.
// getdata() function is used to get data from firebase.
//----------------------------------------------------------------------------

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

//---------------------------------------------------------------------------
// Todolist class
//---------------------------------------------------------------------------
// This class is used to create the Todolist widget. It contains the code
// for the ListView widget.
// It also contains the code for the floating action button.
// The floating action button is used to add a new task.
//---------------------------------------------------------------------------
class Todolist extends StatefulWidget {
  const Todolist({super.key});

  @override
  State<Todolist> createState() => _TodolistState();
}

class _TodolistState extends State<Todolist> {
  /// Get current user from firebase auth instance
  User? user = FirebaseAuth.instance.currentUser;

  /// Create a list to store tasks
  List tasks = [];

  /// Get data from firebase
  getdata() async {
    /// Initialize firebase
    await Firebase.initializeApp();

    /// Get data from firebase
    final CollectionReference taskstdl = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('tasks');
    final snapshot = await taskstdl.get();
    setState(() {
      /// Store data in list
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
    /// FutureBuilder is used to initialize firebase before using it in the app
    return FutureBuilder(
      future: firebase,

      /// Build the app once firebase is initialized
      builder: (context, snapshot) {
        /// If there is an error, show error message
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error initializing Firebase'),
            ),
          );
        }

        /// If firebase is initialized and there is no task, show no task message
        if (snapshot.connectionState == ConnectionState.done && tasks.isEmpty) {
          /// Use Consumer to get the current theme
          return Consumer<ThemeService>(builder: (_, themeService, __) {
            /// Return the app
            return Scaffold(
              backgroundColor: themeService.subColor,
              appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {},
                    icon: IconButton(
                        onPressed: () {
                          /// Navigate to Menu widget
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Menu()));
                        },
                        icon: const Icon(Icons.arrow_back_ios_new)),
                    color: Colors.black,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Todo",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
                  /// Navigate to AddTask widget
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTask()));
                },
                backgroundColor: const Color(0xff6B4EFF),
                child: const Icon(Icons.add),
              ),
            );
          });
        }

        /// If firebase is initialized and there is task, show the task
        if (snapshot.connectionState == ConnectionState.done) {
          /// Use Consumer to get the current theme
          return Consumer<ThemeService>(builder: (_, themeService, __) {
            /// Return the app
            return Scaffold(
              backgroundColor: themeService.subColor,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {},
                  icon: IconButton(
                      onPressed: () {
                        /// Navigate to Menu widget
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Menu()));
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  color: Colors.black,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Todo",
                      style: TextStyle(fontWeight: FontWeight.bold),
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

              /// Show the task in a ListView widget
              body: ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  /// Return a Card widget for each task
                  return Column(
                    children: [
                      Card(
                        /// Use the task color to set the card color
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

                        /// Set the elevation of the card
                        elevation: 5,
                        child: Column(
                          children: [
                            ListTile(
                              /// Show the task name
                              title: Text(tasks[index]['taskname']),

                              /// Show the task description, date, time and priority
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

                              /// Show the edit and delete button
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      /// Navigate to EditTask widget
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
                                      /// Show a dialog to confirm the deletion
                                      AlertDialog alert = AlertDialog(
                                        title: const Text('Delete Task'),
                                        content: const Text(
                                            'Are you sure you want to delete this task?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              /// Close the dialog
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              /// Delete the task from the database
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

                                              /// Close the dialog
                                              Navigator.pop(context);

                                              /// Show a toast to confirm the deletion
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

                                      /// Show the dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return alert;
                                        },
                                      );
                                    },
                                    iconSize: 30,
                                    color: Colors.red,
                                  ),
                                ],
                              ),

                              /// Show the checkbox
                              leading: IconButton(
                                icon: Icon(
                                  /// If the task is incomplete, show the unchecked checkbox
                                  tasks[index]["taskstatus"] == "Incomplete"
                                      ? Icons.check_box_outline_blank
                                      : Icons.check_box,
                                ),
                                color:
                                    tasks[index]["taskstatus"] == "Incomplete"
                                        ? Colors.black
                                        : Colors.green,
                                iconSize: 30,
                                onPressed: () {
                                  /// Update the task status
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
                  /// Navigate to AddTask widget
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const AddTask()));
                },
                backgroundColor: const Color(0xff6B4EFF),
                child: const Icon(Icons.add),
              ),
            );
          });
        }
        // circular progress indicator to show loading
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
