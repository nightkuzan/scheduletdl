import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduletdl/todolist/listview.dart';

class EditTask extends StatefulWidget {
  String taskname;
  String taskdescription;
  String taskdate;
  String tasktime;
  String taskpriority;
  String taskstatus;
  int index;

  EditTask(
      {super.key,
      required this.taskname,
      required this.taskdescription,
      required this.taskdate,
      required this.tasktime,
      required this.taskpriority,
      required this.taskstatus,
      required this.index});

  @override
  _EditTaskState createState() => _EditTaskState();
}

@immutable
class _EditTaskState extends State<EditTask> {
  // access String taskname
  var taskname = TextEditingController();
  var taskdescription = TextEditingController();
  var taskdate = TextEditingController();
  var tasktime = TextEditingController();
  var taskpriority = TextEditingController();
  var taskstatus = TextEditingController();
  var formKey = GlobalKey<FormState>();
  int index = 0;

  @override
  void initState() {
    super.initState();
    taskname = TextEditingController(text: widget.taskname);
    taskdescription = TextEditingController(text: widget.taskdescription);
    taskdate = TextEditingController(text: widget.taskdate);
    tasktime = TextEditingController(text: widget.tasktime);
    taskpriority = TextEditingController(text: widget.taskpriority);
    taskstatus = TextEditingController(text: widget.taskstatus);
    index = widget.index;

    // firebase to get data
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("tasks")
        .doc("task")
        .get()
        .then((value) {
      setState(() {
        var x = value.data() as Map<String, dynamic>;
        print(x['tasks'][index]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Wrap(
                runSpacing: 20,
                children: [
                  TextFormField(
                    controller: taskname,
                    decoration: const InputDecoration(
                      labelText: 'Task Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: taskdescription,
                    decoration: const InputDecoration(
                      labelText: 'Task Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: taskdate,
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
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          taskdate.text =
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
                        controller:
                            tasktime, //set it true, so that user will not able to edit text
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
                                    tasktime.text = pickedTime.format(context);
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Task Priority"),
                      DropdownButtonFormField(
                        value: widget.taskpriority,
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
                            taskpriority.text = value.toString();
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Map<String, dynamic> task = {
                    "taskname": taskname.text,
                    "taskdate": taskdate.text,
                    "tasktime": tasktime.text,
                    "taskpriority": taskpriority.text,
                    "taskstatus": widget.taskstatus,
                    "taskdescription": taskdescription.text,
                  };
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection("tasks")
                      .doc("task")
                      .update(
                        {
                          "tasks": FieldValue.arrayRemove([widget.taskname]),
                        },
                        // SetOptions(merge: true),
                      )
                      .then((value) => Fluttertoast.showToast(
                          msg: "Task Updated Successfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0))
                      .catchError((error) => Fluttertoast.showToast(
                          msg: "Failed to update task: $error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0));
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
  }
}
