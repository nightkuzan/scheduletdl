import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Editschedule extends StatefulWidget {
  const Editschedule({
    super.key,
    required this.subjectList,
    required this.taskname,
    required this.taskID,
    required this.taskRoom,
    required this.taskTimeStart,
    required this.taskMid,
    required this.taskFinal,
    required this.taskTimeEnd,
    required this.taskDay,
    required this.taskStartmidterm,
    required this.taskEndmidterm,
    required this.taskStartfinal,
    required this.taskEndfinal,
    required this.taskdescription,
  });

  final List<dynamic> subjectList;
  final String taskname;
  final String taskID;
  final String taskRoom;
  final String taskTimeStart;
  final String taskMid;
  final String taskFinal;
  final String taskTimeEnd;
  final String taskDay;
  final String taskStartmidterm;
  final String taskEndmidterm;
  final String taskStartfinal;
  final String taskEndfinal;
  final String taskdescription;

  @override
  State<Editschedule> createState() => _Editschedule();
}

class _Editschedule extends State<Editschedule> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _studyDay = TextEditingController();
  final TextEditingController _examMiddate = TextEditingController();
  final TextEditingController _examFidate = TextEditingController();
  final TextEditingController _startMidTimeController = TextEditingController();
  final TextEditingController _endMidTimeController = TextEditingController();
  final TextEditingController _startFinalTimeController = TextEditingController();
  final TextEditingController _endFinalTimeController = TextEditingController();

  // List<String> daysOfWeek = [
  //   'Select a day',
  //   'Mon',
  //   'Tue',
  //   'Wed',
  //   'Thu',
  //   'Fri',
  //   'Sat',
  //   'Sun',
  //   'MTh',
  //   'TuF',
  // ];

  // late String selectedDay = widget.taskDay;

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.taskname);
    _studyDay.text = widget.taskDay;
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
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter New Subject Name",
                            labelText: "${widget.taskname}" == ''
                                ? 'Subject'
                                : "${widget.taskname}",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter New Subject ID",
                            labelText: "${widget.taskID}" == ''
                                ? 'Subject ID'
                                : "${widget.taskID}",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Enter New Room",
                            labelText: "${widget.taskRoom}" == ''
                                ? 'Room'
                                : "${widget.taskRoom}",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          ),
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
                                decoration: InputDecoration(
                                  hintText: "Enter New Subject Time Start",
                                  labelText: "${widget.taskTimeStart}" == ''
                                      ? 'Time'
                                      : "${widget.taskTimeStart}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
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
                                    if (_endTimeController.text.isNotEmpty) {
                                      final endTime = TimeOfDay.fromDateTime(
                                          DateFormat.jm()
                                              .parse(_endTimeController.text));
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
                            ),
                            const Text("  -  "),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                controller: _endTimeController,
                                decoration: InputDecoration(
                                  hintText: "Enter New Subject Time End",
                                  labelText: "${widget.taskTimeEnd}" == ''
                                      ? 'Time'
                                      : "${widget.taskTimeEnd}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
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
                                    if (_startTimeController.text.isNotEmpty) {
                                      final startTime = TimeOfDay.fromDateTime(
                                          DateFormat.jm().parse(
                                              _startTimeController.text));
                                      if (pickedTime.hour < startTime.hour ||
                                          (pickedTime.hour == startTime.hour &&
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
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.calendar_today),
                            hintText: "Select New Midterm Exam Date",
                            labelText: "${widget.taskMid}" == ''
                                ? 'Midterm Exam'
                                : "${widget.taskMid}",
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          ),
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
                                _examMiddate.text = formattedDate;
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
                                decoration: InputDecoration(
                                  hintText:
                                      "Select New Start Time Midterm Exam",
                                  labelText: "${widget.taskStartmidterm}" == ''
                                      ? 'Time'
                                      : "${widget.taskStartmidterm}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
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
                                    if (_endMidTimeController.text.isNotEmpty) {
                                      final endtimeMid = TimeOfDay.fromDateTime(
                                          DateFormat.jm().parse(
                                              _endMidTimeController.text));
                                      if (pickedTime.hour > endtimeMid.hour ||
                                          (pickedTime.hour == endtimeMid.hour &&
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
                                decoration: InputDecoration(
                                  hintText: "Select New End Time Midterm Exam",
                                  labelText: "${widget.taskEndmidterm}" == ''
                                      ? 'Time'
                                      : "${widget.taskEndmidterm}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
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
                                      final startMidTime = TimeOfDay
                                          .fromDateTime(DateFormat.jm().parse(
                                              _startMidTimeController.text));
                                      if (pickedTime.hour < startMidTime.hour ||
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
                          decoration: InputDecoration(
                            suffixIcon: const Icon(
                                Icons.calendar_today), //icon of text field
                            hintText: "Select New Final Exam Date",
                            labelText: "${widget.taskFinal}" == ''
                                ? 'Final Exam'
                                : "${widget.taskFinal}",
                            border: const OutlineInputBorder(
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
                                decoration: InputDecoration(
                                  hintText: "Select New Time Final Exam",
                                  labelText: "${widget.taskStartfinal}" == ''
                                      ? 'Time'
                                      : "${widget.taskStartfinal}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
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
                                      final endtimeFinal = TimeOfDay
                                          .fromDateTime(DateFormat.jm().parse(
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
                                decoration: InputDecoration(
                                  hintText: "Select New Time Final Exam",
                                  labelText: "${widget.taskEndfinal}" == ''
                                      ? 'Time'
                                      : "${widget.taskEndfinal}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
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
                                      final startFinalTime = TimeOfDay
                                          .fromDateTime(DateFormat.jm().parse(
                                              _startFinalTimeController.text));
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
                          onPressed: () {},
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
  }
}
