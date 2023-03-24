//---------------------------------------------------------------------
// addtask.dart
// Aekkarit Surit 630510607
//---------------------------------------------------------------------
// This file contains functions to add a new task to the database.

//---------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/todolist/listview.dart';

import '../theme/theme_management.dart';

//---------------------------------------------------------------------
// AddTask class
//---------------------------------------------------------------------
// This class contains the functions to add a new task to the database.
// This screen is used to add a new task to the database.
// The user can enter the task name, date, time, priority, status,
// description, and color.
// The user can also select the date and time using the date and time
// pickers.
// The user can select the priority and status using the dropdown
// buttons.
// The user can select the color using the color picker.
// The user can save the new task to the database by clicking the save
// button.
// The user can cancel the new task by clicking the cancel button.
//---------------------------------------------------------------------

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  /// Get current user from firebase auth
  User? user = FirebaseAuth.instance.currentUser;

  /// Form key for the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Text controllers for the text fields
  final TextEditingController _taskname = TextEditingController();
  final TextEditingController _taskdate = TextEditingController();
  final TextEditingController _tasktime = TextEditingController();
  final TextEditingController _taskpriority = TextEditingController();
  final TextEditingController _taskstatus = TextEditingController();
  final TextEditingController _taskdescription = TextEditingController();
  final TextEditingController _taskcolor = TextEditingController();

  /// Selected date
  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    /// Set the initial values for the text fields
    _taskdate.text = DateFormat('yyyy-MM-dd').format(_selectedDate);

    /// Set the initial values for the dropdown buttons
    _taskpriority.text = 'High';

    /// Set the initial values for the dropdown buttons
    _taskstatus.text = 'Incomplete';
  }

  @override
  Widget build(BuildContext context) {
    /// Get the theme service
    return Consumer<ThemeService>(builder: (_, themeService, __) {
      /// Return the add task screen
      return Scaffold(
        backgroundColor: themeService.subColor,
        appBar: AppBar(
          title: const Text('Schedule'),
        ),

        /// Body of the screen
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text(
                  "Add Task",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// Form to add a new task
                Form(
                  /// Form key
                  key: _formKey,

                  /// Wrap the form fields
                  child: Wrap(
                    /// Spacing between the form fields
                    runSpacing: 20,
                    children: [
                      /// Task name
                      TextFormField(
                        /// Text controller
                        controller: _taskname,
                        decoration: const InputDecoration(
                          hintText: 'Task Name',
                        ),

                        /// Validate the task name
                        validator: (value) {
                          /// Check if the task name is empty or null
                          if (value == null || value.isEmpty) {
                            /// Return error message
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),

                      /// Task date
                      TextFormField(
                        /// Text controller
                        controller: _taskdate,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelText: "Enter Date"),
                        readOnly: true,

                        /// Validate the task date
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));

                          /// Show the date picker
                          if (pickedDate != null) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              /// Set the selected date to the text field
                              _taskdate.text = formattedDate;
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
                            /// Text controller
                            controller: _tasktime,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: "Enter Time",
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    /// Show the time picker
                                    TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    /// Set the selected time to the text field
                                    if (pickedTime != null) {
                                      setState(() {
                                        _tasktime.text =
                                            pickedTime.format(context);
                                      });
                                    } else {}
                                  }),

                              /// Set the border
                              border: const OutlineInputBorder(
                                /// Set the border radius
                                borderSide: BorderSide(),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// Task priority
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Task Priority"),

                          /// Dropdown button for task priority
                          DropdownButtonFormField(
                            value: _taskpriority.text,
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

                            /// Set the selected value to the text field
                            onChanged: (value) {
                              setState(() {
                                _taskpriority.text = value.toString();
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Task Priority',
                            ),

                            /// Validate the task priority
                            validator: (String? value) {
                              /// Check if the task priority is empty or null
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      /// Task status
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Task Status"),

                          /// Dropdown button for task status
                          DropdownButtonFormField(
                            /// Set the selected value to the text field
                            value: _taskstatus.text,
                            items: const [
                              /// Dropdown menu items for task status
                              DropdownMenuItem(
                                value: "Incomplete",
                                child: Text("Incomplete"),
                              ),
                              DropdownMenuItem(
                                value: "Complete",
                                child: Text("Complete"),
                              ),
                            ],

                            /// Set the selected value to the text field
                            onChanged: (value) {
                              setState(() {
                                _taskstatus.text = value.toString();
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: 'Task Status',
                            ),

                            /// Validate the task status
                            validator: (String? value) {
                              /// Check if the task status is empty or null
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      /// Task description
                      TextFormField(
                        controller: _taskdescription,
                        decoration: const InputDecoration(
                          hintText: 'Task Description',
                        ),

                        /// Validate the task description
                        validator: (String? value) {
                          /// Check if the task description is empty or null
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                /// Task color
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Task Color"),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        /// Color picker
                        GestureDetector(
                          onTap: () {
                            /// Set the selected color to the text field
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

                /// Add task button
                ElevatedButton(
                  /// Add task to the database
                  onPressed: () {
                    /// Check if the form is valid
                    if (_formKey.currentState!.validate()) {
                      /// create a map for the task
                      Map<String, dynamic> task = {
                        'taskname': _taskname.text,
                        'taskdate': _taskdate.text,
                        'tasktime': _tasktime.text,
                        'taskpriority': _taskpriority.text,
                        'taskstatus': _taskstatus.text,
                        'taskdescription': _taskdescription.text,
                        'taskcolor': _taskcolor.text,
                      };

                      /// Add the task to the database using the user id
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .collection('tasks')
                          .doc('task')
                          .set(
                        {
                          /// Add the task to the array field
                          'tasks': FieldValue.arrayUnion([task])
                        },

                        /// Merge the data
                        SetOptions(merge: true),
                      );

                      /// Pop the current screen and navigate to the todo list screen
                      Navigator.pop(context);

                      /// Navigate to the todo list screen
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Todolist()));

                      /// Show a toast message
                      Fluttertoast.showToast(
                          msg: "Task Added",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
