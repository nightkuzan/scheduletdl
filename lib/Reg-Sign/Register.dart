import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/Reg-Sign/profile.dart';
import 'package:scheduletdl/firebase_options.dart';
import 'package:scheduletdl/menu/menu.dart';
import '../Management/examDate_mng.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Profile profile =
      Profile(firstname: '', lastname: '', email: '', password: '');
  final formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "my",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Text(
                        "Schedule",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6B4EFF)),
                      ),
                    ],
                  )),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30, left: 30),
                            child: Column(
                              children: [
                                TextFormField(
                                    onSaved: (String? firstname) {
                                      profile.firstname = firstname!;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "First name"),
                                    validator: RequiredValidator(
                                        errorText:
                                            "Please fill your firstname")),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    onSaved: (String? lastname) {
                                      profile.lastname = lastname!;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Last name"),
                                    validator: RequiredValidator(
                                        errorText:
                                            "Please fill your lastname")),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    onSaved: (String? email) {
                                      profile.email = email!;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "example@mail.com"),
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: "Please fill your email"),
                                      EmailValidator(
                                          errorText: "Incorrect email form")
                                    ])),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                    obscureText: true,
                                    onSaved: (String? password) {
                                      profile.password = password!;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "password"),
                                    validator: RequiredValidator(
                                        errorText:
                                            "Please fill your password")),
                                const SizedBox(
                                  height: 30,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState?.save();
                                        print(
                                            "${profile.firstname} ${profile.lastname} ${profile.email} ${profile.password}");
                                        formKey.currentState?.reset();
                                      }

                                      // go to page menu
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           const ExamList_Management()),
                                      // );
                                    },
                                    child: const Text("Save")),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      // go to page menu
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ExamList_Management()),
                                      );
                                    },
                                    child: const Text(
                                        "Go to Exam listview page for Testing")),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      // go to page menu
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Menu()),
                                      );
                                    },
                                    child: const Text(
                                        "Go to Menu page for Testing")),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Have an account?"),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text("Sign In",
                                          style: TextStyle(
                                            color: Color(
                                              0xff6B4EFF,
                                            ),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // return Scaffold(
        //   body: Center(
        //     child: CircularProgressIndicator(),
        //   ),
        // );
        );
  }
}
