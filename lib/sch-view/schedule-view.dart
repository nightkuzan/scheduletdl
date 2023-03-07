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
    {
      "index": 0,
      "taskname": "Math",
      "taskdescription": "Do math homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "09:30",
      "tasktimeEnd": "11:00",
      "taskDay": "TuF",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB209",
      "taskID": "204441"
    },
    {
      "index": 1,
      "taskname": "English",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "12:30",
      "tasktimeEnd": "14:00",
      "taskDay": "MTh",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204333"
    },
  ];

  List<dynamic> startStudyHrs = [];
  List<dynamic> startMins = [];
  List<dynamic> durations = [];

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
      const Color.fromARGB(255, 246, 43, 43),
      const Color.fromARGB(255, 54, 228, 191),
      const Color.fromARGB(255, 255, 183, 211),
      const Color.fromARGB(255, 63, 61, 103),
    ];
    for (var plan in plans) {
      String start = plan["tasktimeStart"]?.substring(0, 2);
      String minutes = plan["tasktimeStart"]?.substring(3);
      var startTime = DateTime.parse("2022-03-07 ${plan['tasktimeStart']}:00");
      var endTime = DateTime.parse("2022-03-07 ${plan['tasktimeEnd']}:00");
      var duration = endTime.difference(startTime);
      var durationInMinutes = duration.inMinutes;
      int startStudyHr = int.parse(start);
      int startMin = int.parse(minutes);
      startStudyHrs.add(startStudyHr);
      startMins.add(startMin);
      durations.add(durationInMinutes);
    }
    for (int i = 0; i < plans.length; i++) {
      setState(() {
        tasks.add(
          TimePlannerTask(
            color: colors[Random().nextInt(colors.length)],
            dateTime: TimePlannerDateTime(
                day: 1, //วันไหน plans[i]["listday"]
                hour: startStudyHrs[i]!, //เริ่มกี่โมง
                minutes: startMins[i]!), //นาทีที่
            minutesDuration:
                durations[i]!, //นาทีแต่ละวิชา plans[i]["studyTime"]
            daysDuration: 1, //วันที่เรียน  plans[i]["dayTime"]
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      plans[i]["taskname"],
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      plans[i]["taskID"],
                      style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14),
                    )
                  ],
                ),
                Text(
                  plans[i]["taskroom"],
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                ),
              ],
            ),
          ),
        );
      });
    }
  }

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
