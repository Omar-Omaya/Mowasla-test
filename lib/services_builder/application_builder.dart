import 'package:flutter/material.dart';


class ApplicationBuilder{
  Widget containerBuilder(riderDetail,context){

    return Container(
      height: riderDetail,
      decoration:  BoxDecoration(color: Colors.white,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(16.0),topRight:Radius.circular(16.0), ),
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          blurRadius: 16.0,
          spreadRadius: 0.5,
          offset: Offset(0.7, 0.7)
        )
      ]),
      width: double.infinity,
      color:  Colors.tealAccent,   
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        
      )),


    );

  }
}