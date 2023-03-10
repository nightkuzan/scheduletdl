import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scheduletdl/sch-management/edit-schedule.dart';

import 'add-schedule.dart';

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({super.key});

  @override
  State<ScheduleManagement> createState() => _ScheduleManagement();
}

class _ScheduleManagement extends State<ScheduleManagement> {
  User? user = FirebaseAuth.instance.currentUser;

  List<Color?> colors = [
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.orange,
    const Color.fromARGB(255, 246, 43, 43),
    const Color.fromARGB(255, 54, 228, 191),
    const Color.fromARGB(255, 255, 183, 211),
  ];

  List subjectList = [];

  getdata() async {
    // Initialize Firebase

    await Firebase.initializeApp();

    final CollectionReference taskschManagement = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('subjectList');

    final snapshot = await taskschManagement.get();
    setState(() {
      subjectList = snapshot.docs.map((e) => e.data()).toList();
      subjectList = subjectList[0]['subjectList'];
    });
    // print(subjectList);
  }
  // List<dynamic> subjectList = [
  //   {
  //     "taskname": "Math",
  //     "taskID": "204441",
  //     "taskroom": "CSB209",
  //     "tasktimeStart": "9:30 AM",
  //     "tasktimeEnd": "11:00 AM",
  //     "taskDay": "TuF",
  //     "taskmidterm": "2021-10-10",
  //     "taskStartmidterm": "3.30 PM",
  //     "taskEndmidterm": "6.30 PM",
  //     "taskfinal": "2021-12-12",
  //     "taskStartfinal": "3.30 PM",
  //     "taskEndfinal": "4.30 PM",
  //     "taskdescription": "Do math homework",
  //   },
  //   {
  //     "taskname": "English",
  //     "taskdescription": "Do english homework",
  //     "taskmidterm": "2021-10-10",
  //     "taskStartmidterm": "3.30 PM",
  //     "taskEndmidterm": "6.30 PM",
  //     "taskfinal": "2021-12-12",
  //     "taskStartfinal": "3.30 PM",
  //     "taskEndfinal": "4.30 PM",
  //     "tasktimeStart": "12:30",
  //     "tasktimeEnd": "14:00",
  //     "taskDay": "MTh",
  //     "taskroom": "CSB210",
  //     "taskID": "204333"
  //   },
  //   {
  //     "taskname": "English",
  //     "taskdescription": "Do english homework",
  //     "taskmidterm": "2021-10-10",
  //     "taskStartmidterm": "3.30 PM",
  //     "taskEndmidterm": "6.30 PM",
  //     "taskfinal": "2021-12-12",
  //     "taskStartfinal": "3.30 PM",
  //     "taskEndfinal": "4.30 PM",
  //     "tasktimeStart": "12:30",
  //     "tasktimeEnd": "14:00",
  //     "taskDay": "MTh",
  //     "taskroom": "CSB210",
  //     "taskID": "204333"
  //   },
  //   {
  //     "taskname": "English",
  //     "taskdescription": "Do english homework",
  //     "taskmidterm": "2021-10-10",
  //     "taskStartmidterm": "3.30 PM",
  //     "taskEndmidterm": "6.30 PM",
  //     "taskfinal": "2021-12-12",
  //     "taskStartfinal": "3.30 PM",
  //     "taskEndfinal": "4.30 PM",
  //     "tasktimeStart": "12:30",
  //     "tasktimeEnd": "14:00",
  //     "taskDay": "MTh",
  //     "taskroom": "CSB210",
  //     "taskID": "204333"
  //   },
  //   {
  //     "taskname": "English",
  //     "taskdescription": "Do english homework",
  //     "taskmidterm": "2021-10-10",
  //     "taskStartmidterm": "3.30 PM",
  //     "taskEndmidterm": "6.30 PM",
  //     "taskfinal": "2021-12-12",
  //     "taskStartfinal": "3.30 PM",
  //     "taskEndfinal": "4.30 PM",
  //     "tasktimeStart": "12:30",
  //     "tasktimeEnd": "14:00",
  //     "taskDay": "MTh",
  //     "taskroom": "CSB210",
  //     "taskID": "204333"
  //   },
  // ];

  late int index;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<FirebaseApp> firebase = Firebase.initializeApp();

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
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: Colors.black,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddSchedule()));
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                  ],
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Schedule",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Management",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B4EFF)),
                      ),
                    ],
                  )),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: subjectList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Editschedule(
                                              subjectList: subjectList,
                                              taskname: subjectList[index]
                                                  ["taskname"],
                                              taskID: subjectList[index]
                                                  ["taskID"],
                                              taskRoom: subjectList[index]
                                                  ["taskroom"],
                                              taskTimeStart: subjectList[index]
                                                  ["tasktimeStart"],
                                              taskTimeEnd: subjectList[index]
                                                  ["tasktimeEnd"],
                                              taskDay: subjectList[index]
                                                  ["taskDay"],
                                              taskMid: subjectList[index]
                                                  ["taskmidterm"],
                                              taskFinal: subjectList[index]
                                                  ["taskfinal"],
                                              taskStartmidterm:
                                                  subjectList[index]
                                                      ["taskStartmidterm"],
                                              taskEndmidterm: subjectList[index]
                                                  ["taskEndmidterm"],
                                              taskStartfinal: subjectList[index]
                                                  ["taskStartfinal"],
                                              taskEndfinal: subjectList[index]
                                                  ["taskEndfinal"],
                                              taskdescription:
                                                  subjectList[index]
                                                      ["taskdescription"],
                                            )));
                              },
                              child: Card(
                                color: colors[Random().nextInt(colors.length)],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      subjectList[index]["taskID"] +
                                          " : " +
                                          subjectList[index]["taskname"],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: (subjectList[index]
                                                    ["tasktimeStart"]) +
                                                ' - ' +
                                                (subjectList[index]
                                                    ["tasktimeEnd"]) +
                                                ' ' +
                                                (subjectList[index]
                                                    ["taskDay"]) +
                                                "\n",
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text: (subjectList[index]
                                                ["taskroom"]),
                                            style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
        });
  }
}
