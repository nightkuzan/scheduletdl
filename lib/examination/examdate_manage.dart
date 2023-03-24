// -----------------------------------------------------------------------------
// Tuksaporn Tubkerd (Feature must have : Exam date management)
// -----------------------------------------------------------------------------
// examdate_management.dart
// -----------------------------------------------------------------------------
//
// This file contains the widget functions that have listview builder to
// show about exam information
// -----------------------------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/examination/edit_exam.dart';
import '../theme/theme_management.dart';

// -----------------------------------------------------------------------------
// EditExamDate
// ------EditExamdate class is create listview widget. In listview there are listtile 
// that have title, subtitle, and trailing that is a icon button.
//------------------------------------------------------------------------------
class ExamListManagement extends StatefulWidget {
  const ExamListManagement({super.key});

  @override
  State<ExamListManagement> createState() => _ExamListManagementState();
}

class _ExamListManagementState extends State<ExamListManagement> {

  ///  initialized with the current user instance obtained from 
  /// the FirebaseAuth object using the "currentUser" property.
  User? user = FirebaseAuth.instance.currentUser;
  List subjectList = [];
  List uidList = [];

  // getdata()
  // Fetch data from firebase and store it in list 
  // subjectList to display in widget.
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

        /// appBar "mySchedule"
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

        /// Body is SingleChildScroll view
        body: SingleChildScrollView(
          child: Column(
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

              /// Listview that show the subject and exam date
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
        ),
      );
    });
  }
}
