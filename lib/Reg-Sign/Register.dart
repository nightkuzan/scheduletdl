import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/Reg-Sign/SignIn.dart';
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
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(100, 40),
                                        primary: Color(
                                          0xff6B4EFF,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState?.save();
                                        // print(
                                        //     "${profile.firstname} ${profile.lastname} ${profile.email} ${profile.password}");

                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password)
                                              .then((value) {
                                            formKey.currentState?.reset();
                                            Fluttertoast.showToast(
                                                msg: "Create user account",
                                                gravity: ToastGravity.CENTER);
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return SignIn();
                                            }));
                                          });

                                          // formKey.currentState?.reset();
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const SignIn()),
                                          // );
                                        } on FirebaseAuthException catch (e) {
                                          // print(e.message);
                                          // print(e.code);
                                          String message;
                                          if (e.code ==
                                              "email-already-in-use") {
                                            message =
                                                "มีอีเมลล์นี้ในระบบอยู่แล้ว";
                                          } else if (e.code ==
                                              'weak-password') {
                                            message =
                                                "รหัสผ่านต้องมีความยาว 6 ตัวขึ้นไป";
                                          } else {
                                            message = e.message!;
                                          }

                                          Fluttertoast.showToast(
                                              msg: message,
                                              gravity: ToastGravity.CENTER);
                                          // Fluttertoast.showToast(
                                          //     msg: e.message);
                                        }
                                      }
                                    },
                                    child: const Text("Create account")),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Have an account?"),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignIn()),
                                        );
                                      },
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
