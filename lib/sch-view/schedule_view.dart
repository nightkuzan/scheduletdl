import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_planner/time_planner.dart';
import 'package:intl/intl.dart';

import '../theme/theme_management.dart';

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
  User? user = FirebaseAuth.instance.currentUser;
  List<TimePlannerTask> tasks = [];
  List<dynamic> subjectList = [];

  getdata() async {
    // Initialize Firebase

    await Firebase.initializeApp();

    final CollectionReference taskView = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('subjectList');

    final snapshot = await taskView.get();
    setState(() {
      subjectList = snapshot.docs.map((e) => e.data()).toList();
      subjectList = subjectList[0]['subjectList'];
      _addObject(context);
    });
  }

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
    getdata();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future<FirebaseApp> firebase = Firebase.initializeApp();

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
    for (var plan in subjectList) {
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
    for (int i = 0; i < subjectList.length; i++) {
      if (subjectList[i]["taskDay"] == 'Mon' ||
          subjectList[i]["taskDay"] == 'Tue' ||
          subjectList[i]["taskDay"] == 'Wed' ||
          subjectList[i]["taskDay"] == 'Thu' ||
          subjectList[i]["taskDay"] == 'Fri' ||
          subjectList[i]["taskDay"] == 'Sat' ||
          subjectList[i]["taskDay"] == 'Sun') {
        String taskDay = subjectList[i]["taskDay"];
        if (dayValue[0].containsKey(taskDay)) {
          int dayIndex = dayValue[0][taskDay];
          setState(() {
            tasks.add(
              TimePlannerTask(
                color: colors[Random().nextInt(colors.length)],
                dateTime: TimePlannerDateTime(
                    day: dayIndex, //วันไหน subjectList[i]["listday"]
                    hour: startStudyHrs[i]!, //เริ่มกี่โมง
                    minutes: startMins[i]!), //นาทีที่
                minutesDuration:
                    durations[i]!, //นาทีแต่ละวิชา subjectList[i]["studyTime"]
                daysDuration: 1, //วันที่เรียน  subjectList[i]["dayTime"]
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          subjectList[i]["taskname"],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          subjectList[i]["taskID"],
                          style: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14),
                        )
                      ],
                    ),
                    Text(
                      subjectList[i]["taskroom"],
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
      } else if (subjectList[i]["taskDay"] == 'MTh' ||
          subjectList[i]["taskDay"] == 'TuF') {
        if (subjectList[i]["taskDay"] == 'MTh' ||
            subjectList[i]["taskDay"] == 'TuF') {
          List<int>? twinDayValues = twinDay[subjectList[i]["taskDay"]];
          for (int j = 0; j < twinDayValues!.length; j++) {
            setState(() {
              tasks.add(
                TimePlannerTask(
                  color: colors[Random().nextInt(colors.length)],
                  dateTime: TimePlannerDateTime(
                      day: twinDayValues[j], //วันไหน subjectList[i]["listday"]
                      hour: startStudyHrs[i]!, //เริ่มกี่โมง
                      minutes: startMins[i]!), //นาทีที่
                  minutesDuration:
                      durations[i]!, //นาทีแต่ละวิชา subjectList[i]["studyTime"]
                  daysDuration: 1, //วันที่เรียน  subjectList[i]["dayTime"]
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            subjectList[i]["taskname"],
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            subjectList[i]["taskID"],
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 14),
                          )
                        ],
                      ),
                      Text(
                        subjectList[i]["taskroom"],
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
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Error initializing Firebase'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              subjectList.isEmpty) {
            return Consumer<ThemeService>(builder: (_, themeService, __) {
              return MaterialApp(
                theme: ThemeData(primarySwatch: themeService.color),
                scrollBehavior: MyCustomScrollBehavior(),
                home: Scaffold(
                  backgroundColor: themeService.subColor,
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Schedule",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6B4EFF)),
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
            });
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ThemeService>(builder: (_, themeService, __) {
              return MaterialApp(
                theme: ThemeData(primarySwatch: themeService.color),
                scrollBehavior: MyCustomScrollBehavior(),
                home: Scaffold(
                  backgroundColor: themeService.subColor,
                  appBar: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: Colors.black,
                      ),
                      // backgroundColor: Colors.white,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            "my",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Schedule",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6B4EFF)),
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
            });
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
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
