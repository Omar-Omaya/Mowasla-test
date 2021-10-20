import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Register/signUp.dart';
import 'package:mowasla_prototype/StartupPage.dart';
import 'package:mowasla_prototype/mainScreen.dart';


class mainScreen extends StatelessWidget {

  static const String idScreen = "MainScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      )
      
      
    );
  }
}