import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mowasla_prototype/Assistants/RequestAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/Models/direct_details.dart';
import 'package:provider/provider.dart';

class AssistantMehtods
{
  static Future<String> searchCoodinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1 , st2 ,st3 , st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI";

    var response = await RequestAssistant.getRequest(url);

    if(response != "failed")
    {
     st1 = response["results"][0]["address_components"][3]["long_name"];
     st2 = response["results"][0]["address_components"][1]["long_name"];
     st3 = response["results"][0]["address_components"][5]["long_name"];
     //st4 = response["results"][0]["address_components"][6]["long_name"];

     placeAddress = st1 + " " + st2 + ", " + st3 + ", ";

      Address userPickupAddress = new Address();
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickupAddress);
    }
    return placeAddress;
  }

  static double createRandomNumber(int num){
    var random = Random();
    int randomNumber = random.nextInt(num);
    return randomNumber.toDouble();
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(LatLng initalPosition , LatLng finalPostion) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initalPosition.latitude},${initalPosition.longitude}&destination=${finalPostion.latitude},${finalPostion.longitude}&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI";

    var res = await RequestAssistant.getRequest(directionUrl);
    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedpoints = res["routes"][0]["overview_polyline"]["points"];


    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];

    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;




  }

  static int calculateFares(DirectionDetails directionDetails)
  {
    double timeTraveledFare = (directionDetails.durationValue/60)*0.20;
    double distanceTraveledFare = (directionDetails.distanceValue/1000)*0.20;
    double totalFareAmount= timeTraveledFare+ distanceTraveledFare;

    //1$ = 15.71 egp

    double totalLocalAmount = totalFareAmount*15.71;

    return totalLocalAmount.truncate();



  }
}