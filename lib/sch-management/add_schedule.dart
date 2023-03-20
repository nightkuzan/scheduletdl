import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:scheduletdl/sch-management/schedule_management.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({
    super.key,
  });

  @override
  State<AddSchedule> createState() => _AddSchedule();
}

class _AddSchedule extends State<AddSchedule> {
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _subjectName = TextEditingController();
  final TextEditingController _subjectID = TextEditingController();
  final TextEditingController _room = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _studyDay = TextEditingController();
  final TextEditingController _startMidTimeController = TextEditingController();
  final TextEditingController _endMidTimeController = TextEditingController();
  final TextEditingController _startFinalTimeController = TextEditingController();
  final TextEditingController _endFinalTimeController = TextEditingController();
  final TextEditingController _examMiddate = TextEditingController();
  final TextEditingController _examFidate = TextEditingController();
  final TextEditingController _subjectDescription = TextEditingController();
  late TimeOfDay time;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
    _studyDay.text = "Mon";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "my",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _subjectName,
                          decoration: const InputDecoration(
                            labelText: 'Subject',
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _subjectID,
                          decoration: const InputDecoration(
                            labelText: 'Subject ID',
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
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _room,
                          decoration: const InputDecoration(
                            labelText: 'Room',
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: _startTimeController,
                                decoration: const InputDecoration(
                                  labelText: "Start Time",
                                  suffixIcon: Icon(Icons.access_time),
                                  border:  OutlineInputBorder(
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
                                        if (_endTimeController
                                            .text.isNotEmpty) {
                                          final endTime =
                                              TimeOfDay.fromDateTime(
                                                  DateFormat.jm().parse(
                                                      _endTimeController.text));
                                          if (pickedTime.hour > endTime.hour ||
                                              (pickedTime.hour ==
                                                      endTime.hour &&
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
                                          _startTimeController.text =
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
                                controller: _endTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'End time',
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
                                        if (_startTimeController
                                            .text.isNotEmpty) {
                                          final startTime =
                                              TimeOfDay.fromDateTime(
                                                  DateFormat.jm().parse(
                                                      _startTimeController
                                                          .text));
                                          if (pickedTime.hour <
                                                  startTime.hour ||
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
                                          _endTimeController.text =
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
                            value: _studyDay.text,
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
                                _studyDay.text = value.toString();
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
                        controller: _examMiddate,
                        decoration: const InputDecoration(
                            suffixIcon:
                                Icon(Icons.calendar_today), 
                            labelText: "Midterm date",
                                border: OutlineInputBorder(
                                borderSide: BorderSide()),),
                        readOnly: true,
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
                              _examMiddate.text =
                                  formattedDate; 
                            });
                          } else {}
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
                                controller: _startMidTimeController,
                                decoration: const InputDecoration(
                                  labelText: "Start Time Midterm",
                                  suffixIcon: Icon(Icons.access_time),
                                  border:  OutlineInputBorder(
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
                                        if (_endMidTimeController
                                            .text.isNotEmpty) {
                                          final endtimeMid =
                                              TimeOfDay.fromDateTime(
                                                  DateFormat.jm().parse(
                                                      _endMidTimeController.text));
                                          if (pickedTime.hour > endtimeMid.hour ||
                                              (pickedTime.hour ==
                                                      endtimeMid.hour &&
                                                  pickedTime.minute >
                                                      endtimeMid.minute)) {
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
                                          _startMidTimeController.text =
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
                                controller: _endMidTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'End time Midterm',
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
                                        if (_startMidTimeController
                                            .text.isNotEmpty) {
                                          final startMidTime =
                                              TimeOfDay.fromDateTime(
                                                  DateFormat.jm().parse(
                                                      _startMidTimeController
                                                          .text));
                                          if (pickedTime.hour <
                                                  startMidTime.hour ||
                                              (pickedTime.hour ==
                                                      startMidTime.hour &&
                                                  pickedTime.minute <
                                                      startMidTime.minute)) {
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
                                          _endMidTimeController.text =
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
                        TextFormField(
                        controller: _examFidate,
                        decoration:const InputDecoration(
                            suffixIcon:
                               Icon(Icons.calendar_today), //icon of text field
                            labelText: "Final date",
                            border: OutlineInputBorder(
                                borderSide: BorderSide()), //label text of field
                            ),
                        readOnly: true,
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
                              _examFidate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
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
                                controller: _startFinalTimeController,
                                decoration: const InputDecoration(
                                  labelText: "Start Time Final",
                                  suffixIcon: Icon(Icons.access_time),
                                  border:  OutlineInputBorder(
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
                                        if (_endFinalTimeController
                                            .text.isNotEmpty) {
                                          final endtimeFinal =
                                              TimeOfDay.fromDateTime(
                                                  DateFormat.jm().parse(
                                                      _endFinalTimeController.text));
                                          if (pickedTime.hour > endtimeFinal.hour ||
                                              (pickedTime.hour ==
                                                      endtimeFinal.hour &&
                                                  pickedTime.minute >
                                                      endtimeFinal.minute)) {
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
                                          _startFinalTimeController.text =
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
                                controller: _endFinalTimeController,
                                decoration: const InputDecoration(
                                  labelText: 'End time Final',
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
                                        if (_startFinalTimeController
                                            .text.isNotEmpty) {
                                          final startFinalTime =
                                              TimeOfDay.fromDateTime(
                                                  DateFormat.jm().parse(
                                                      _startFinalTimeController
                                                          .text));
                                          if (pickedTime.hour <
                                                  startFinalTime.hour ||
                                              (pickedTime.hour ==
                                                      startFinalTime.hour &&
                                                  pickedTime.minute <
                                                      startFinalTime.minute)) {
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
                                          _endFinalTimeController.text =
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
                        TextFormField(
                      controller: _subjectDescription,
                      decoration: const InputDecoration(
                        hintText: 'Enter some description. . .',
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
                            if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> subjectTask = {
                      "taskname": _subjectName.text,
                      "taskID": _subjectID.text,
                      "taskroom": _room.text,
                      "tasktimeStart": _startTimeController.text,
                      "tasktimeEnd": _endTimeController.text,
                      "taskDay": _studyDay.text,
                      "taskmidterm": _examMiddate.text,
                      "taskStartmidterm": _startMidTimeController.text,
                      "taskEndmidterm": _endMidTimeController.text,
                      "taskfinal": _examFidate.text,
                      "taskStartfinal": _startFinalTimeController.text,
                      "taskEndfinal": _endFinalTimeController.text,
                      "taskdescription": _subjectDescription.text,
                      
                    };
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user?.uid)
                        .collection('subjectList')
                        .doc('subjectTask')
                        .set(
                      {
                        'subjectList': FieldValue.arrayUnion([subjectTask])
                      },
                      SetOptions(merge: true),
                    );
                    // pop and return to previous page and refresh
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ScheduleManagement()));
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
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff177C06),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              textStyle: const TextStyle(
                                fontSize: 18,
                              )),
                          child: const Text("SAVE"),
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
  }
}
