import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/SearchScreen/searchScreen.dart';
import 'New_Screen/bus.dart';
import 'package:mowasla_prototype/New_Screen/homeScreen.dart';
import 'package:mowasla_prototype/New_Screen/bottomNav.dart';
import 'package:mowasla_prototype/New_Screen/rail_train.dart';
import 'package:mowasla_prototype/New_Screen/taxi.dart';
import 'package:mowasla_prototype/New_Screen/train.dart';
import 'package:mowasla_prototype/Register/signIn.dart';
import 'package:mowasla_prototype/Register/signUp.dart';
import 'package:mowasla_prototype/mainScreen.dart';
import 'package:provider/provider.dart';
// void main() async
// {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(Homeroute());
// }

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MaterialApp(
      home: MyApps(),
      
    )
  );


}


// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Homeroute(),
//     );
//   }
// }


DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

class MyApps extends StatelessWidget {
  const MyApps({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
    
        initialRoute: mainScreen.idScreen,
        routes: 
        {
          signUp.idScreen : (context) => signUp(),
          mainScreen.idScreen : (context) => mainScreen(),
          signIn.idScreen : (context) => signIn(),
          Homeroute.idScreen : (context) => Homeroute(),
          Train.idScreen : (context) => Train(),
          Taxi.idScreen : (context) => Taxi(),
          rail_train.idScreen : (context) => rail_train(),
          Bus.idScreen : (context) => Bus(),
          SearchScreen.idScreen : (context) => SearchScreen(),

          
        },
        debugShowCheckedModeBanner: false,
        
      ),
    );
  }
}

