//-----------------------------------------------------------------------------
// menu_schedule.dart
// Aekkarit Surit 630510607 (Feature Should have: Import Schedule) )
//-----------------------------------------------------------------------------
// This file contains the function for import schedule from other user
//-----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/menu/menu.dart';
import '../examination/examdate_manage.dart';
import '../sch-management/schedule_management.dart';
import '../sch-view/schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/theme_management.dart';

// ----------------------------------------------------------------------------
// menu_schedule class
// ----------------------------------------------------------------------------
// This class is the menu for schedule. It will show the button for schedule
// ----------------------------------------------------------------------------
class MenuSchedule extends StatefulWidget {
  const MenuSchedule({super.key});

  @override
  State<MenuSchedule> createState() => _MenuScheduleState();
}

class _MenuScheduleState extends State<MenuSchedule> {
  /// Get current user from firebase auth
  User? user = FirebaseAuth.instance.currentUser;

  /// initialize subjectList for set data from firebase
  List subjectList = [];

  /// initialize uidList for set data from firebase
  List uidList = [];

  /// initialize uidimport for get data from textfield
  String uidimport = '';

  /// Get all uid from firebase
  initdata() async {
    /// initialize firebase
    await Firebase.initializeApp();

    /// get data from firebase
    final CollectionReference userstdl =
        FirebaseFirestore.instance.collection('users');
    final snapshot1 = await userstdl.get();
    setState(() {
      /// set data from firebase to uidList
      uidList = snapshot1.docs.map((e) => e.data()).toList();
    });
  }

  /// getdataFromfriend(frienduid)
  //
  // fetch data from firebase and store it in list subjectList to be displayed
  // in widget by fetching by frienduid parameter to retrieve the
  // information of that user.
  getdataFromfriend(frienduid) async {
    /// get data from firebase
    final CollectionReference taskschManagement = FirebaseFirestore.instance
        .collection('users')
        .doc(frienduid)
        .collection('subjectList');

    final snapshot = await taskschManagement.get();

    /// set data from firebase to subjectList
    setState(() {
      subjectList = snapshot.docs.map((e) => e.data()).toList();

      subjectList = subjectList[0]['subjectList'];
    });
  }

  // initState()
  //
  // The code provided is a Flutter function called initState(), which is
  // called the first time the widget is rendered on the screen. The widget
  // will be displayed on the screen. The intdata() function is called to
  // retrieve required data from other data sources such as databases and
  // prepare them to be passed to the corresponding widget. Calling
  // super.initState() invokes the widget's initState() function. The current
  // widget parent to initialize the widget to be ready for use.
  @override
  void initState() {
    super.initState();
    initdata();
  }

  @override
  Widget build(BuildContext context) {
    /// Get theme service
    return Consumer<ThemeService>(builder: (_, themeService, __) {
      return Scaffold(
        backgroundColor: themeService.subColor,
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Text(
              "my",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Schedule",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff6B4EFF)),
            ),
          ]),
          leading: IconButton(
            onPressed: () {
              /// Go back to previous page
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Menu();
              }));
            },
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Colors.black,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xff313866)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScheduleView(
                                title: '',
                              )),
                    );
                  },
                  child: const Text('Schedule View',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xff50409a)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScheduleManagement()),
                    );
                  },
                  child: const Text('Schedule Management',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xff313866)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExamListManagement()),
                    );
                  },
                  child: const Text('Examination Date',
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                /// Import schedule from other user Button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xff50409a)),
                  onPressed: () {
                    /// Show dialog for import schedule
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Import Schedule'),
                          content: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter UID',
                            ),

                            /// Get uid from textfield
                            onChanged: (value) {
                              /// set uidimport to value
                              uidimport = value;
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                /// Go back to previous page when click cancel
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                /// Check uid from firebase
                                bool check = false;
                                for (int i = 0; i < uidList.length; i++) {
                                  if (uidList[i]['uid'] == uidimport) {
                                    /// set check to true if uid is correct
                                    check = true;
                                    break;
                                  }
                                }

                                /// if uid is correct
                                if (check) {
                                  /// get Schedule from other user
                                  await getdataFromfriend(uidimport);

                                  /// set Schedule to firebase
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .collection('subjectList')
                                      .doc('subjectTask')
                                      .set({
                                        'subjectList': subjectList,
                                      }, SetOptions(merge: true))

                                      /// Show toast when import success
                                      .then((value) => Fluttertoast.showToast(
                                          msg: 'Import Success',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0))

                                      /// Show toast when import fail
                                      .catchError((error) =>
                                          Fluttertoast.showToast(
                                              msg: 'Import Fail',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0));
                                  // Go back to previous page
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
                      },
                    );
                  },
                  child: const Text(
                    'Import From Friend',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
