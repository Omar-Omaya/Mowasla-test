import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mowasla_prototype/Register/signIn.dart';
import 'package:mowasla_prototype/Register/signUp.dart';
import 'package:mowasla_prototype/StartupPage.dart';
import 'package:mowasla_prototype/mainScreen.dart';
import 'package:mowasla_prototype/main.dart';

class signIn extends StatelessWidget {


  static const String idScreen = "login";
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


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
              controller: emailTextEditingController,
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
              controller: passwordTextEditingController,
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
                if(!emailTextEditingController.text.contains("@"))
                {
                  displayToastMessage("Email address is mandatory.", context);
                }
                else if(passwordTextEditingController.text.length < 7)
                {
                  displayToastMessage("Password must be atleast 6 Characters.", context);
                }
                else
                {
                  loginAndAuthicateUser(context);
                }
                // print("logged in button clicked");
                
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthicateUser(BuildContext context) async
  {
    

  final User firebaseUser = (await _firebaseAuth
  .signInWithEmailAndPassword(email: emailTextEditingController.text
  , password: passwordTextEditingController.text).catchError((errMsg)
  {
    displayToastMessage("Error : " + errMsg.toString(), context);
    } )).user!;
    if(firebaseUser !=null)
    {
    

    usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
      if(snap.value != null)
      {
        Navigator.pushNamedAndRemoveUntil(context, mainScreen.idScreen, (route) => false);
        displayToastMessage("You are logged-in now.", context);
      }
      else
      {
        _firebaseAuth.signOut();
        displayToastMessage("No record exists for this user. Please create new account.", context);
        
      }
    });
    

   


  }
  else
  {

    displayToastMessage("User has not been created", context);

  }


  
  }
  displayToastMessage( String message , BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}



}