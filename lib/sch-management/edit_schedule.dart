import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/sch-management/schedule_management.dart';

import '../theme/theme_management.dart';

class Editschedule extends StatefulWidget {
  Editschedule({
    super.key,
    required this.subjectList,
    required this.index,
  });

  int index;
  dynamic subjectList;

  @override
  _Editschedule createState() => _Editschedule();
}

List subjectList = [];

class _Editschedule extends State<Editschedule> {
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
  int index = 0;
  var formKey = GlobalKey<FormState>();

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
    startMidTimeController =
        TextEditingController(text: widget.subjectList[index]["taskmidterm"]);
    endMidTimeController = TextEditingController(
        text: widget.subjectList[index]["taskStartmidterm"]);
    startFinalTimeController = TextEditingController(
        text: widget.subjectList[index]["taskEndmidterm"]);
    endFinalTimeController =
        TextEditingController(text: widget.subjectList[index]["taskfinal"]);
    examMiddate = TextEditingController(
        text: widget.subjectList[index]["taskStartfinal"]);
    examFidate =
        TextEditingController(text: widget.subjectList[index]["taskEndfinal"]);
    subjectDescription = TextEditingController(
        text: widget.subjectList[index]["taskdescription"]);

    setState(() {
      subjectList = widget.subjectList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (_, themeService, __) {
      return Scaffold(
        backgroundColor: themeService.subColor,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {},
              icon: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
              color: Colors.black,
            ),
            // backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "my",
                  style: TextStyle(
                      fontWeight: FontWeight.bold),
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: subjectName,
                            decoration: const InputDecoration(
                              labelText: "Subject Name",
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: subjectID,
                            decoration: const InputDecoration(
                              labelText: "Subject Id",
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: room,
                            decoration: const InputDecoration(
                              labelText: "Room",
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: startTimeController,
                                  decoration: const InputDecoration(
                                    labelText: "Start Time",
                                    suffixIcon: Icon(Icons.access_time),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (endTimeController.text.isNotEmpty) {
                                        final endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm()
                                                .parse(endTimeController.text));
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
                                        startTimeController.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                ),
                              ),
                              const Text("  -  "),
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: endTimeController,
                                  decoration: const InputDecoration(
                                    labelText: "End Time",
                                    suffixIcon: Icon(Icons.access_time),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (startTimeController.text.isNotEmpty) {
                                        final startTime =
                                            TimeOfDay.fromDateTime(
                                                DateFormat.jm().parse(
                                                    startTimeController.text));
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
                                        endTimeController.text =
                                            pickedTime.format(context);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: DropdownButtonFormField(
                                    value: widget.subjectList[index]["taskDay"]
                                        .toString(),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "Mon",
                                        child: Text("Mon"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Tue",
                                        child: Text("Tue"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Wed",
                                        child: Text("Wed"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Thu",
                                        child: Text("Thu"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Fri",
                                        child: Text("Fri"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Sat",
                                        child: Text("Sat"),
                                      ),
                                      DropdownMenuItem(
                                        value: "Sun",
                                        child: Text("Sun"),
                                      ),
                                      DropdownMenuItem(
                                        value: "MTh",
                                        child: Text("MTh"),
                                      ),
                                      DropdownMenuItem(
                                        value: "TuF",
                                        child: Text("TuF"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        studyDay.text = value.toString();
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
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: subjectDescription,
                            decoration: const InputDecoration(
                              labelText: "Enter Description",
                              border:
                                  OutlineInputBorder(borderSide: BorderSide()),
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
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Map<String, dynamic> subjectTask = {
                                  "taskname": subjectName.text,
                                  "taskID": subjectID.text,
                                  "taskroom": room.text,
                                  "tasktimeStart": startTimeController.text,
                                  "tasktimeEnd": endTimeController.text,
                                  "taskDay": studyDay.text,
                                  "taskmidterm": widget.subjectList[index]
                                      ["taskmidterm"],
                                  "taskStartmidterm": widget.subjectList[index]
                                      ["taskStartmidterm"],
                                  "taskEndmidterm": widget.subjectList[index]
                                      ["taskEndmidterm"],
                                  "taskfinal": widget.subjectList[index]
                                      ["taskfinal"],
                                  "taskStartfinal": widget.subjectList[index]
                                      ["taskStartfinal"],
                                  "taskEndfinal": widget.subjectList[index]
                                      ["taskEndfinal"],
                                  "taskdescription": subjectDescription.text,
                                };
                                subjectList[index] = subjectTask;
                                // print(subjectTask);
                                // print(subjectList);
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
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ScheduleManagement()));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff177C06),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                )),
                            child: const Text("EDIT"),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffD92D20),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                )),
                            child: const Text("CANCEL"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
