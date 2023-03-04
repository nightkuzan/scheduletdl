import 'package:flutter/material.dart';
import '../Management/examDate_mng.dart';
import '../sch-management/schedule-management.dart';
import '../sch-view/schedule-view.dart';

class MenuSchedule extends StatefulWidget {
  const MenuSchedule({super.key});

  @override
  State<MenuSchedule> createState() => _MenuScheduleState();
}

class _MenuScheduleState extends State<MenuSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            "my",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
        backgroundColor: Colors.white,
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
                  backgroundColor:const Color(0xff005B3C)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScheduleView(
                              title: '',
                            )),
                  );
                },
                child: const Text('Schedule View', style: TextStyle(fontSize: 24)),
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
                  backgroundColor:const Color(0xffEBE784)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScheduleManagement()),
                  );
                },
                child: const Text('Schedule Management', style: TextStyle(fontSize: 24)),
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
                  backgroundColor:const Color(0xffB2AF4F)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExamList_Management()),
                  );
                },
                child: const Text('Examination Date', style: TextStyle(fontSize: 24)),
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
                  backgroundColor:const Color(0xff7B7B1B)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExamList_Management()),
                  );
                },
                child: const Text('Import From Friend', style: TextStyle(fontSize: 24),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
