import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_planner/time_planner.dart';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class _ScheduleViewState extends State<ScheduleView> {
  List<TimePlannerTask> tasks = [];

  List<dynamic> plans = [
    {"subject": "OOP", "listday": 2, "startTime": 8, "minTime": 30, "studyTime": 90, "dayTime": 1, "code": "123", "building": "CSB100"},
    {"subject": "OOD", "listday": 4, "startTime": 11, "minTime": 0, "studyTime": 90, "dayTime": 1, "code": "444", "building": "CSB100"},
    {"subject": "Combinatorial", "listday": 0, "startTime": 11, "minTime": 0, "studyTime": 90, "dayTime": 1, "code": "555", "building": "CSB100"},
    {"subject": "Data Stucture", "listday": 1, "startTime": 9, "minTime": 30, "studyTime": 90, "dayTime": 1, "code": "666", "building": "CSB100"},
    {"subject": "Web application", "listday": 3, "startTime": 14, "minTime": 30, "studyTime": 90, "dayTime": 1, "code": "777", "building": "CSB100"},
    {"subject": "Data mining", "listday": 2, "startTime": 12, "minTime": 30, "studyTime": 90, "dayTime": 1, "code": "888", "building": "CSB100"},
  ];
  

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _addObject(context);
  }

  void _addObject(BuildContext context) {
    List<Color?> colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      const Color.fromARGB(255, 246, 43, 43)
    ];
    for (int i = 0; i < plans.length; i++) {
    setState(() {
      tasks.add(
        TimePlannerTask(
          color: colors[Random().nextInt(colors.length)],
          dateTime: TimePlannerDateTime(
              day: plans[i]["listday"], //วันไหน
              hour: plans[i]["startTime"], //เริ่มกี่โมง
              minutes: plans[i]["minTime"]), //นาทีที่
          minutesDuration: plans[i]["studyTime"], //นาทีแต่ละวิชา
          daysDuration: plans[i]["dayTime"], //วันที่เรียน
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                plans[i]["subject"],
                style:const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
              ),
              const SizedBox(width: 10,),
              Text(
                plans[i]["code"],
                style:const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
              )
                ],
              ),
              Text(
                plans[i]["building"],
                style:const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
              ),
            ],
          ),
        ),
      );
    });
  }}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      home: Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.start,
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: TimePlanner(
              startHour: 6,
              endHour: 18,
              style: TimePlannerStyle(
                // cellHeight: 60,
                cellWidth: 190,
                showScrollBar: true,
              ),
              headers: const [
                TimePlannerTitle(
                  title: "Monday",
                ),
                TimePlannerTitle(
                  title: "Tuesday",
                ),
                TimePlannerTitle(
                  title: "Wednesday",
                ),
                TimePlannerTitle(
                  title: "Thursday",
                ),
                TimePlannerTitle(
                  title: "Friday",
                ),
                TimePlannerTitle(
                  title: "Saturday",
                ),
                TimePlannerTitle(
                  title: "Sunday",
                ),
              ],
              tasks: tasks,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
}


