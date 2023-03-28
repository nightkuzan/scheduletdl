// -----------------------------------------------------------------------------
// Tulakorn Sawangmuang 630510582 (Feature Must have: Schedule Management)
// Aekkarit Surit 630510607 (Feature Should have: Import Schedule)
//  ** Add feature importFromOtherUser  because feature should have is not enough **
// -----------------------------------------------------------------------------
// schedule_management.dart
// -----------------------------------------------------------------------------
//
// This file have ScheduleManagement class and contains functions for fetching data from firebase getdata(),
// fetching friend's task table from getdataFromfriend(frienduid) and initState()
// This function is called the first time when the widget is created to be displayed on the screen.
// This page shows the schedule or class schedule that we have saved and
// can also press the button to add tasks or import tasks into or can edit
// the saved data by clicking on the schedule or schedule. learn that you want to fix.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/menu/menu_schedule.dart';
import 'package:scheduletdl/sch-management/edit_schedule.dart';
import '../theme/theme_management.dart';
import 'add_schedule.dart';
import 'package:flutter/services.dart';

// -----------------------------------------------------------------------------
// ScheduleManagement
// -----------------------------------------------------------------------------
//
// The ScheduleManagement class have function getdata() and
// getdataFromfriend(frienduid), initState() to fetch data from firebase and initialize the
// widget before the widget is rendered and render the UI on the screen through the widget.

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({super.key});

  @override
  State<ScheduleManagement> createState() => _ScheduleManagement();
}

class _ScheduleManagement extends State<ScheduleManagement> {
  User? user = FirebaseAuth.instance.currentUser;
  late int index;

  List subjectList = [];
  List uidList = [];
  String uidimport = '';
  String uidUser = '';
  // getdata()
  //
  // Fetch data from firebase and store it in list
  // subjectList to display in widget.
  getdata() async {
    await Firebase.initializeApp();

    final CollectionReference taskschManagement = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('subjectList');

    final snapshot = await taskschManagement.get();

    final CollectionReference userstdl =
        FirebaseFirestore.instance.collection('users');
    final snapshot1 = await userstdl.get();

    uidUser = user!.uid;
    // for (int i = 0; i < uidList.length; i++) {
    //   print(1);
    //   if (uidList[i]['email'] == user!.email) {
    //     uidUser = uidList[i]['uid'];
    //   }
    // }

    setState(() {
      subjectList = snapshot.docs.map((e) => e.data()).toList();
      subjectList = subjectList[0]['subjectList'];
      uidList = snapshot1.docs.map((e) => e.data()).toList();
    });
  }

  // getdataFromfriend(frienduid)
  //
  // fetch data from firebase and store it in list subjectList to be displayed
  // in widget by fetching by frienduid parameter to retrieve the
  // information of that user.
  getdataFromfriend(frienduid) async {
    final CollectionReference taskschManagement = FirebaseFirestore.instance
        .collection('users')
        .doc(frienduid)
        .collection('subjectList');

    final snapshot = await taskschManagement.get();

    setState(() {
      subjectList = snapshot.docs.map((e) => e.data()).toList();
      subjectList = subjectList[0]['subjectList'];
    });
  }

  // initState()
  //
  // The code provided is a Flutter function called initState(), which is
  // called the first time the widget is rendered on the screen. The widget
  // will be displayed on the screen. The getdata() function is called to
  // retrieve required data from other data sources such as databases and
  // prepare them to be passed to the corresponding widget. Calling
  // super.initState() invokes the widget's initState() function. The current
  // widget parent to initialize the widget to be ready for use.
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
          // if don't have tasks
          if (snapshot.connectionState == ConnectionState.done &&
              subjectList.isEmpty) {
            // Use Consumer to get the current theme
            return Consumer<ThemeService>(builder: (_, themeService, __) {
              return Scaffold(
                  // set backgeound color to current theme
                  backgroundColor: themeService.subColor,
                  appBar: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const MenuSchedule();
                            },
                          ));
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: Colors.black,
                      ),
                      actions: [
                        /// add button
                        IconButton(
                          onPressed: () {
                            /// show dialog to import schedule
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Import Schedule'),
                                    content: TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Enter UID',
                                      ),

                                      /// get uid from textfield
                                      onChanged: (value) {
                                        /// set uid to uidimport
                                        uidimport = value;
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          /// close dialog when click cancel
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          /// Check uid from firebase
                                          bool check = false;
                                          for (int i = 0;
                                              i < uidList.length;
                                              i++) {
                                            if (uidList[i]['uid'] ==
                                                uidimport) {
                                              /// if uid is correct set check to true
                                              check = true;
                                              break;
                                            }
                                          }
                                          if (check) {
                                            /// if uid is correct call getdataFromfriend(uidimport)
                                            await getdataFromfriend(uidimport);

                                            /// set Schedule that import to firebase
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .collection('subjectList')
                                                .doc('subjectTask')
                                                .set({
                                                  'subjectList': subjectList,
                                                }, SetOptions(merge: true))

                                                /// show toast when import success
                                                .then((value) =>
                                                    Fluttertoast.showToast(
                                                        msg: "Import Success",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.green,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0))

                                                /// show toast when import fail
                                                .catchError((error) =>
                                                    Fluttertoast.showToast(
                                                        msg: "Import Fail",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.red,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0));

                                            /// Go to ScheduleManagement page
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ScheduleManagement()),
                                            );
                                          }
                                        },
                                        child: const Text('Import'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.import_export,
                            color: Colors.black,
                          ),
                        ),
                        // click to go to addschedule page
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Schedule",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Management",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6B4EFF)),
                          ),
                        ],
                      )),
                  body: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 20),
                          child: Row(
                            children: [
                              Text(
                                "uid ${user!.uid}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              // Iconbutton copy
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      new ClipboardData(text: uidUser));
                                  Fluttertoast.showToast(
                                      msg: "Copy Success",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                icon: const Icon(Icons.copy),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "No Task",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6B4EFF)),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 25, right: 20),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         "uid: $uidUser   ",
                        //         style: const TextStyle(
                        //             fontWeight: FontWeight.bold),
                        //       ),
                        //       // CopyTextButton(textToCopy: uidUser)
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ));
            });
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ThemeService>(builder: (_, themeService, __) {
              return Scaffold(
                backgroundColor: themeService.subColor,
                appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const MenuSchedule();
                          },
                        ));
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Colors.black,
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          /// show dialog to import schedule
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Import Schedule'),
                                  content: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter UID',
                                    ),

                                    /// get uid from textfield
                                    onChanged: (value) {
                                      /// set uid to uidimport
                                      uidimport = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        /// close dialog when click cancel
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        /// Check uid from firebase
                                        bool check = false;
                                        for (int i = 0;
                                            i < uidList.length;
                                            i++) {
                                          if (uidList[i]['uid'] == uidimport) {
                                            /// if uid is correct set check to true
                                            check = true;
                                            break;
                                          }
                                        }

                                        if (check) {
                                          /// if uid is correct call getdataFromfriend(uidimport)
                                          await getdataFromfriend(uidimport);

                                          /// set Schedule that import to firebase
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.uid)
                                              .collection('subjectList')
                                              .doc('subjectTask')
                                              .set({
                                                'subjectList': subjectList,
                                              }, SetOptions(merge: true))

                                              /// show toast when import success
                                              .then((value) =>
                                                  Fluttertoast.showToast(
                                                      msg: "Import Success",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.green,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0))

                                              /// show toast when import fail
                                              .catchError((error) =>
                                                  Fluttertoast.showToast(
                                                      msg: "Import Fail",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0));

                                          /// Go to ScheduleManagement page
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ScheduleManagement()));
                                        }
                                      },
                                      child: const Text('Import'),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(
                          Icons.import_export,
                          color: Colors.black,
                        ),
                      ),
                      // click to go to addschedule page
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Schedule",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: Row(
                          children: [
                            Text(
                              "uid: $uidUser   ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // Iconbutton copy
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    new ClipboardData(text: uidUser));
                                Fluttertoast.showToast(
                                    msg: "Copy Success",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                              icon: const Icon(Icons.copy),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: subjectList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: InkWell(
                                // click to go to Editchedule page
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Editschedule(
                                                index: index,
                                                subjectList: subjectList,
                                              )));
                                },
                                child: Card(
                                  color: index % 2 == 0
                                      ? const Color(0xff313866)
                                      : const Color(0xff50409a),
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
                                            color: Colors.black,
                                            onPressed: () {
                                              // alert for confirmation
                                              AlertDialog alert = AlertDialog(
                                                title: const Text(
                                                    'Delete Subject'),
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
                                                        FirebaseFirestore
                                                            .instance
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
                                                                    merge:
                                                                        true));
                                                      });
                                                      Navigator.pop(context);
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Subject Deleted',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.green,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 20.0);
                                                    },
                                                    child: const Text('Delete'),
                                                  ),
                                                ],
                                              );

                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            },
                                          ),
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
            });
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
