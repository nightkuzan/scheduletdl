import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scheduletdl/Reg-Sign/SignIn.dart';
import 'package:scheduletdl/todolist/listview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'menu_schedule.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void test() async {
    // final Future<FirebaseApp> firebase = Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    User? user = FirebaseAuth.instance.currentUser;

    // checj user uid in firestore
    final CollectionReference userstdl =
        FirebaseFirestore.instance.collection('users');
    final snapshot = await userstdl.get();
    List users = snapshot.docs.map((e) => e.data()).toList();
    bool noLogin = false;
    for (int i = 0; i < users.length; i++) {
      if (users[i]['uid'] == user?.uid) {
        noLogin = true;
        print('user is already in firestore');
      }
    }

    if (noLogin == false) {
      User? user = FirebaseAuth.instance.currentUser;

      // create document in collection 'users' for the current user
      FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'email': user?.email,
        'uid': user?.uid,
      });

      // create collection
      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(user?.uid)
      //     .collection('tasks')
      //     .doc('todolist')
      //     .set({
      //   'task': 'task',
      //   'date': 'date',
      //   'time': 'time',
      //   'priority': 'priority',
      //   'status': 'status',
      // });
    }
  }

  @override
  void initState() {
    super.initState();
    test();
  }

  // const userUid = FirebaseAuth.instance.current;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
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
          ]),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset('assets/images/pic_login.jpg'),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xff8A2DE8)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MenuSchedule()),
                    );
                  },
                  child: const Text('School', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color(0xffB770FF)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Todolist()),
                    );
                  },
                  child:
                      const Text('Todo List', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor:
                          const Color.fromARGB(255, 105, 101, 110)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
                  },
                  child: const Text('Log Out', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
        ));
  }
}
