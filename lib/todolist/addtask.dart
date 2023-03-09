import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  // fromkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // taskname: "English""
  // taskdate: "2021-10-10"
  // tasktime: "10:00"
  // taskpriority: "High"
  // taskstatus: "Incomplete"
  // taskdescription: "Do english homework"
  // controller
  final TextEditingController _taskname = TextEditingController();
  final TextEditingController _taskdate = TextEditingController();
  final TextEditingController _tasktime = TextEditingController();
  final TextEditingController _taskpriority = TextEditingController();
  final TextEditingController _taskstatus = TextEditingController();
  final TextEditingController _taskdescription = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskdate.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Container(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _taskname,
                    decoration: const InputDecoration(
                      hintText: 'Task Name',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  //  date input
                  // TextFormField(
                  //   controller: _taskdate,
                  //   decoration: const InputDecoration(
                  //     hintText: 'Task Date',
                  //   ),
                  //   validator: (String? value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter some text';
                  //     }
                  //     return null;
                  //   },
                  // ),
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
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _taskdate.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                  ),
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
                                _tasktime.text = pickedTime.format(context);
                              });
                            } else {}
                          }),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                  ),

                  TextFormField(
                    controller: _taskpriority,
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
                  TextFormField(
                    controller: _taskstatus,
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
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Todolist').add({
                  'taskname': 'Math',
                  'taskdescription': 'Do math homework',
                  'taskdate': '2021-10-10',
                  'tasktime': '10:00',
                  'taskpriority': 'High',
                  'taskstatus': 'Incomplete'
                });
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
