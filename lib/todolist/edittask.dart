//---------------------------------------------------------------------
// edittask.dart
// Aekkarit Surit 630510607
//---------------------------------------------------------------------
// This file is contains function for edit task.
//---------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/todolist/listview.dart';

import '../theme/theme_management.dart';

//---------------------------------------------------------------------
// EditTask class
//---------------------------------------------------------------------
// This class is contains function for edit task.
// This class is stateful widget.
// This class get task list from listview.dart that contain task name,
// task description, task date, task time, task priority, task status, task color.
// This class get index from listview.dart.
//---------------------------------------------------------------------
class EditTask extends StatefulWidget {
  /// get task list from listview.dart
  dynamic tasks;

  /// get index from listview.dart
  int index;

  EditTask({super.key, required this.tasks, required this.index});

  @override
  _EditTaskState createState() => _EditTaskState();
}

/// initialize task list to empty list
List tasks = [];

class _EditTaskState extends State<EditTask> {
  /// initialize task name, task description, task date, task time, task priority,
  /// task status, task color to TextEditingController
  /// initialize form key
  /// initialize index
  /// for edit task
  var taskname = TextEditingController();
  var taskdescription = TextEditingController();
  var taskdate = TextEditingController();
  var tasktime = TextEditingController();
  var taskpriority = TextEditingController();
  var taskstatus = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var _taskcolor = TextEditingController();
  int index = 0;

  @override
  void initState() {
    super.initState();

    /// set index to widget.index from listview.dart
    index = widget.index;

    /// set task name to widget.tasks[index]['taskname'] from listview.dart
    taskname = TextEditingController(text: widget.tasks[index]['taskname']);

    /// set task description to widget.tasks[index]['taskdescription'] from listview.dart
    taskdescription =
        TextEditingController(text: widget.tasks[index]['taskdescription']);

    /// set task date to widget.tasks[index]['taskdate'] from listview.dart
    taskdate = TextEditingController(text: widget.tasks[index]['taskdate']);

    /// set task time to widget.tasks[index]['tasktime'] from listview.dart
    tasktime = TextEditingController(text: widget.tasks[index]['tasktime']);

    /// set task priority to widget.tasks[index]['taskpriority'] from listview.dart
    taskpriority =
        TextEditingController(text: widget.tasks[index]['taskpriority']);

    /// set task status to widget.tasks[index]['taskstatus'] from listview.dart
    taskstatus = TextEditingController(text: widget.tasks[index]['taskstatus']);

    /// set task color to widget.tasks[index]['taskcolor'] from listview.dart
    _taskcolor = TextEditingController(text: widget.tasks[index]['taskcolor']);

    setState(() {
      /// set task list to widget.tasks from listview.dart
      tasks = widget.tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Get theme service from theme_management.dart
    return Consumer<ThemeService>(builder: (_, themeService, __) {
      return Scaffold(
        backgroundColor: themeService.subColor,
        appBar: AppBar(
          title: const Text('Edit Task'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Form(
                /// Set form key
                key: formKey,
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    /// Task name
                    TextFormField(
                      controller: taskname,
                      decoration: const InputDecoration(
                        labelText: 'Task Name',
                      ),

                      /// validate task name
                      validator: (value) {
                        /// Check task name is empty or null
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                    /// Task description
                    TextFormField(
                      controller: taskdescription,
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                      ),

                      /// validate task description
                      validator: (value) {
                        /// Check task description is empty or null
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),

                    /// Task date
                    TextFormField(
                      controller: taskdate,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today),
                          labelText: "Enter Date"),
                      readOnly: true,
                      onTap: () async {
                        /// show date picker
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));

                        /// Check picked date is not null
                        if (pickedDate != null) {
                          /// format date
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            /// set task date to formatted date
                            taskdate.text = formattedDate;
                          });
                        } else {}
                      },
                    ),

                    /// Task time
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Task Time"),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: tasktime,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Enter Time",
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () async {
                                  /// show time picker
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  /// Check picked time is not null
                                  if (pickedTime != null) {
                                    setState(() {
                                      /// set task time to picked time
                                      tasktime.text =
                                          pickedTime.format(context);
                                    });
                                  } else {}
                                }),

                            /// set border
                            border: const OutlineInputBorder(
                              /// set border radius
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// task priority
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Task Priority"),
                        DropdownButtonFormField(
                          /// set task priority to taskpriority.text
                          value: widget.tasks[index]['taskpriority'].toString(),
                          items: const [
                            DropdownMenuItem(
                              value: "High",
                              child: Text("High"),
                            ),
                            DropdownMenuItem(
                              value: "Medium",
                              child: Text("Medium"),
                            ),
                            DropdownMenuItem(
                              value: "Low",
                              child: Text("Low"),
                            ),
                          ],

                          /// set task priority to value
                          onChanged: (value) {
                            setState(() {
                              taskpriority.text = value.toString();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Task Priority',
                          ),

                          /// validate task priority
                          validator: (String? value) {
                            /// Check task priority is empty or null
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    /// Task Color
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Task Color"),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _taskcolor.text = 'red';
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.red[300],
                                  borderRadius: _taskcolor.text == 'red'
                                      ? BorderRadius.circular(10)
                                      : BorderRadius.circular(0),
                                  border: _taskcolor.text == 'red'
                                      ? Border.all(color: Colors.black)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _taskcolor.text = 'blue';
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: _taskcolor.text == 'blue'
                                      ? BorderRadius.circular(10)
                                      : BorderRadius.circular(0),
                                  border: _taskcolor.text == 'blue'
                                      ? Border.all(color: Colors.black)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _taskcolor.text = 'green';
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  borderRadius: _taskcolor.text == 'green'
                                      ? BorderRadius.circular(10)
                                      : BorderRadius.circular(0),
                                  border: _taskcolor.text == 'green'
                                      ? Border.all(color: Colors.black)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _taskcolor.text = 'yellow';
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.yellow[300],
                                  borderRadius: _taskcolor.text == 'yellow'
                                      ? BorderRadius.circular(10)
                                      : BorderRadius.circular(0),
                                  border: _taskcolor.text == 'yellow'
                                      ? Border.all(color: Colors.black)
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _taskcolor.text = 'purple';
                                });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.purple[300],
                                  borderRadius: _taskcolor.text == 'purple'
                                      ? BorderRadius.circular(10)
                                      : BorderRadius.circular(0),
                                  border: _taskcolor.text == 'purple'
                                      ? Border.all(color: Colors.black)
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Edit Task Button
              ElevatedButton(
                onPressed: () {
                  /// Check form is valid
                  if (formKey.currentState!.validate()) {
                    /// Create task map
                    Map<String, dynamic> task = {
                      "taskname": taskname.text,
                      "taskdate": taskdate.text,
                      "tasktime": tasktime.text,
                      "taskpriority": taskpriority.text,
                      "taskstatus": widget.tasks[index]['taskstatus'],
                      "taskdescription": taskdescription.text,
                      "taskcolor": _taskcolor.text,
                    };

                    /// Update tasks list index with task
                    tasks[index] = task;

                    /// Update tasks list to firestore
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection("tasks")
                        .doc("task")
                        .set(
                          {
                            "tasks": tasks,
                          },
                          SetOptions(merge: true),
                        )

                        /// Show toast message
                        .then((value) => Fluttertoast.showToast(
                            msg: "Task Updated Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0))

                        /// Show error message
                        .catchError((error) => Fluttertoast.showToast(
                            msg: "Failed to update task: $error",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0));

                    /// Navigate to Todolist
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Todolist()));
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
