import 'package:comm_resources/screens/Login/AddNewUserDetails.dart';
import 'package:comm_resources/screens/MainScreen.dart';
import 'package:comm_resources/screens/Login/login.dart';
import 'package:comm_resources/screens/Resources/myResources.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  pref = await SharedPreferences.getInstance();
  runApp(Init());
}
SharedPreferences pref; // global;
class Init extends StatelessWidget {
  const Init({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Login.id:(context)=>Login(),
        MainScreen.id:(context)=>MainScreen(),
        AddNewUserDetails.id:(context)=>AddNewUserDetails(),
        MyResources.id:(context)=>MyResources()
      },
      initialRoute:(pref.getString('uid')==null)?Login.id:MainScreen.id,
    );
  }
}
