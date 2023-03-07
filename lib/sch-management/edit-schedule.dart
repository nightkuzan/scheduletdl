import 'package:flutter/material.dart';

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

  @override
  State<Editschedule> createState() => _Editschedule();
}

class _Editschedule extends State<Editschedule> {
  List<String> daysOfWeek = [
    'Select a day',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
    'MTh',
    'TuF',
  ];
  String selectedDay = 'Select a day';
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.taskname);
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     ElevatedButton(
                  //       onPressed: () {},
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: const Color(0xff177C06),
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10.0)),
                  //           textStyle: const TextStyle(
                  //             fontSize: 15,
                  //           )),
                  //       child: const Text("EDIT"),
                  //     ),
                  //     ElevatedButton(
                  //       onPressed: () {},
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: const Color(0xffD92D20),
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10.0)),
                  //           textStyle: const TextStyle(
                  //             fontSize: 15,
                  //           )),
                  //       child: const Text("DELETE"),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "${widget.taskname}" == ''
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
                            hintText: "${widget.taskID}" == ''
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
                            hintText: "${widget.taskRoom}" == ''
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
                                decoration: InputDecoration(
                                  hintText: "${widget.taskTimeStart}" == ''
                                      ? 'Time'
                                      : "${widget.taskTimeStart}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide()),
                                ),
                              ),
                            ),
                            const Text("  -  "),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "${widget.taskTimeEnd}" == ''
                                      ? 'Time'
                                      : "${widget.taskTimeEnd}",
                                  suffixIcon: const Icon(Icons.access_time),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide()),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // TextFormField(
                        //   decoration: InputDecoration(
                        //     hintText: "${widget.taskDay}" == '' ? 'Day' : "${widget.taskDay}",
                        //     border:
                        //         const OutlineInputBorder(borderSide: BorderSide()),
                        //   ),
                        // ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              value: selectedDay,
                              items: daysOfWeek.map((String day) {
                                return DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(day, style:const TextStyle(color: Color.fromARGB(255, 105, 105, 105)),),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDay = newValue!;
                                });
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: const Text('Select a day'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "${widget.taskMid}" == ''
                                ? 'Midterm Exam'
                                : "${widget.taskMid}",
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon:
                                    const Icon(Icons.calendar_today_outlined)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "${widget.taskFinal}" == ''
                                ? 'Final Exam'
                                : "${widget.taskFinal}",
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon:
                                    const Icon(Icons.calendar_today_outlined)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 120,
                          child: TextField(
                            maxLines: null,
                            expands: true,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Enter a description...',
                            ),
                          ),
                        )
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
