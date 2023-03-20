import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduletdl/todolist/listview.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  User? user = FirebaseAuth.instance.currentUser;

  // fromkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _taskname = TextEditingController();
  final TextEditingController _taskdate = TextEditingController();
  final TextEditingController _tasktime = TextEditingController();
  final TextEditingController _taskpriority = TextEditingController();
  final TextEditingController _taskstatus = TextEditingController();
  final TextEditingController _taskdescription = TextEditingController();
  final TextEditingController _taskcolor = TextEditingController();

  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskdate.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _taskpriority.text = 'High';
    _taskstatus.text = 'Incomplete';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
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
              Form(
                key: _formKey,
                child: Wrap(
                  runSpacing: 20,
                  children: [
                    TextFormField(
                      controller: _taskname,
                      decoration: const InputDecoration(
                        hintText: 'Task Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _taskdate,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date" //label text of field
                          ),
                      readOnly: true,
                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _taskdate.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Task Time"),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _tasktime,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Enter Time",
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.access_time),
                                onPressed: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      _tasktime.text =
                                          pickedTime.format(context);
                                    });
                                  } else {}
                                }),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Task Priority"),
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
                          onChanged: (value) {
                            setState(() {
                              _taskpriority.text = value.toString();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Task Priority',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    // dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Task Status"),
                        DropdownButtonFormField(
                          value: _taskstatus.text,
                          items: const [
                            DropdownMenuItem(
                              value: "Incomplete",
                              child: Text("Incomplete"),
                            ),
                            DropdownMenuItem(
                              value: "Complete",
                              child: Text("Complete"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _taskstatus.text = value.toString();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Task Status',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _taskdescription,
                      decoration: const InputDecoration(
                        hintText: 'Task Description',
                      ),
                      validator: (String? value) {
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
              Column(
                // select color minimal for task
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
                          // make have selected color

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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> task = {
                      'taskname': _taskname.text,
                      'taskdate': _taskdate.text,
                      'tasktime': _tasktime.text,
                      'taskpriority': _taskpriority.text,
                      'taskstatus': _taskstatus.text,
                      'taskdescription': _taskdescription.text,
                      'taskcolor': _taskcolor.text,
                    };
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('tasks')
                        .doc('task')
                        .set(
                      {
                        'tasks': FieldValue.arrayUnion([task])
                      },
                      SetOptions(merge: true),
                    );
                    // pop and return to previous page and refresh
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Todolist()));
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
  }
}
