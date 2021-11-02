import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mowasla_prototype/Assistants/assistantMethods.dart';
import 'package:mowasla_prototype/Assistants/geoFireAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/directDetails.dart';
import 'package:mowasla_prototype/Models/nearByAvailableDrivers.dart';
import 'package:mowasla_prototype/StartupPage.dart';
import 'package:mowasla_prototype/all_Widgets/Divider.dart';
import 'package:mowasla_prototype/all_Widgets/progressDialog.dart';
import 'package:mowasla_prototype/mainScreen.dart';
import 'package:mowasla_prototype/SearchScreen/searchScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class mainScreen extends StatefulWidget {
  static const String idScreen = "MainScreen";
  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(31.2264784, 29.9379636), zoom: 14.4746);

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  final Location _locationTracker = Location();
  late StreamSubscription _locationSubscription;

  double rotation = 0;

  Set<Marker> markerSet = Set<Marker>();
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  late Position currentPosition;

  var geoLocator = Geolocator();
  var nearByIcon = null;

  bool nearbyAvailableDriverKeysLoaded = false;

  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoerordinates = [];
  Set<Polyline> polylineSet = {};

  double rideDetailsContainerHeight = 0 ;
  double searchContainerHeight =300.0;

  DirectionDetails? tripDirectionDetails;
  

  void displayRideDetailsContainer() async
  {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight=0;
      rideDetailsContainerHeight= 240;
      bottomPaddingOfMap=230;
      
    });

  }


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
            polylines: polylineSet,
            markers:markerSet ,
            circles: circlesSet,

            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 200.0;
              });
              locatePosition();
            },
          //  markers: markerSet, 
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: () async
               {
                    var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                     displayRideDetailsContainer(); 
               },
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(microseconds: 160),
                child: Container(
                  height: searchContainerHeight,
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
          ),
          Positioned(
            bottom:0.0 ,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
            vsync: this,
            curve: Curves.bounceIn,
            duration: new Duration(microseconds: 160),
            child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    )
                  ] 
                ),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.carSide),
                              SizedBox(width: 16.0,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Car", style: TextStyle(fontSize: 18.0),
                                  ),
                                  Text(((tripDirectionDetails != null) ? '\$${tripDirectionDetails!.distanceText}':''), style: TextStyle(fontSize: 16.0, color: Colors.black,),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                ((tripDirectionDetails != null) ? '\$${AssistantMehtods.calculateFares(tripDirectionDetails!)}': ''), style: TextStyle(fontSize: 16.0, color: Colors.black,),
                                  ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.moneyCheckAlt,size: 18.0,color:Colors.black ,),
                            SizedBox(width: 16.0,),
                            Text("Cash"),
                            SizedBox(width: 6.0,),
                            Icon(Icons.keyboard_arrow_down,color:Colors.black54,size:16.0,),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: ()
                          {
                            print("Clicked");
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Request", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                                Icon(FontAwesomeIcons.taxi,color: Colors.white,size:26.0),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            
          )
       
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async 
  {
    var initialPos = Provider.of<AppData>(context, listen:  false).pickupLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOfAddress;
    // print(res);

    var pickUplatlng = LatLng(initialPos!.latitude,initialPos.longitude);
    var dropOffLatlng = LatLng(finalPos!.latitude,finalPos.longitude);
    // new Timer(, callback)

    Timer? timer = Timer(Duration(milliseconds: 3000),()
    {
      Navigator.of(context , rootNavigator: true).pop();


    });
    showDialog(context: context, builder: (BuildContext context)=> PrograssDialog(message: "Please wait...")).then((value)
    {
      timer!.cancel();
      timer=null;

    });
    var details = await AssistantMehtods.obtainPlaceDirectionDetails(pickUplatlng, dropOffLatlng);

    setState(() {
      tripDirectionDetails = details!;
    });

    print("This is Encoded points::");
    print(details!.encodedpoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult = polylinePoints.decodePolyline(details.encodedpoints);
    if(decodePolyLinePointsResult.isNotEmpty)
    {
      decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoerordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude));

       });
    }
    polylineSet.clear();
    setState(() {
         Polyline polyline = Polyline(
         color: Colors.black,
         polylineId: PolylineId("PolylineID"),
         jointType: JointType.round,
         points: pLineCoerordinates,
         width: 5,
         endCap : Cap.roundCap,
         geodesic: true

       );
       polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if(pickUplatlng.latitude > dropOffLatlng.latitude && pickUplatlng.longitude > dropOffLatlng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatlng,northeast: pickUplatlng);
    }
    else if(pickUplatlng.longitude > dropOffLatlng.longitude)  //PLA DLO DLA PLO
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUplatlng.latitude, dropOffLatlng.longitude),northeast: LatLng(dropOffLatlng.latitude, pickUplatlng.longitude));
    }
    else if(pickUplatlng.latitude > dropOffLatlng.latitude)// 
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatlng.latitude, pickUplatlng.longitude),northeast: LatLng(pickUplatlng.latitude, dropOffLatlng.longitude));
    }
    else
    {
      latLngBounds = LatLngBounds(southwest: pickUplatlng,northeast: dropOffLatlng);
    }

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: initialPos.placeName, snippet: "My Location"),
      position: pickUplatlng,
      markerId: MarkerId("pickUpId"),
    );   
    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "DroppOff Location"),
      position: dropOffLatlng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);

    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUplatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );
    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: pickUplatlng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });

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
