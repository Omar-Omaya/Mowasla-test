import 'dart:async';

import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class mainScreen extends StatefulWidget {
  static const String idScreen = "MainScreen";
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(31.201330, 29.939520), zoom: 20);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  late Position currentPosition;

  var geoLocator = Geolocator();

  double bottomPaddingOfMap = 0;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosiotion = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosiotion, zoom: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: mainScreen._kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locatePosition();
            },
          ),
          ElevatedButton(
              onPressed: () {
                goOnline();
                getLocationUpdates();
              },
              child: Icon(Icons.update))
        ],
      ),
    );
  }

  void goOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude,
        currentPosition.longitude);

    driversRef.onValue.listen((event) {});
  }

  void getLocationUpdates() {
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(
          currentfirebaseUser.uid, position.latitude, position.longitude);
      LatLng latlng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latlng));
    });
  }
}
