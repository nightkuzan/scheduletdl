import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduletdl/sch-management/edit-schedule.dart';

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({super.key});

  @override
  State<ScheduleManagement> createState() => _ScheduleManagement();
}

class _ScheduleManagement extends State<ScheduleManagement> {
  List<dynamic> subjectList = [
    {
      "index": 0,
      "taskname": "Math",
      "taskdescription": "Do math homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktime": "09:30 - 11:00 TuF",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB209",
      "taskID": "204441"
    },
    {
      "index" : 1,
      "taskname": "English",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktime": "12:30 - 14:00 MTh",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204333"
    },
  ];

  late int index;

  @override
  Widget build(BuildContext context) {
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

              },
              icon:const Icon(Icons.add, color: Colors.black,),
            ),
          ],
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Schedule",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                "Management",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xff6B4EFF)),
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
                                      taskname: subjectList[index]["taskname"],
                                      taskID: subjectList[index]["taskID"],
                                      taskRoom: subjectList[index]["taskroom"],
                                      taskTime: subjectList[index]["tasktime"],
                                      taskMid: subjectList[index]
                                          ["taskmidterm"],
                                      taskFinal: subjectList[index]
                                          ["taskfinal"],
                                    )));
                      },
                      child: Card(
                        color: const Color(0xffB89FED),
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
                                    text:
                                        (subjectList[index]["tasktime"]) + "\n",
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: (subjectList[index]["taskroom"]),
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
}
