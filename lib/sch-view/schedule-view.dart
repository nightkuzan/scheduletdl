import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_planner/time_planner.dart';
import 'package:intl/intl.dart';

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
      "taskname": "Web application",
      "taskdescription": "Do math homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "9:30 AM",
      "tasktimeEnd": "11:00 AM",
      "taskDay": "TuF",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB209",
      "taskID": "204333"
    },
    {
      "index": 1,
      "taskname": "Mobile App",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "12:30 AM",
      "tasktimeEnd": "2:00 PM",
      "taskDay": "MTh",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204311"
    },
    {
      "index": 2,
      "taskname": "Fund Programming",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "8:00 AM",
      "tasktimeEnd": "9:00 AM",
      "taskDay": "Mon",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204111"
    },
    {
      "index": 3,
      "taskname": "OOD",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "12:30 AM",
      "tasktimeEnd": "2:00 PM",
      "taskDay": "Wed",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204362"
    },
  ];

  List<dynamic> startStudyHrs = [];
  List<dynamic> startMins = [];
  List<dynamic> durations = [];
  List<dynamic> dayValue = [
    {
      'Mon': 0,
      'Tue': 1,
      'Wed': 2,
      'Thu': 3,
      'Fri': 4,
      'Sat': 5,
      'Sun': 6,
      'MTh': 7,
      'TuF': 8,
    }
  ];

  Map<String, List<int>> twinDay = {
    'MTh': [0, 3],
    'TuF': [1, 4],
  };

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
      String timeStartString = plan["tasktimeStart"];
      String timeEndString = plan["tasktimeEnd"];

      DateTime timeStart = DateFormat.jm().parse(timeStartString);
      if (timeStart.hour == 12 &&
          (timeStart.timeZoneName == "AM" || timeStart.timeZoneName == "PM")) {
        timeStart = timeStart.add(const Duration(hours: -12));
      }
      String formattedTimeStart = DateFormat('HH.mm').format(timeStart);
      String start = formattedTimeStart.substring(0, 2);
      if (start == '00') {
        start = '12';
      }
      String minutesStart = formattedTimeStart.substring(3);

      DateTime timeEnd = DateFormat.jm().parse(timeEndString);
      if (timeEnd.hour == 12 &&
          (timeEnd.timeZoneName == "AM" || timeEnd.timeZoneName == "PM")) {
        timeEnd = timeEnd.add(const Duration(hours: -12));
      }
      String formattedTimeEnd = DateFormat('HH.mm').format(timeEnd);
      String end = formattedTimeEnd.substring(0, 2);
      if (end == '00') {
        end = '12';
      }
      String minutesEnd = formattedTimeEnd.substring(3);
      int startHour = int.parse(start);
      int endHour = int.parse(end);
      int startMinutes = int.parse(minutesStart);
      int endMinutes = int.parse(minutesEnd);
      startStudyHrs.add(startHour);
      startMins.add(startMinutes);
      int durationMinutes =
          (endHour * 60 + endMinutes) - (startHour * 60 + startMinutes);
      durations.add(durationMinutes);
    }
    for (int i = 0; i < plans.length; i++) {
      if (plans[i]["taskDay"] == 'Mon' ||
          plans[i]["taskDay"] == 'Tue' ||
          plans[i]["taskDay"] == 'Wed' ||
          plans[i]["taskDay"] == 'Thu' ||
          plans[i]["taskDay"] == 'Fri' ||
          plans[i]["taskDay"] == 'Sat' ||
          plans[i]["taskDay"] == 'Sun') {
        String taskDay = plans[i]["taskDay"];
        if (dayValue[0].containsKey(taskDay)) {
          int dayIndex = dayValue[0][taskDay];
          setState(() {
            tasks.add(
              TimePlannerTask(
                color: colors[Random().nextInt(colors.length)],
                dateTime: TimePlannerDateTime(
                    day: dayIndex, //วันไหน plans[i]["listday"]
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
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          });
        }
      } else if (plans[i]["taskDay"] == 'MTh' || plans[i]["taskDay"] == 'TuF') {
        if (plans[i]["taskDay"] == 'MTh' || plans[i]["taskDay"] == 'TuF') {
          List<int>? twinDayValues = twinDay[plans[i]["taskDay"]];
          for (int j = 0; j < twinDayValues!.length; j++) {
            setState(() {
              tasks.add(
                TimePlannerTask(
                  color: colors[Random().nextInt(colors.length)],
                  dateTime: TimePlannerDateTime(
                      day: twinDayValues[j], //วันไหน plans[i]["listday"]
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
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            });
          }
        }
      }
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
