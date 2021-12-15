import 'package:flutter/cupertino.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/Models/address_pickup.dart';

class AppData extends ChangeNotifier
{

  Address? pickupLocation, dropOfAddress;

  void updatePickUpLocationAddress(Address pickUpAddress)
  {
    this.pickupLocation = pickUpAddress;
    notifyListeners();
  }

    void updateDropOffocationAddress(Address dropOfAddress)
  {
    this.dropOfAddress = dropOfAddress;
    notifyListeners();
  }




}