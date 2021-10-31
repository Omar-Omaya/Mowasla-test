import 'package:drivers_app/configMaps.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/Register/signIn.dart';
import 'package:drivers_app/Register/signUp.dart';
import 'package:drivers_app/mainScreen.dart';
import 'package:drivers_app/Screens/carInfoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  currentfirebaseUser = FirebaseAuth.instance.currentUser!;

  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.reference().child("drivers");

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      initialRoute: signIn.idScreen,
      routes: {
        signUp.idScreen : (context) => signUp(),
        signIn.idScreen : (context) => signIn(),
        mainScreen.idScreen : (context) => mainScreen(),
        CarInfoScreen.idScreen : (context) => CarInfoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}