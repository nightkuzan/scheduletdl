// -----------------------------------------------------------------------------
// Tulakorn Sawangmuang 630510582 (Feature Must have: Schedule Management)
// -----------------------------------------------------------------------------
// schedule_view.dart
// -----------------------------------------------------------------------------
//
// This file contains the ScheduleView and MyCustomScrollBehavior classes.
// There are functions to fetch data from firebase getdata() and 
// initState() to prepare the data to be displayed or used in the widget, 
// and _addObject(BuildContext context) to display the data in the time 
// planner and dispose() to set the screen horizontally and display the data in the widget.

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

// -----------------------------------------------------------------------------
// ScheduleView
// -----------------------------------------------------------------------------
//
// The class defines several instance variables, including a User object obtained from Firebase Authentication, 
// a list of TimePlannerTask objects, and several lists of dynamic objects that will be used to extract information 
// from a subjectList collection in the Firebase Firestore database. have function getdata() to fetch data from the Firestore, 
// initState() sets the preferred device orientations, _addObject() to add task in timePlanner,
// dispose() to change screen to horizontally in this class and display screen in widget.
class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

// -----------------------------------------------------------------------------
// MyCustomScrollBehavior
// -----------------------------------------------------------------------------
//
// The CustomScrollBehavior class Acts to scroll the screen if we use it through the browser
class MyCustomScrollBehavior extends MaterialScrollBehavior {
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

  // getdata()
  //
  // The getdata method initializes Firebase, obtains a reference to a collection of documents within Firestore, 
  // retrieves a snapshot of the collection, and maps the snapshot to a list of dynamic objects. The method then extracts 
  // the subjectList field from the first object in the list and calls the _addObject method to populate the tasks list 
  // with TimePlannerTask objects.
  getdata() async {

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

  // initState()
  //
  // The initState method initializes the app's state, sets the preferred device orientations, 
  //and calls the getdata method to populate the state with data from Firebase Firestore.
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

  // _addObject(BuildContext context)
  //
  // The _addObject method initializes a list of Color objects, then iterates through the subjectList list 
  // to extract start and end times, calculate duration, and add the appropriate TimePlannerTask object to the tasks list. 
  // The TimePlannerTask object contains information about the timing, duration, 
  // and content of each task to be displayed in the ScheduleView.
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

      // format time in string to time
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

      // format time in string to time
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
    // loop for timeplanner
    for (int i = 0; i < subjectList.length; i++) {
      // condition to add in timeplanner
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
                    day: dayIndex, 
                    hour: startStudyHrs[i]!,
                    minutes: startMins[i]!), 
                minutesDuration:
                    durations[i]!, 
                daysDuration: 1, 
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
        // condition to add in timeplanner if MTh or TuF
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
                      day: twinDayValues[j], 
                      hour: startStudyHrs[i]!,
                      minutes: startMins[i]!), 
                  minutesDuration:
                      durations[i]!, 
                  daysDuration: 1,
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
          // when tasks is empty
          if (snapshot.connectionState == ConnectionState.done &&
              subjectList.isEmpty) {
                // use consumer to change theme to current theme
            return Consumer<ThemeService>(builder: (_, themeService, __) {
              return MaterialApp(
                // change app bar theme to current theme
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
            // use consumer to change theme to current theme
            return Consumer<ThemeService>(builder: (_, themeService, __) {
              return MaterialApp(
                // change app bar theme to current theme
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

  // dispose()
  //
  // This function dispose() to set the screen horizontally
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
