import 'package:flutter/material.dart';
import 'package:scheduletdl/todolist/listview.dart';
import 'package:scheduletdl/sch-management/schedule-management.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Schedule',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Schedule'),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.menu),
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const Todolist()),
              //     );
              //   },
              // ),
              BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Menu",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScheduleManagement()),
                  );
                },
                child: const Text('School'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Todolist()),
                  );
                },
                child: const Text('Todo List'),
              ),
            ],
          ),
        ));
  }
}
