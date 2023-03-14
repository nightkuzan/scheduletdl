import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scheduletdl/sch-management/edit-schedule.dart';

import 'add-schedule.dart';

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({super.key});

  @override
  State<ScheduleManagement> createState() => _ScheduleManagement();
}

class _ScheduleManagement extends State<ScheduleManagement> {
  User? user = FirebaseAuth.instance.currentUser;
  // bool _isNotificationActive = false;

  // List<Color?> colors = [
  //   const Color(0xffF198AF),
  //   const Color.fromARGB(255, 255, 198, 201),
  //   // const Color(0xFFEBB2D6),
  //   // const Color(0xFF9F81CD),
  //   // const Color(0xFF766DC1),
  //   // Colors.green,
  //   // Colors.orange,
  //   // const Color.fromARGB(255, 246, 43, 43),
  //   // const Color.fromARGB(255, 54, 228, 191),
  //   // const Color.fromARGB(255, 255, 183, 211),
  // ];

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

  late int index;
  late List<bool> _isSelectedList;

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
                                              index: index,
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
                                // color: colors[Random().nextInt(colors.length)],
                                color: index % 2 == 0
                                    ? const Color(0xffF198AF)
                                    : const Color.fromARGB(255, 255, 198, 201),
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
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            // alert for confirmation
                                            AlertDialog alert = AlertDialog(
                                              title:
                                                  const Text('Delete Subject'),
                                              content: const Text(
                                                  'Are you sure you want to delete this Subject?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      subjectList
                                                          .removeAt(index);
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(user!.uid)
                                                          .collection(
                                                              'subjectList')
                                                          .doc('subjectTask')
                                                          .set(
                                                              {
                                                            'subjectList':
                                                                subjectList
                                                          },
                                                              SetOptions(
                                                                  merge: true));
                                                    });
                                                    Navigator.pop(context);
                                                    Fluttertoast.showToast(
                                                        msg: 'Subject Deleted',
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 20.0);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            );

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return alert;
                                              },
                                            );
                                            // show toast message for notification of deletion
                                          },
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            // _toggleSelection(index);
                                          },
                                          // icon: Icon(_isSelectedList[index]
                                          //     ? Icons.notifications_active
                                          //     : Icons.notifications),
                                          icon: const Icon(Icons.notifications_active)
                                              
                                        )
                                      ],
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
