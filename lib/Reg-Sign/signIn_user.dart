import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/Reg-Sign/profile.dart';
import 'package:scheduletdl/menu/menu.dart';

import '../firebase_options.dart';
import '../theme/theme_management.dart';
import 'register_user.dart';

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
    final width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
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
            // body: SingleChildScrollView(
            //   child: Container(
            //     padding: const EdgeInsets.all(20),
            //     child: Column(
            //       children: [
            //         Stack(
            //           children: [
            //             Positioned(child: Container(
            //               decoration: const BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage('assets/images/background.png'),
            //                   fit: BoxFit.fill
            //                 )
            //               ),
            //             ))
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
            //         const Center(
            //           child: Text(
            //             "Sign In",
            //             style: TextStyle(
            //                 fontSize: 30, fontWeight: FontWeight.bold),
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 15,
            //         ),
            //         Form(
            //             key: formKey,
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 30, left: 30),
            //               child: Column(
            //                 children: [
            //                   Image.asset('assets/images/pic_login.jpg'),
            //                   TextFormField(
            //                       keyboardType: TextInputType.emailAddress,
            //                       onSaved: (String? email) {
            //                         profile.email = email!;
            //                       },
            //                       decoration: const InputDecoration(
            //                           hintText: "example@gmail.com"),
            //                       validator: MultiValidator([
            //                         RequiredValidator(
            //                             errorText: "Please fill your email"),
            //                         EmailValidator(
            //                             errorText: "Incorrect email form")
            //                       ])),
            //                   const SizedBox(
            //                     height: 10,
            //                   ),
            //                   TextFormField(
            //                       obscureText: true,
            //                       onSaved: (String? password) {
            //                         profile.password = password!;
            //                       },
            //                       decoration: const InputDecoration(
            //                           hintText: "password"),
            //                       validator: RequiredValidator(
            //                           errorText:
            //                               "Please fill your password")),
            //                   const SizedBox(
            //                     height: 30,
            //                   ),
            //                   ElevatedButton(
            //                       style: ElevatedButton.styleFrom(
            //                           minimumSize: const Size(100, 40),
            //                           backgroundColor: const Color(
            //                             0xff6B4EFF,
            //                           ),
            //                           shape: RoundedRectangleBorder(
            //                               borderRadius:
            //                                   BorderRadius.circular(30))),
            //                       onPressed: () async {
            //                         if (formKey.currentState!.validate()) {
            //                           formKey.currentState?.save();

            //                           try {
            //                             await FirebaseAuth.instance
            //                                 .signInWithEmailAndPassword(
            //                                     email: profile.email,
            //                                     password: profile.password)
            //                                 .then((value) {
            //                               formKey.currentState?.reset();
            //                               Navigator.pushReplacement(context,
            //                                   MaterialPageRoute(
            //                                       builder: (context) {
            //                                 return const Menu();
            //                               }));
            //                             });
            //                           } on FirebaseAuthException catch (e) {
            //                             Fluttertoast.showToast(
            //                                 msg: "${e.message}",
            //                                 gravity: ToastGravity.CENTER);
            //                           }
            //                         }
            //                       },
            //                       child: const Text(
            //                         "Sign In",
            //                         style: TextStyle(fontSize: 17),
            //                       )),
            //                   const SizedBox(
            //                     height: 20,
            //                   ),
            //                   const SizedBox(
            //                     height: 20,
            //                   ),
            //                   const SizedBox(
            //                     height: 20,
            //                   ),
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       const Text("Have an account?"),
            //                       TextButton(
            //                         onPressed: () {
            //                           // go to page register
            //                           Navigator.push(
            //                             context,
            //                             MaterialPageRoute(
            //                                 builder: (context) =>
            //                                     const Register()),
            //                           );
            //                         },
            //                         child: const Text("Sign Up",
            //                             style: TextStyle(
            //                               color: Color(
            //                                 0xff6B4EFF,
            //                               ),
            //                             )),
            //                       ),
            //                     ],
            //                   )
            //                 ],
            //               ),
            //             ))
            //       ],
            //     ),
            //   ),
            // ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    child: Stack(
                      children: [
                        Positioned(
                          top: -40,
                          height: 300,
                          width: width,
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/background.png"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                        Positioned(
                            height: 300,
                            width: width + 30,
                            child: Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/background-2.png"),
                                      fit: BoxFit.fill)),
                            )),
                      ],
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Log in",
                            style: TextStyle(
                                color: Color.fromRGBO(49, 39, 79, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(196, 135, 198, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                      // border: Border(
                                      //     bottom:
                                      //         BorderSide(color: Colors.grey))
                                      ),
                                  child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (String? email) {
                                        profile.email = email!;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "example@gmail.com"),
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please fill your email"),
                                        EmailValidator(
                                            errorText: "Incorrect email form")
                                      ])),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                      obscureText: true,
                                      onSaved: (String? password) {
                                        profile.password = password!;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "password"),
                                      validator: RequiredValidator(
                                          errorText:
                                              "Please fill your password")),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          Row(
                            children: [
                              const Text("Haven't account?"),
                              const SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Register()),
                                    );
                                  },
                                  child: const Text(
                                    " Sign Up",
                                    style: TextStyle(
                                        color: Color.fromRGBO(49, 39, 79, 1)),
                                  ))
                            ],
                          ),
                          Center(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    minimumSize: const Size(200, 50),
                                    primary: Color.fromRGBO(49, 39, 79, 1)),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();

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
                                      Fluttertoast.showToast(
                                          msg: "${e.message}",
                                          gravity: ToastGravity.CENTER);
                                    }
                                  }
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  //   return const Scaffold(
  //     body: Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // });
}
