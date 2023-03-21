import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scheduletdl/Management/examdate_manage.dart';

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
  // var taskmidterm = TextEditingController();
  // var taskfinal = TextEditingController();
  // var taskStartmidterm = TextEditingController();
  // var taskEndmidterm = TextEditingController();
  // var taskStartfinal = TextEditingController();
  // var taskEndfinal = TextEditingController();
  var subjectName = TextEditingController();
  var subjectID = TextEditingController();
  var room = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  var studyDay = TextEditingController();
  var startMidTimeController = TextEditingController();
  var endMidTimeController = TextEditingController();
  var startFinalTimeController = TextEditingController();
  var endFinalTimeController = TextEditingController();
  var examMiddate = TextEditingController();
  var examFidate = TextEditingController();
  var subjectDescription = TextEditingController();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  void initState() {
    super.initState();
    index = widget.index;
    subjectName =
        TextEditingController(text: widget.subjectList[index]['taskname']);
    subjectID =
        TextEditingController(text: widget.subjectList[index]["taskID"]);
    room = TextEditingController(text: widget.subjectList[index]["taskroom"]);
    startTimeController =
        TextEditingController(text: widget.subjectList[index]["tasktimeStart"]);
    endTimeController =
        TextEditingController(text: widget.subjectList[index]["tasktimeEnd"]);
    studyDay =
        TextEditingController(text: widget.subjectList[index]["taskDay"]);
    startMidTimeController = TextEditingController(
        text: widget.subjectList[index]["taskStartmidterm"]);
    endMidTimeController = TextEditingController(
        text: widget.subjectList[index]["taskEndmidterm"]);
    startFinalTimeController = TextEditingController(
        text: widget.subjectList[index]["taskStartfinal"]);
    endFinalTimeController =
        TextEditingController(text: widget.subjectList[index]["taskEndfinal"]);
    examMiddate =
        TextEditingController(text: widget.subjectList[index]["taskmidterm"]);
    examFidate =
        TextEditingController(text: widget.subjectList[index]["taskfinal"]);
    subjectDescription = TextEditingController(
        text: widget.subjectList[index]["taskdescription"]);

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
                      const Text(
                        "Edit Examination Date",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        const Text(
                          "Midterm Exam : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: examMiddate,
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
                              examMiddate.text =
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
                              controller: startMidTimeController,
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
                                      if (endMidTimeController
                                          .text.isNotEmpty) {
                                        final endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm().parse(
                                                endMidTimeController.text));
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
                                        startMidTimeController.text =
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
                              controller: endMidTimeController,
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
                                      if (startMidTimeController
                                          .text.isNotEmpty) {
                                        final startTime = TimeOfDay
                                            .fromDateTime(DateFormat.jm().parse(
                                                startMidTimeController.text));
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
                                        endMidTimeController.text =
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
                        controller: examFidate,
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
                              examFidate.text =
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
                              controller: startFinalTimeController,
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
                                      if (endFinalTimeController
                                          .text.isNotEmpty) {
                                        final endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm().parse(
                                                endFinalTimeController.text));
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
                                        startFinalTimeController.text =
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
                              controller: endFinalTimeController,
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
                                      if (startFinalTimeController
                                          .text.isNotEmpty) {
                                        final startTime = TimeOfDay
                                            .fromDateTime(DateFormat.jm().parse(
                                                startFinalTimeController.text));
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
                                        endFinalTimeController.text =
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
                          if (formKey.currentState!.validate()) {
                            Map<String, dynamic> subjectTask = {
                              // "taskmidterm": widget.subjectList[index]
                              //     ["taskmidterm"],
                              // "taskfinal": widget.subjectList[index]
                              //     ["taskfinal"],
                              // "taskStartmidterm": widget.subjectList[index]
                              //     ["taskStartmidterm"],
                              // "taskEndmidterm": widget.subjectList[index]
                              //     ["taskEndmidterm"],
                              // "taskStartfinal": widget.subjectList[index]
                              //     ["taskStartfinal"],
                              // "taskEndfinal": widget.subjectList[index]
                              //     ["taskEndfinal"],
                              "taskname": widget.subjectList[index]["taskname"],
                              "taskID": widget.subjectList[index]["taskID"],
                              "taskroom": widget.subjectList[index]["taskroom"],
                              "tasktimeStart": widget.subjectList[index]
                                  ["tasktimeStart"],
                              "tasktimeEnd": widget.subjectList[index]
                                  ["tasktimeEnd"],
                              "taskDay": widget.subjectList[index]["taskDay"],
                              "taskmidterm": examMiddate.text,
                              "taskStartmidterm": startMidTimeController.text,
                              "taskEndmidterm": endMidTimeController.text,
                              "taskfinal": examFidate.text,
                              "taskStartfinal": startFinalTimeController.text,
                              "taskEndfinal": endFinalTimeController.text,
                              "taskdescription": widget.subjectList[index]
                                  ["taskdescription"],
                            };
                            subjectList[index] = subjectTask;
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("subjectList")
                                .doc("subjectTask")
                                .set(
                                  {
                                    "subjectList": subjectList,
                                  },
                                  SetOptions(merge: true),
                                )
                                .then((value) => Fluttertoast.showToast(
                                    msg: "Subject Updated Successfully",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0))
                                .catchError((error) => Fluttertoast.showToast(
                                    msg: "Failed to update subject: $error",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0));
                          }
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
