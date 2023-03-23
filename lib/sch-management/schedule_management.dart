import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/sch-management/edit_schedule.dart';

import '../theme/theme_management.dart';
import 'add_schedule.dart';

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

  getdata() async {
    // Initialize Firebase

    await Firebase.initializeApp();

    final CollectionReference taskschManagement = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('subjectList');

    final snapshot = await taskschManagement.get();

    final CollectionReference userstdl =
        FirebaseFirestore.instance.collection('users');
    final snapshot1 = await userstdl.get();

    setState(() {
      subjectList = snapshot.docs.map((e) => e.data()).toList();
      subjectList = subjectList[0]['subjectList'];
      uidList = snapshot1.docs.map((e) => e.data()).toList();
    });
  }

  getdataFromfriend(frienduid) async {
    // Initialize Firebase

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

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<FirebaseApp> firebase = Firebase.initializeApp();

  String uidimport = '';

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
              return Scaffold(
                  backgroundColor: themeService.subColor,
                  appBar: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new),
                        color: Colors.black,
                      ),
                      actions: [
                        // import button
                        IconButton(
                          onPressed: () {
                            //  show dialog for input uid of friend
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Import Schedule'),
                                    content: TextField(
                                      decoration: const InputDecoration(
                                        hintText: 'Enter UID',
                                      ),
                                      onChanged: (value) {
                                        uidimport = value;
                                      },
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // check uid is exist
                                          bool check = false;
                                          for (int i = 0;
                                              i < uidList.length;
                                              i++) {
                                            if (uidList[i]['uid'] ==
                                                uidimport) {
                                              check = true;
                                              break;
                                            }
                                          }

                                          if (check) {
                                            await getdataFromfriend(uidimport);

                                            // remove all schedule
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .collection('subjectList')
                                                .doc('subjectTask')
                                                .set({
                                                  'subjectList': subjectList,
                                                }, SetOptions(merge: true))
                                                // flutter toast
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

                                            // replacement new schedule
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
                      // backgroundColor: Colors.white,
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
                  body: const Center(
                    child: Text(
                      "No Task",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6B4EFF)),
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
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Colors.black,
                    ),
                    actions: [
                      // import button
                      IconButton(
                        onPressed: () {
                          //  show dialog for input uid of friend
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Import Schedule'),
                                  content: TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Enter UID',
                                    ),
                                    onChanged: (value) {
                                      uidimport = value;
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        // check uid is exist
                                        bool check = false;
                                        for (int i = 0;
                                            i < uidList.length;
                                            i++) {
                                          if (uidList[i]['uid'] == uidimport) {
                                            check = true;
                                            break;
                                          }
                                        }

                                        if (check) {
                                          await getdataFromfriend(uidimport);

                                          // remove all schedule
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user!.uid)
                                              .collection('subjectList')
                                              .doc('subjectTask')
                                              .set({
                                                'subjectList': subjectList,
                                              }, SetOptions(merge: true))
                                              // flutter toast
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

                                          // replacement new schedule
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
                    // backgroundColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Schedule",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,),
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
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: InkWell(
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
                                              // show toast message for notification of deletion
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
