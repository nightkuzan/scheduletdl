// -----------------------------------------------------------------------------
// Tuksaporn Tubkerd (Feature should have : Sig in-Register)
// -----------------------------------------------------------------------------
// signIn_user.dart
// -----------------------------------------------------------------------------
// 
// This file contains the widget functions that check e-mail and password
// when you fill email&password in textformfield and it's will  check
// that are match with data in firebase or not. 
// If it's correct it will navigate to menu page in progarm and if it's not it
// will have toast alert to fill the textformfield again. And navigate when
// user doesn't have an account.
//------------------------------------------------------------------------------

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


// -----------------------------------------------------------------------------
// SignIn
// -----------------------------------------------------------------------------
// The SignIn class is create textformfield widget. It contains the code
// textformfield to fill some e-mail and password. 
// It also have elevatedbutton to check e-mail and password before
// navigate to next page (Menu page)
//------------------------------------------------------------------------------

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  /// Crete form
  final formKey = GlobalKey<FormState>();

  /// Get data from profile.dart that have firstname, lastname, e-mail and password
  Profile profile =
      Profile(firstname: '', lastname: '', email: '', password: '');

  /// Intialize firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    /// Create width size for decorate the widget
    final width = MediaQuery.of(context).size.width;

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

              /// appBar "mySchedule"
              appBar: AppBar(
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
                        fontWeight: FontWeight.bold, color: Color(0xff6B4EFF)),
                  ),
                ],
              )),

              /// Body that have Images, FextFormFields, textButton and elevatedButton
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    
                    ///Image Widget
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
                                      
                                      /// Asset image [add package asset]
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

                                        /// Asset image [add package asset]
                                        image: AssetImage(
                                            "assets/images/background-2.png"),
                                        fit: BoxFit.fill)),
                              )),
                        ],
                      ),
                    ),
                    Form(
                      
                      /// Set key value
                      /// Build sign in page 
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
                                        color:
                                            Color.fromRGBO(196, 135, 198, .3),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),

                              /// TextFormField with decoration input "example@gmail.com" 
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(),
                                    child: TextFormField(
                                        keyboardType:

                                            /// type text is e-mail form
                                            TextInputType.emailAddress,
                                        onSaved: (String? email) {
                                          profile.email = email!;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "example@gmail.com"),

                                        /// validate error when doens't fill e-mail
                                        validator: MultiValidator([
                                          RequiredValidator(
                                              errorText:
                                                  "Please fill your email"),
                                                  
                                          /// validate error when the fill doens't  e-mail type 
                                          EmailValidator(
                                              errorText: "Incorrect email form")
                                        ])),
                                  ),
                                  
                                  /// TextFormField password
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                        obscureText: true,

                                        /// If password correct it will be on save
                                        onSaved: (String? password) {
                                          profile.password = password!;
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "password"),
                                        
                                        /// validate error when password fill empthy 
                                        validator: RequiredValidator(
                                            errorText:
                                                "Please fill your password")),
                                  ),
                                ],
                              ),
                            ),
                            
                            /// TextButton when user doesn't have account
                            Row(
                              children: [
                                const Text("Haven't account?"),
                                const SizedBox(
                                  width: 5,
                                ),
                                TextButton(
                                    onPressed: () {

                                      /// Navigator to Register page to Register account
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

                            /// Button of Sign in
                            Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      minimumSize: const Size(200, 50),
                                      backgroundColor:
                                          const Color.fromRGBO(49, 39, 79, 1)),
                                  onPressed: () async {

                                    /// Check validate and save
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState?.save();

                                      try {

                                        /// USe firebaseAuth to check e-mail and password
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
                                      } 
                                      /// If doesn't match show toast with error message
                                      on FirebaseAuthException catch (e) {
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
          });
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
}
