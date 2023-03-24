import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/Management/edit_exam.dart';

import '../theme/theme_management.dart';

class ExamListManagement extends StatefulWidget {
  const ExamListManagement({super.key});

  @override
  State<ExamListManagement> createState() => _ExamListManagementState();
}

class _ExamListManagementState extends State<ExamListManagement> {
  User? user = FirebaseAuth.instance.currentUser;
  List subjectList = [];
  List uidList = [];

  getdata() async {
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
  }

  Future<FirebaseApp> firebase = Firebase.initializeApp();

  get index => null;

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "my",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Schedule",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xff6B4EFF)),
                ),
              ],
            )),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Examination Day",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: subjectList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(
                      subjectList[index]["taskname"],
                    ),
                    subtitle: Wrap(children: [
                      Text("Midterm : ${subjectList[index]["taskmidterm"]}"),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Final : ${subjectList[index]["taskfinal"]}")
                    ]),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditExamDate(
                                      subjectList: subjectList,
                                      index: index,
                                    )),
                          );
                        },
                        icon: const Icon(Icons.edit)),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }
}
