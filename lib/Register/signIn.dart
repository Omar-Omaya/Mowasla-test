import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Register/signIn.dart';
import 'package:mowasla_prototype/Register/signUp.dart';
import 'package:mowasla_prototype/StartupPage.dart';
import 'package:mowasla_prototype/mainScreen.dart';

class signIn extends StatelessWidget {
  const signIn({ Key? key }) : super(key: key);

  static const String idScreen = "login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: 
          Column(
        children: [
          SizedBox(height: 35.0,),
          Image(
            image: AssetImage("assets/Images/mwasla_logo.png") ,
            width: 390.0,
            height: 250.0,
            alignment: Alignment.center,
            ),
            SizedBox(height: 1.0,),
            Text(
              "Login as a Rider",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.0,),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                isDense: true,
                contentPadding: EdgeInsets.all(15),
                labelStyle: TextStyle(color:
                Colors.black
                )
              ),
            ),
            SizedBox(height: 2.0,),
                        SizedBox(height: 1.0,),
            SizedBox(height: 1.0,),
            TextFormField(
              obscureText: true,
              obscuringCharacter: "*",
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: "Password",
                isDense: true,
                contentPadding: EdgeInsets.all(15),
                labelStyle: TextStyle(color:
                Colors.black
                )                
              ),
            ),
            SizedBox(height: 50.0,),
            RaisedButton(
              color: Colors.blue[100],
              textColor: Colors.white,
              child: Container(
                height: 50.0,
                child: Center(
                  child: Text(
                    "Login"
                  ) 
                ,),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(24.0),
              ),
              onPressed: ()
              {
                print("logged in button clicked");
              },
            ),
            FlatButton(onPressed: ()
            {
              // print("clicked");
              Navigator.pushNamedAndRemoveUntil(context, signUp.idScreen, (route) => false);
            },
              child: Text(
                "Do not have an Account? Register Here."
              ))
        ],
        ),
      ) 
    ,)
       
  );
  }
}