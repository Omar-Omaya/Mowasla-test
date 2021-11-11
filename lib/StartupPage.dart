// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:mowasla_prototype/Register/Signin.dart';

// class StartupPage extends StatefulWidget {
//   const StartupPage({ Key? key }) : super(key: key);

//   @override
//   _StartupPageState createState() => _StartupPageState();
// }

// class _StartupPageState extends State<StartupPage> {
//   @override
//   Widget build(BuildContext context) {
//         Timer(
//             Duration(seconds: 3),
//                 () =>
//             Navigator.of(context).pushReplacement(MaterialPageRoute(
//                 // builder: (BuildContext context) => SignIn()))
//                 );
//     return Container(
      
//       padding: EdgeInsets.symmetric(horizontal: 40.0),
//       height: double.infinity,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage('assets/Images/colored_background.png'),
//           fit: BoxFit.cover,
//         )
//       ),
//      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           Image(image: AssetImage('assets/Images/mwasla_welcome.png')),
//           SizedBox(height: 20.0),
//           Image(image: AssetImage('assets/Images/mwasla_logo.png'),
//                 width: 400.0,
//                 height: 100.0,
//           ),
//           SizedBox(height: 20.0),
//           Image(image: AssetImage('assets/Images/5dlk_mwasla.png')),

//         ],
//       ),
//     );
//   }
// }
