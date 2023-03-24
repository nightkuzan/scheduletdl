import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../examination/examdate_manage.dart';
import '../sch-management/schedule_management.dart';
import '../sch-view/schedule_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../theme/theme_management.dart';

class MenuSchedule extends StatefulWidget {
  const MenuSchedule({super.key});

  @override
  State<MenuSchedule> createState() => _MenuScheduleState();
}

class _MenuScheduleState extends State<MenuSchedule> {
  User? user = FirebaseAuth.instance.currentUser;
  List subjectList = [];
  List uidList = [];
  String uidimport = '';

  initdata() async {
    await Firebase.initializeApp();
    final CollectionReference userstdl =
        FirebaseFirestore.instance.collection('users');

    final snapshot1 = await userstdl.get();
    setState(() {
      uidList = snapshot1.docs.map((e) => e.data()).toList();
    });
  }

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

  @override
  void initState() {
    super.initState();
    initdata();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.pop(context);
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xff50409a)),
                  onPressed: () {
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
                                bool check = false;
                                for (int i = 0; i < uidList.length; i++) {
                                  if (uidList[i]['uid'] == uidimport) {
                                    check = true;
                                    break;
                                  }
                                }
                                if (check) {
                                  await getdataFromfriend(uidimport);
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user!.uid)
                                      .collection('subjectList')
                                      .doc('subjectTask')
                                      .set({
                                        'subjectList': subjectList,
                                      }, SetOptions(merge: true))
                                      .then((value) => Fluttertoast.showToast(
                                          msg: 'Import Success',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0))
                                      .catchError((error) =>
                                          Fluttertoast.showToast(
                                              msg: 'Import Fail',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0));
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
