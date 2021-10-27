import 'package:flutter/material.dart';

class PlacePredictions
{
   String secondart_text;
   String main_text;
   String place_id;

  PlacePredictions(this.secondart_text, this.main_text,this.place_id);



  PlacePredictions.fromJson(Map<String , dynamic> json)
  {
    place_id = json["place_id"];
    main_text = json["main_text"];
    secondart_text = json["secondary_text"];
  }


  
}