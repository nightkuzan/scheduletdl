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
        theme: ThemeData(
          primarySwatch: themeService.color
        ),
        home: const Scaffold(
        body: SignIn(),
      ));
  });
  }
}
