// -----------------------------------------------------------------------------
// Tuksaporn Tubkerd (Feature should have : Sign in-Register)
// -----------------------------------------------------------------------------
// registe_user.dart
// -----------------------------------------------------------------------------
//
// This file contains the widget functions that have textformfield
// widget to fill firstname, lastname, email and password for register.
// And data that we get will be put in firebase.
// -----------------------------------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/Reg-Sign/signin_user.dart';
import 'package:scheduletdl/Reg-Sign/profile.dart';
import 'package:scheduletdl/firebase_options.dart';
import '../theme/theme_management.dart';

// -----------------------------------------------------------------------------
// Register
// -----------------------------------------------------------------------------
// The Register class is create textformfield widget. It contains the code
// textformfield to fill some firstname, lastname, e-mail and password.
// It also have elevatedbutton to put data to firebase [insert date] by
// button and navigate to sign in page.
// -----------------------------------------------------------------------------

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  /// Get data from profile.dart that have firstname, lastname, e-mail and password
  Profile profile =
      Profile(firstname: '', lastname: '', email: '', password: '');

  /// Crete form
  final formKey = GlobalKey<FormState>();

  /// Intialize firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  @override
  Widget build(BuildContext context) {
    /// FutureBuilder is used to initialize firebase in this app
    return FutureBuilder(
        future: firebase,

        /// Build the app from firebase initialize
        builder: (context, snapshot) {
          /// If snapshot error it will show the text error
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

          /// If it connect already it will build app
          if (snapshot.connectionState == ConnectionState.done) {
            /// Use the Consumer to get current theme
            return Consumer<ThemeService>(builder: (_, themeService, __) {
              /// Run application
              return Scaffold(
                backgroundColor: themeService.subColor,

                /// Appbar "mySchedule"
                appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: Colors.black,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "my",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Schedule",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6B4EFF)),
                        ),
                      ],
                    )),

                /// Body part is SingleChildScrollView that can scrolland protect form over area
                body: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
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

                            /// set key value
                            key: formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 30, left: 30),
                              child: Column(
                                children: [
                                  /// TextFormField to fill firstname of user
                                  TextFormField(
                                      onSaved: (String? firstname) {
                                        profile.firstname = firstname!;
                                      },

                                      ///Decoration and validate name field
                                      decoration: const InputDecoration(
                                          hintText: "First name"),
                                      validator: RequiredValidator(
                                          errorText:
                                              "Please fill your firstname")),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  /// TextFormField to fill lastname of user
                                  TextFormField(
                                      onSaved: (String? lastname) {
                                        profile.lastname = lastname!;
                                      },

                                      ///Decoration and validate name field
                                      decoration: const InputDecoration(
                                          hintText: "Last name"),
                                      validator: RequiredValidator(
                                          errorText:
                                              "Please fill your lastname")),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  /// TextFormField to fill e-mail of user
                                  TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (String? email) {
                                        profile.email = email!;
                                      },

                                      ///Decoration and validate e-mail field
                                      decoration: const InputDecoration(
                                          hintText: "example@mail.com"),
                                      validator: MultiValidator([
                                        RequiredValidator(
                                            errorText:
                                                "Please fill your email"),
                                        EmailValidator(
                                            errorText: "Incorrect email form")
                                      ])),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  /// TextFormField to fill password of user
                                  TextFormField(
                                      obscureText: true,
                                      onSaved: (String? password) {
                                        profile.password = password!;
                                      },

                                      ///Decoration and validate password field
                                      decoration: const InputDecoration(
                                          hintText: "password"),
                                      validator: RequiredValidator(
                                          errorText:
                                              "Please fill your password")),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  /// ElevatedButton to push data to firebase
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(100, 40),
                                          backgroundColor: const Color(
                                            0xff6B4EFF,
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      onPressed: () async {
                                        /// Check validate and save
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState?.save();
                                          try {
                                            ///Use firebaseAuth to create user information profile
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                    email: profile.email,
                                                    password: profile.password)
                                                .then((value) {
                                              formKey.currentState?.reset();

                                              /// When create already it's will show success toast
                                              Fluttertoast.showToast(
                                                  msg: "Create user account",
                                                  gravity: ToastGravity.CENTER);
                                              Navigator.pop(context);

                                              ///Navigate to Sign in page
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return const SignIn();
                                              }));
                                            });

                                            /// If app can't push data to firebase in condition :
                                          } on FirebaseAuthException catch (e) {
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
                                            
                                            /// Show error toast
                                            Fluttertoast.showToast(
                                                msg: message,
                                                gravity: ToastGravity.CENTER);
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

                                          ///Button to navigate to sign in page if user already have account
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
            });
          }

          /// Indicating that the app is loading or performing a task.
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
