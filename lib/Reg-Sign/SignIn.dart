import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:scheduletdl/Reg-Sign/profile.dart';
import 'package:scheduletdl/menu/menu.dart';

import '../firebase_options.dart';
import 'Register.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  Profile profile =
      Profile(firstname: '', lastname: '', email: '', password: '');
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
                        "Sign In",
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
                                Image.asset('assets/images/pic_login.jpg'),
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
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState?.save();
                                        // print(
                                        //     "${profile.firstname} ${profile.lastname} ${profile.email} ${profile.password}");

                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: profile.email,
                                                  password: profile.password)
                                              .then((value) {
                                            formKey.currentState?.reset();
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const Menu();
                                            }));
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          // print(e.message);
                                          Fluttertoast.showToast(
                                              msg: "${e.message}",
                                              gravity: ToastGravity.CENTER);
                                        }
                                      }
                                    },
                                    child: const Text("Sign In")),
                                const SizedBox(
                                  height: 20,
                                ),
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
                                      onPressed: () {
                                        // go to page register
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Register()),
                                        );
                                      },
                                      child: const Text("Sign Up",
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
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     title:
    //         Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
    //       Text(
    //         "my",
    //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    //       ),
    //       Text(
    //         "Schedule",
    //         style: TextStyle(
    //             color: Color(
    //               0xff6B4EFF,
    //             ),
    //             fontWeight: FontWeight.bold),
    //       )
    //     ]),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Image.asset('assets/images/pic_login.jpg'),
    //         const Text(
    //           "Log In",
    //           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    //         ),
    //         Form(
    //             key: _formKey,
    //             child: Column(
    //               children: [
    //                 TextFormField(
    //                   decoration:
    //                       const InputDecoration(hintText: "example@mail.com"),
    //                   validator: (value) {
    //                     if (value == null || value.isEmpty) {
    //                       return 'Please enter some text';
    //                     }
    //                     return null;
    //                   },
    //                 ),
    //                 TextFormField(
    //                   decoration: const InputDecoration(hintText: "password"),
    //                   validator: (value) {
    //                     if (value == null || value.isEmpty) {
    //                       return 'Please enter some text';
    //                     }
    //                     return null;
    //                   },
    //                 ),
    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 // botton go to another page
    //                 ElevatedButton(
    //                   onPressed: () {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => const Menu()));
    //                   },
    //                   child: const Text('Submit'),
    //                 ),

    //                 const SizedBox(
    //                   height: 20,
    //                 ),
    //                 ElevatedButton(
    //                   onPressed: () {
    //                     Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                             builder: (context) => const Register()));
    //                   },
    //                   child: const Text('Regis'),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: const [
    //                     Text("Haven't an account?"),
    //                     Text("Register",
    //                         style: TextStyle(
    //                           color: Color(
    //                             0xff6B4EFF,
    //                           ),
    //                         )),
    //                   ],
    //                 )
    //               ],
    //             ))
    //       ],
    //     ),
    //   ),
    // );
  }
}
