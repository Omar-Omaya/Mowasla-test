import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mowasla_prototype/Assistants/RequestAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/Models/direct_details.dart';
import 'package:provider/provider.dart';


class Bus {
  static Future<DirectionDetails?> obtainPlaceDirectionDetails() async
  {

    String placeAddress = "";
    String st1 , st2 ,st3 , st4;
    String directionStaticBus = "https://maps.googleapis.com/maps/api/directions/json?origin=31.282688,30.010827&destination=31.210247,29.908724&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI";
     var res = await RequestAssistant.getRequest(directionStaticBus);

     DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedpoints = res["routes"][0]["overview_polyline"]["points"];


    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
}