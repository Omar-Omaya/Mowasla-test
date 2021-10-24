import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as _Location;
import 'package:mowasla_prototype/Register/signUp.dart';
import 'package:mowasla_prototype/StartupPage.dart';
import 'package:mowasla_prototype/all_Widgets/Divider.dart';
import 'package:mowasla_prototype/main.dart';
import 'package:mowasla_prototype/mainScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;

class mainScreen extends StatefulWidget {
  static const String idScreen = "MainScreen";
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(31.201330, 29.939520), zoom: 14.4746);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  var u = {};

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    storeUserLocation();
  }

  late BitmapDescriptor pinLocationIcon;

  List<Marker> markers = [];

  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  late Position currentPosition;

  var geoLocator = Geolocator();

  double bottomPaddingOfMap = 0;

  _Location.Location location = new _Location.Location();

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  getUsersLocation() async {
    await usersRef.get().then((value) => u = value.value);
    u.remove(userId);
    u.removeWhere((key, value) => value["type"] == "rider");
    u.forEach((k, v) => markers.add(Marker(
        markerId: MarkerId(v["email"].toString()),
        infoWindow: InfoWindow(title: v["name"].toString()),
        draggable: false,
        rotation: v["rotation"].toDouble(),
        icon: pinLocationIcon,
        flat: true,
        anchor: Offset(0.5, 0.5),
        zIndex: 30,
        position: LatLng(v["lat"], v["long"]))));

    setState(() {});
  }

  storeUserLocation() {
    location.onLocationChanged.listen((_Location.LocationData currentLocation) {
      var lat = userId + "/lat";
      var long = userId + "/long";
      var rotation = userId + "/rotation";
      usersRef.update({lat: currentLocation.latitude});
      usersRef.update({long: currentLocation.longitude});
      usersRef.update({rotation: currentLocation.heading});
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosiotion = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosiotion, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  void setCustomMapPin() async {
    pinLocationIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset('assets/Images/car.png', 64));

    setState(() {});

    getUsersLocation();

    usersRef.onChildChanged.forEach((element) {
      var doc = element.snapshot.value;
      var key = element.snapshot.key;

      doc["type"] == "rider" || key == userId
          ? null
          : markers.add(Marker(
              markerId: MarkerId(doc["email"]),
              infoWindow: InfoWindow(title: doc["name"].toString()),
              draggable: false,
              rotation: doc["rotation"].toDouble(),
              icon: pinLocationIcon,
              flat: true,
              anchor: Offset(0.5, 0.5),
              zIndex: 30,
              position: LatLng(doc["lat"], doc["long"])));
      setState(() {});
    });
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
            markers: markers.toSet(),
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: mainScreen._kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 200.0;
              });

              locatePosition();
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Column(
                children: [
                  SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    "Hi there,",
                    style: TextStyle(fontSize: 10.0),
                  ),
                  Text(
                    "Where to?,",
                    style: TextStyle(fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            )
                          ]),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.yellowAccent,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Search Drop Off")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add Home"),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            "Your living home address",
                            style: TextStyle(
                                color: Colors.grey[200], fontSize: 12.0),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  DividerWidget(),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        Icons.work,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add Work"),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            "Your office address",
                            style: TextStyle(
                                color: Colors.grey[200], fontSize: 12.0),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
