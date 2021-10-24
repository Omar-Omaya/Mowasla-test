import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:flutter/material.dart';
import 'package:drivers_app/mainScreen.dart';


class CarInfoScreen extends StatelessWidget {
  CarInfoScreen({Key? key}) : super(key: key);

  static const String idScreen = "carinfo";

  TextEditingController carModeltextController = TextEditingController();
  TextEditingController carNumbertextController = TextEditingController();
  TextEditingController carColortextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0),
              Image.asset('assets/mwasla_logo.png'),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0),
                    Text(
                      "Enter Car Details",
                      style:
                      TextStyle(fontFamily: "Brand-Bold", fontSize: 24.0),
                    ),
                    SizedBox(height: 26.0),
                    TextField(
                      controller: carModeltextController,
                      decoration: InputDecoration(
                        labelText: "Car Model",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: carNumbertextController,
                      decoration: InputDecoration(
                        labelText: "Car Number",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 10.0),
                    TextField(
                      controller: carColortextController,
                      decoration: InputDecoration(
                        labelText: "Car Color",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(height: 42.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          saveDriverCarInfo(context);
                        },
                        color: Theme
                            .of(context)
                            .accentColor,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("NEXT"),
                              Icon(Icons.arrow_forward, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void saveDriverCarInfo(context) {
    String userId = currentfirebaseUser.uid;
    Map carInfoMap = {
      "car_model": carModeltextController.text,
      "car_number": carNumbertextController.text,
      "car_color": carColortextController.text
    };
    driversRef.child(userId).child("car_details").set(carInfoMap);
    Navigator.pushNamedAndRemoveUntil(context, mainScreen.idScreen, (route) => false);
  }
}