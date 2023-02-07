import 'package:flutter/material.dart';
import 'package:scheduletdl/menu/menu.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Text(
            "my",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            "Schedule",
            style: TextStyle(
                color: Color(
                  0xff6B4EFF,
                ),
                fontWeight: FontWeight.bold),
          )
        ]),
      ),
      body: Column(
        children: [
          Image.asset('assets/images/pic_login.jpg'),
          const Text(
            "Log In",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: "example@mail.com"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // botton go to another page
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Menu()));
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Haven't an account?"),
                      Text("Register",
                          style: TextStyle(
                            color: Color(
                              0xff6B4EFF,
                            ),
                          )),
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }
}
