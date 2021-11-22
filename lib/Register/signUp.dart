import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mowasla_prototype/New_Screen/homeScreen.dart';
import 'package:mowasla_prototype/Register/signIn.dart';
import 'package:mowasla_prototype/main.dart';
import 'package:mowasla_prototype/mainScreen.dart';
import 'package:mowasla_prototype/New_Screen/bottomNav.dart';


class signUp extends StatelessWidget {
  

  static const String idScreen = "register";

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body:
      
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
        child: Column(
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
              controller: nameTextEditingController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Name",
                isDense: true,
                contentPadding: EdgeInsets.all(15),
                labelStyle: TextStyle(color:
                Colors.black
                )
              ),
            ), 
              TextFormField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.name,
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
            TextFormField(
              controller: phoneTextEditingController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone",
                isDense: true,
                contentPadding: EdgeInsets.all(15),
                labelStyle: TextStyle(color:
                Colors.black
                )                
              ),
            ),SizedBox(height: 2.0,),
            SizedBox(height: 1.0,),
            SizedBox(height: 1.0,),
            TextFormField(
              controller: passwordTextEditingController,
              obscureText: true,
              obscuringCharacter: "*",
              keyboardType: TextInputType.phone,
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
                    "Create Account"
                  ) 
                ,),
              ),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(24.0),
              ),
              onPressed: ()
              {
                // print("logged in button clicked");

                if(nameTextEditingController.text.length <3)
                {
                  displayToastMessage("Name must be atleast 3 characters.", context);
                }
                else if(!emailTextEditingController.text.contains("@"))
                {
                  displayToastMessage("Email address is mandatory.", context);
                }
                else if(phoneTextEditingController.text.isEmpty)
                {
                  displayToastMessage("Phone Number is not Valid.", context);
                }
                else if(passwordTextEditingController.text.length < 7)
                {
                  displayToastMessage("Password must be atleast 6 Characters.", context);
                }
                else{
                  registerNewUser(context);

                }
                
              },
            ),
            FlatButton(onPressed: ()
            {
              Navigator.pushNamedAndRemoveUntil(context, signIn.idScreen, (route) => false);
            },
              child: Text(
                "Already have an Account? Login Here."
              )
              )
        ],
      ),
      )
      )
    );
  }
  
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

void registerNewUser(BuildContext context) async
{
  final User firebaseUser = (await _firebaseAuth
  .createUserWithEmailAndPassword(email: emailTextEditingController.text
  , password: passwordTextEditingController.text).catchError((errMsg)
  {
    displayToastMessage("Error : " + errMsg.toString(), context);
  } )).user!;
  
  if(firebaseUser !=null)
  {
    displayToastMessage("User saved", context);
    

    Map userDataMap = {
      "name": nameTextEditingController.text,
      "emai": emailTextEditingController.text,
      "phone": phoneTextEditingController.text,
      "password": passwordTextEditingController.text,

    };
    usersRef.child(firebaseUser.uid).set(userDataMap);
    displayToastMessage("Congrats, your account has been created.", context);

    Navigator.pushNamedAndRemoveUntil(context, Homeroute.idScreen, (route) => false);


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

