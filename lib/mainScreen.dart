import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mowasla_prototype/Assistants/assistantMethods.dart';
import 'package:mowasla_prototype/Assistants/geoFireAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/nearByAvailableDrivers.dart';
import 'package:mowasla_prototype/StartupPage.dart';
import 'package:mowasla_prototype/all_Widgets/Divider.dart';
import 'package:mowasla_prototype/mainScreen.dart';
import 'package:mowasla_prototype/SearchScreen/searchScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:location/location.dart';

class mainScreen extends StatefulWidget {
  static const String idScreen = "MainScreen";
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(31.2264784, 29.9379636), zoom: 14.4746);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  final Location _locationTracker = Location();
  late StreamSubscription _locationSubscription;
  double rotation = 0;

  Set<Marker> markerSet = Set<Marker>();

  late Position currentPosition;

  var geoLocator = Geolocator();

  var nearByIcon = null;

  bool nearbyAvailableDriverKeysLoaded = false;

  double bottomPaddingOfMap = 0;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = position;

    var location = _locationTracker.getLocation();

    _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
      rotation = newLocalData.heading!;
    });

    LatLng latLatPosiotion = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosiotion, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMehtods.searchCoodinateAddress(position, context);
    print("this is your Address :: " + address);

    initGeoFireListener();

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
            markers: markerSet,
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
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
                      padding: const EdgeInsets.all(8.0),
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
                            Text(Provider.of<AppData>(context).pickupLocation !=
                                    null
                                ? Provider.of<AppData>(context)
                                    .pickupLocation!
                                    .placeName
                                : "Add Home"),
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
            ),
          ),
        ],
      ),
    );
  }

  void initGeoFireListener() {
    Geofire.initialize('availableDrivers');
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 10)!
        .listen((map) {
      if (map != null) {
        var callBack = map['callBack'];

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers(
                    key: map['key'],
                    latitude: map['latitude'],
                    longitude: map['longitude']);
            GeoFireAssistant.nearByAvailableDriversList
                .add(nearbyAvailableDrivers);
            if (nearbyAvailableDriverKeysLoaded==true){
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map['key']);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyAvailableDrivers nearbyAvailableDrivers =
                NearbyAvailableDrivers(
                    key: map['key'],
                    latitude: map['latitude'],
                    longitude: map['longitude']);
            GeoFireAssistant.updateDriverNearbyLocation(nearbyAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }
    });
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markerSet.clear();
    });

    Set<Marker> tMarkers = Set<Marker>();

    for (NearbyAvailableDrivers driver
        in GeoFireAssistant.nearByAvailableDriversList) {
      LatLng driverAvailableLocation =
          LatLng(driver.latitude, driver.longitude);

      Marker marker = Marker(
        markerId: MarkerId(""),
        position: driverAvailableLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        rotation: rotation,
        anchor: Offset(0.5, 0.5),
      );
      tMarkers.add(marker);
    }
    setState(() {
      markerSet = tMarkers;
    });
  }
}
