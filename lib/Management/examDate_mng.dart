import 'package:flutter/material.dart';
import 'package:scheduletdl/Management/edit_exam.dart';

class ExamList_Management extends StatefulWidget {
  const ExamList_Management({super.key});

  @override
  State<ExamList_Management> createState() => _ExamList_ManagementState();
}

class _ExamList_ManagementState extends State<ExamList_Management> {
  List<dynamic> tasks = [
    {
      "taskname": "Math",
      "taskdescription": "Do math homework",
      "taskdate": "2021-10-10",
      "tasktime": "10:00",
      "taskpriority": "High",
      "taskstatus": "Incomplete"
    },
    {
      "taskname": "English",
      "taskdescription": "Do english homework",
      "taskdate": "2021-10-10",
      "tasktime": "10:00",
      "taskpriority": "High",
      "taskstatus": "Incomplete"
    }
  ];

  get index => null;

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
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "my",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditExamDate()),
                    );
                  },
                  title: Text(tasks[index]["taskname"]),
                  subtitle: Text(tasks[index]["taskdescription"]),
                  // trailing: Wrap(
                  //   children: [
                  //     IconButton(
                  //       icon: Icon(Icons.edit),
                  //       onPressed: () {},
                  //     ),
                  //     IconButton(
                  //       icon: Icon(Icons.delete),
                  //       onPressed: () {
                  //         setState(() {
                  //           tasks.removeAt(index);
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
