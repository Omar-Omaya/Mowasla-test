import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mowasla_prototype/Assistants/RequestAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/Bus.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/Models/directDetails.dart';
import 'package:provider/provider.dart';




class busScreen extends StatefulWidget {
  const busScreen({ Key? key }) : super(key: key);

  @override
  _busScreenState createState() => _busScreenState();
}

class _busScreenState extends State<busScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 60.0,),
          FlatButton(child: Image.asset("assets/images/tripCard4.png"),
          onPressed:()
          {
            
             Navigator.pop(context, true);
             var details = Bus.obtainPlaceDirectionDetails();
             

          },
          )
        ],
      ),

      
    );
  }
  // String directionStaticBus = "https://maps.googleapis.com/maps/api/directions/json?origin=31.282688,30.010827&destination=31.210247,29.908724&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI";



  

}



  