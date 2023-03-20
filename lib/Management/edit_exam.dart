import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scheduletdl/Management/examDate_mng.dart';

import '../firebase_options.dart';

class EditExamDate extends StatefulWidget {
  dynamic subjectList;
  int index;
  EditExamDate({super.key, required this.subjectList, required this.index});
  // dynamic tasks;
  // late int index;

  @override
  State<EditExamDate> createState() => _EditExamDateState();
}

List subjectList = [];

class _EditExamDateState extends State<EditExamDate> {
  User? user = FirebaseAuth.instance.currentUser;
  int index = 0;
  var formKey = GlobalKey<FormState>();
  var taskmidterm = TextEditingController();
  var taskfinal = TextEditingController();
  var taskStartmidterm = TextEditingController();
  var taskEndmidterm = TextEditingController();
  var taskStartfinal = TextEditingController();
  var taskEndfinal = TextEditingController();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  void initState() {
    super.initState();
    index = widget.index;

    taskmidterm =
        TextEditingController(text: widget.subjectList[index]['taskmidterm']);
    taskfinal =
        TextEditingController(text: widget.subjectList[index]['taskfinal']);
    taskStartmidterm = TextEditingController(
        text: widget.subjectList[index]['taskStartmidterm']);
    taskEndmidterm = TextEditingController(
        text: widget.subjectList[index]['taskEndmidterm']);
    taskStartfinal = TextEditingController(
        text: widget.subjectList[index]['taskStartfinal']);
    taskEndfinal =
        TextEditingController(text: widget.subjectList[index]['taskEndfinal']);

    setState(() {
      subjectList = widget.subjectList;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "my",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  "Schedule",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff6B4EFF)),
                ),
              ],
            )),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        "Edit Examination Date",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text(
                          "Midterm Exam : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: taskmidterm,
                        decoration: const InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
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
                              taskmidterm.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: taskStartmidterm,
                              decoration: InputDecoration(
                                hintText: "เวลา1" == '' ? 'เวลา2' : "เวลาเริ่ม",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (taskEndmidterm.text.isNotEmpty) {
                                        final endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm()
                                                .parse(taskEndmidterm.text));
                                        if (pickedTime.hour > endTime.hour ||
                                            (pickedTime.hour == endTime.hour &&
                                                pickedTime.minute >
                                                    endTime.minute)) {
                                          // Show error message or do something else to indicate invalid selection
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'The start time cannot be later than the end time.'),
                                            duration: Duration(seconds: 3),
                                          ));
                                          return;
                                        }
                                      }
                                      setState(() {
                                        taskEndmidterm.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ),
                          const Text("  -  "),
                          Expanded(
                            child: TextFormField(
                              controller: taskEndmidterm,
                              decoration: InputDecoration(
                                hintText:
                                    "เวลา4" == '' ? 'เวลา5' : "เวลาสิ้นสุด",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (taskStartmidterm.text.isNotEmpty) {
                                        final startTime =
                                            TimeOfDay.fromDateTime(
                                                DateFormat.jm().parse(
                                                    taskStartmidterm.text));
                                        if (pickedTime.hour < startTime.hour ||
                                            (pickedTime.hour ==
                                                    startTime.hour &&
                                                pickedTime.minute <
                                                    startTime.minute)) {
                                          // Show error message or do something else to indicate invalid selection
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'The start time cannot be later than the end time.'),
                                            duration: Duration(seconds: 3),
                                          ));
                                          return;
                                        }
                                      }
                                      setState(() {
                                        taskEndmidterm.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Text(
                          "Final Exam : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: taskfinal,
                        decoration: const InputDecoration(
                            icon:
                                Icon(Icons.calendar_today), //icon of text field
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
                              taskfinal.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: taskStartfinal,
                              decoration: InputDecoration(
                                hintText: "เวลา1" == '' ? 'เวลา2' : "เวลาเริ่ม",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (taskEndfinal.text.isNotEmpty) {
                                        final endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm()
                                                .parse(taskEndfinal.text));
                                        if (pickedTime.hour > endTime.hour ||
                                            (pickedTime.hour == endTime.hour &&
                                                pickedTime.minute >
                                                    endTime.minute)) {
                                          // Show error message or do something else to indicate invalid selection
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'The start time cannot be later than the end time.'),
                                            duration: Duration(seconds: 3),
                                          ));
                                          return;
                                        }
                                      }
                                      setState(() {
                                        taskStartfinal.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ),
                          const Text("  -  "),
                          Expanded(
                            child: TextFormField(
                              controller: taskEndfinal,
                              decoration: InputDecoration(
                                hintText:
                                    "เวลา4" == '' ? 'เวลา5' : "เวลาสิ้นสุด",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (taskStartfinal.text.isNotEmpty) {
                                        final startTime =
                                            TimeOfDay.fromDateTime(
                                                DateFormat.jm().parse(
                                                    taskStartfinal.text));
                                        if (pickedTime.hour < startTime.hour ||
                                            (pickedTime.hour ==
                                                    startTime.hour &&
                                                pickedTime.minute <
                                                    startTime.minute)) {
                                          // Show error message or do something else to indicate invalid selection
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(
                                                'The start time cannot be later than the end time.'),
                                            duration: Duration(seconds: 3),
                                          ));
                                          return;
                                        }
                                      }
                                      setState(() {
                                        taskEndfinal.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                ),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // if (formKey.currentState!.validate()) {
                          //   Map<String, dynamic> subjectLists = {
                          //     "taskmidterm": taskmidterm.text,
                          //     "taskfinal": taskfinal.text,
                          //     "taskStartmidterm": taskStartmidterm.text,
                          //     "taskEndmidterm": taskEndmidterm.text,
                          //     "taskStartfinal": taskStartfinal.text,
                          //     "taskEndfinal": taskEndfinal.text,
                          //   };
                          //   subjectList[index] = subjectLists;
                          //   FirebaseFirestore.instance
                          //       .collection("users")
                          //       .doc(FirebaseAuth.instance.currentUser!.uid)
                          //       .collection("subjectList")
                          //       .doc("subjectList")
                          //       .set({
                          //     "subjectList": subjectList,
                          //   }, SetOptions(merge: true));
                          // }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ExamListManagement()),
                          );
                        },
                        child: Text("Submit"),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(100, 40),
                            primary: Color(
                              0xff6B4EFF,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
