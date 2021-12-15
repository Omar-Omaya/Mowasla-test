import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Singleton extends ChangeNotifier{
  static Singleton _singleton = Singleton._internal();

  factory Singleton() {
    return _singleton;
  }
  int indexpage =0;

  void set setindex(int indexpage)
  {
    this.indexpage = indexpage;
    notifyListeners();
  }

  int get getindex
  {
    return indexpage;
  }

  Singleton._internal();

  List<LatLng> pLineCoerordinates = [];

  Future<List<LatLng>> tramPolylines(addpolylines) async {

    try{

    pLineCoerordinates.add(LatLng(31.24878, 31.24878));
    pLineCoerordinates.add(LatLng(31.25191 , 31.25191));
    pLineCoerordinates.add(LatLng(31.25251, 31.25191));
    pLineCoerordinates.add(LatLng(31.24957, 31.25191));
    pLineCoerordinates.add(LatLng(31.24737, 31.25191));
    pLineCoerordinates.add(LatLng(31.24516, 31.25191));
    pLineCoerordinates.add(LatLng(31.23102, 31.25191));
    pLineCoerordinates.add(LatLng(31.22882, 31.25191));
    pLineCoerordinates.add(LatLng(31.22444, 31.25191));
    pLineCoerordinates.add(LatLng(31.21682 , 31.25191));
    pLineCoerordinates.add(LatLng(31.21476 , 31.25191));
    pLineCoerordinates.add(LatLng(31.21115  , 31.25191));

    for(var i= 0;i<13;i++){
      addpolylines = pLineCoerordinates[i];
      
    }
    return addpolylines;

    }catch(e){
      print(e);
    }
    return pLineCoerordinates;


  }

  
}