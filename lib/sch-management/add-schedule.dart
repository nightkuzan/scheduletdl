import 'package:flutter/material.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key, });
  
  @override
  State<AddSchedule> createState() => _AddSchedule();
}

class _AddSchedule extends State<AddSchedule> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  late TextEditingController _textController;
  late TimeOfDay time;

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

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: 'Select Time');
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios_new)),
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
                          decoration: const InputDecoration(
                            hintText: 'Subject',
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration:const InputDecoration(
                            hintText: 'Subject ID',
                            border:
                                OutlineInputBorder(borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Room',
                            border:
                                 OutlineInputBorder(borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller:
                                    _startTimeController, // set the text editing controller
                                decoration: InputDecoration(
                                  hintText: 'Example. 8.00 AM',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: () async {
                                      // Show time picker and update form field when user selects a time
                                      final TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
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
                                controller:
                                    _endTimeController, // set the text editing controller
                                decoration: InputDecoration(
                                  hintText: 'Example. 10.00 AM',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.access_time),
                                    onPressed: () async {
                                      // Show time picker and update form field when user selects a time
                                      final TimeOfDay? pickedTime =
                                          await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      );
                                      if (pickedTime != null) {
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: DropdownButton<String>(
                              value: selectedDay,
                              items: daysOfWeek.map((String day) {
                                return DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 0, 0, 0)),
                                  ),
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
                            hintText: 'Midterm Exam',
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.calendar_today_outlined)),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Midterm Exam',
                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.calendar_today_outlined)),
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
                          child: const Text("SAVE"),
                        ),
                      ),
                      const SizedBox(width: 20,),
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
