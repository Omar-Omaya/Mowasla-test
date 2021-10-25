import 'package:flutter/cupertino.dart';
import 'package:mowasla_prototype/Models/address.dart';

class AppData extends ChangeNotifier
{

  Address? pickupLocation;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    this.pickupLocation = pickUpAddress;
    notifyListeners();
  }

}