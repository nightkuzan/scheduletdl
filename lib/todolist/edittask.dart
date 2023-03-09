import 'package:flutter/material.dart';

class EditTask extends StatefulWidget {
  String taskname;
  String taskdescription;
  String taskdate;
  String tasktime;
  String taskpriority;
  int index;

  EditTask(
      {super.key,
      required this.taskname,
      required this.taskdescription,
      required this.taskdate,
      required this.tasktime,
      required this.taskpriority,
      required this.index});

  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Column(
        children: [
          TextField(
            controller: TextEditingController(text: widget.taskname),
          ),
          TextField(
            controller: TextEditingController(text: widget.taskdescription),
          ),
          TextField(
            controller: TextEditingController(text: widget.taskdate),
          ),
          TextField(
            controller: TextEditingController(text: widget.tasktime),
          ),
          TextField(
            controller: TextEditingController(text: widget.taskpriority),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
