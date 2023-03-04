import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scheduletdl/sch-management/edit-schedule.dart';

import 'add-schedule.dart';

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({super.key});

  @override
  State<ScheduleManagement> createState() => _ScheduleManagement();
}

class _ScheduleManagement extends State<ScheduleManagement> {
  List<Color?> colors = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      const Color.fromARGB(255, 246, 43, 43),
      const Color.fromARGB(255, 54, 228, 191),
      const Color.fromARGB(255, 255, 183, 211),
    ];

  List<dynamic> subjectList = [
    {
      "index": 0,
      "taskname": "Math",
      "taskdescription": "Do math homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "09:30",
      "tasktimeEnd": "11:00",
      "taskDay" : "TuF",
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
      "tasktimeStart": "12:30",
      "tasktimeEnd": "14:00",
      "taskDay": "MTh",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204333"
    },
    {
      "index" : 1,
      "taskname": "English",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "12:30",
      "tasktimeEnd": "14:00",
      "taskDay": "MTh",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204333"
    },
    {
      "index" : 1,
      "taskname": "English",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "12:30",
      "tasktimeEnd": "14:00",
      "taskDay": "MTh",
      "taskpriority": "High",
      "taskstatus": "Incomplete",
      "taskroom": "CSB210",
      "taskID": "204333"
    },
    {
      "index" : 1,
      "taskname": "English",
      "taskdescription": "Do english homework",
      "taskmidterm": "2021-10-10",
      "taskfinal": "2021-12-12",
      "tasktimeStart": "12:30",
      "tasktimeEnd": "14:00",
      "taskDay": "MTh",
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
                 Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>const AddSchedule()));
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
                                      taskTimeStart: subjectList[index]["tasktimeStart"],
                                      taskTimeEnd: subjectList[index]["tasktimeEnd"],
                                      taskDay: subjectList[index]["taskDay"],
                                      taskMid: subjectList[index]
                                          ["taskmidterm"],
                                      taskFinal: subjectList[index]
                                          ["taskfinal"],
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
                                    text:
                                        (subjectList[index]["tasktimeStart"]) + ' - ' + (subjectList[index]["tasktimeEnd"]) + ' ' + (subjectList[index]["taskDay"]) +"\n",
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
