import 'package:flutter/material.dart';


class SearchScreen extends StatefulWidget {


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 225.0,
            decoration: BoxDecoration(
              color:Colors.white,
              boxShadow: 
              [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                )
              ] ),

              child: Padding(
                padding: EdgeInsets.only(left: 25.0,top: 20.0,right: 25.0,bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Stack(
                      children: [
                        Icon(Icons.arrow_back),
                        Center(
                          child: Text("Set Drop off", style: TextStyle(fontSize: 18.0),),
                        )

                      ],)
                  ],
                ),
              ),
          )
        ],
      ),
      
    );
  }
}