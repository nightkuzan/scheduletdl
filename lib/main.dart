import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scheduletdl/theme/theme_management.dart';
import 'Reg-Sign/signin_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // -----------------------------------------------------------------------------
  // Tulakorn Sawangmuang 630510582 (Feature should have: Dark Theme)
  // -----------------------------------------------------------------------------
  //
  // This code is used to run Flutter application using ChangeNotifierProvider. 
  // This is a newly created Provider for managing application themes. 
  // Create this Provider by calling ChangeNotifierProvider's create method which takes a parameter 
  // as a function that returns an instance of ThemeService() which is a ChangeNotifier subclass 
  // used for state management. of the theme in the application and the theme will change all pages.
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeService(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Schedule'),
    )
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(builder: (_, themeService, __){
      return MaterialApp(
        // change the app bar theme all pages.
        theme: ThemeData(
          primarySwatch: themeService.color
        ),
        home: const Scaffold(
        body: SignIn(),
      ));
  });
  }
}
