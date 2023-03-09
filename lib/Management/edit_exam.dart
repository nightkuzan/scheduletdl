import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditExamDate extends StatefulWidget {
  const EditExamDate({super.key});
  // final String examMidStart;
  // final String examMidEnd;
  // final String examFiStart;
  // final String examFiEnd;

  // final String taskMid;
  // final String taskFinal;
  // final String taskTimeEnd;
  // final String taskDay;

  @override
  State<EditExamDate> createState() => _EditExamDateState();
}

class _EditExamDateState extends State<EditExamDate> {
  final TextEditingController _examMiddate = TextEditingController();
  final TextEditingController _examFidate = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
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
                        controller: _examMiddate,
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
                              _examMiddate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startTimeController,
                              decoration: InputDecoration(
                                hintText: "เวลา1" == '' ? 'เวลา2' : "เวลา3",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (_endTimeController.text.isNotEmpty) {
                                        final endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm().parse(
                                                _endTimeController.text));
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
                                        _startTimeController.text =
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
                              controller: _endTimeController,
                              decoration: InputDecoration(
                                hintText: "เวลา4" == '' ? 'เวลา5' : "เวลา6",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
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
                                                    _startTimeController.text));
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
                                        _endTimeController.text =
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
                        controller: _examFidate,
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
                              _examFidate.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startTimeController,
                              decoration: InputDecoration(
                                hintText: "เวลา1" == '' ? 'เวลา2' : "เวลา3",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
                                    final TimeOfDay? pickedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (pickedTime != null) {
                                      if (_endTimeController.text.isNotEmpty) {
                                        final endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm().parse(
                                                _endTimeController.text));
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
                                        _startTimeController.text =
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
                              controller: _endTimeController,
                              decoration: InputDecoration(
                                hintText: "เวลา4" == '' ? 'เวลา5' : "เวลา6",
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.access_time),
                                  onPressed: () async {
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
                                                    _startTimeController.text));
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
                                        _endTimeController.text =
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
