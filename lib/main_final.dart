// ignore_for_file: avoid_init_to_null

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Assistants/singleton_handler.dart';
import 'package:mowasla_prototype/Assistants/assistantMethods.dart';
import 'package:mowasla_prototype/Assistants/geoFireAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/direct_details.dart';
import 'package:mowasla_prototype/Models/nearByAvailableDrivers.dart';
import 'package:mowasla_prototype/New_Screen/rail_train.dart';
import 'package:mowasla_prototype/New_Screen/train.dart';
import 'package:mowasla_prototype/all_Widgets/Divider.dart';
import 'package:mowasla_prototype/all_Widgets/progressDialog.dart';
import 'package:mowasla_prototype/SearchScreen/search_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mowasla_prototype/services_builder/application_builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'New_Screen/bus_screen.dart';

class mainScreen extends StatefulWidget {
  static const String idScreen = "Test";
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
  


  bool polylineShowed = false;
  double rideDetailsContainerHeight = 0 ;
  double searchContainerHeight =300.0;

  Singleton index = Singleton();

  Widget iconButton(path,String route, int num){
    return TextButton.icon(
        onPressed: () async {
			index.setindex = num;
			await pushfunction(route);
			
      if(index.getindex==3){
        getTramPlaceDirection();
        displayRideDetailsContainer();
      }
      else if(index.getindex==2){
        

      }
      else{
        getPlaceDirection();
        displayRideDetailsContainer();

      }

      if(polylineShowed==true){

        // polylineShowed=false;
      }
      else{
        polylineShowed=true;
      }
      
			
		},icon: Image.asset(path,width: 60,height: 60,), label:const Text(""),
		
    );
  }

  Future<void> pushfunction(route) 
  {
	return Navigator.pushNamed(context, route);
                  
  }

  DirectionDetails? tripDirectionDetails;

  void displayRideDetailsContainer() async {
    // await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 240;
      bottomPaddingOfMap = 230;
    });
  }

    void displaySearchContainer() async {
    // await getPlaceDirection();

    setState(() {
      searchContainerHeight = 300;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230;
    });

    polylineSet.clear();
    pLineCoerordinates.clear();
    markerSet.clear();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    currentPosition = position;

    var location = _locationTracker.getLocation();

    _locationSubscription =
        _locationTracker.onLocationChanged.listen((newLocalData) {
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
    ApplicationBuilder builder = ApplicationBuilder();
    return Scaffold(
      appBar: AppBar(
        title: Image(image: AssetImage("assets/Images/mwasla_logo.png"),width: 100,),
        backgroundColor: Colors.black,
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
            markers: markerSet,
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
              onTap: () async {
                 var res = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
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
                  child: SingleChildScrollView(
					child: Column(
					  children: [
						SizedBox(
						  height: 6.0,
						),
						// Text(
						//   "Hi there,",
						//   style: TextStyle(fontSize: 10.0),
						// ),
										Row(
											mainAxisAlignment: MainAxisAlignment.end,
											children: [
												
												Text(
                        "...رايح فين", 
										  textAlign: TextAlign.right,
						  style: TextStyle(fontSize: 40.0,fontWeight: FontWeight.bold ,),
										  
						),
										SizedBox(width: 20,)
				  
											],
										),
						
						SizedBox(
						  height: 20.0,
						),
						Padding(
						  padding: const EdgeInsets.only(left: 25,right: 0),
						  child: Row(
							children: [
							  
				  
							  iconButton("assets/Images/Bus.png",SearchScreen.idScreen, 0),
							  const SizedBox(width: 5,),
							  iconButton("assets/Images/taxi.png",SearchScreen.idScreen,1),
							  const SizedBox(width: 5,),
							  iconButton("assets/Images/Train.png",SearchScreen.idScreen,2),
							  const	SizedBox(width: 5,),
							  iconButton("assets/Images/Tram.png",SearchScreen.idScreen,3),
							],
						  ),
						),
										Row(
										  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												const SizedBox(width:50 ,),
												Text("Bus"),
												SizedBox(width: 65,),
												Text("Taxi"),
												SizedBox(width: 60,),
												Text("Train"),
												SizedBox(width: 55,),
												Text("Tram"),
												
											],
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
								Text(Provider.of<AppData>(context)
											.pickupLocation !=
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
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(microseconds: 160),
              child:
               Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              IconButton(icon: Icon(Icons.backspace),onPressed: (){
                                displaySearchContainer();

                              },),
                              SizedBox(
                                width: 16.0,
                              ),
                              Column(
                                mainAxisAlignment:MainAxisAlignment.start ,
                                children: [
                                  Text(
                                    "Pick up Time: 7 Pm",
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                  Text(
                                    ((tripDirectionDetails != null)
                                        ? '${tripDirectionDetails!.distanceText}'
                                        : ''),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text("Dropoff Time: 8 Pm ",
                                  style: TextStyle(fontSize: 14.0 ,),)
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                ((tripDirectionDetails != null)
                                    ? '${AssistantMehtods.calculateFares(tripDirectionDetails!)}'
                                    : ''),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyCheckAlt,
                              size: 18.0,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text("Cash"),
                            SizedBox(
                              width: 6.0,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black54,
                              size: 16.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          onPressed: () {
                            print("Clicked");
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Processed",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                               
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
  //----------------------------------------------------------------------
  //----------------------------------------------------------------------
  //----------------------------------------------------------------------
  //----------------------------------------------------------------------

  void getTramPlaceDirection(){

      pLineCoerordinates.add(LatLng(31.232850, 29.955676));
      pLineCoerordinates.add(LatLng(31.231280 , 29.954895));
      pLineCoerordinates.add(LatLng(31.228931, 29.951631));
      pLineCoerordinates.add(LatLng(31.226839, 29.948539));

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

      // pLineCoerordinates.clear();
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickupLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOfAddress;
    // print(res);

    var pickUplatlng = LatLng(initialPos!.latitude, initialPos.longitude);
    // finalPos!.latitude = finalPos!.latitude ?? 31.215231;
    // finalPos!.latitude = finalPos!.longitude ?? 29.951033;
    var dropOffLatlng = LatLng(finalPos !.latitude, finalPos.longitude);
    // var dropOffLatlng = LatLng(31.226839, 29.948539);

    


    
    // new Timer(, callback)

    Timer? timer = Timer(Duration(milliseconds: 3000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            PrograssDialog(message: "Please wait...")).then((value) {
      timer!.cancel();
      timer = null;
    });
    var details = await AssistantMehtods.obtainPlaceDirectionDetails(
        pickUplatlng, dropOffLatlng);
    //var details = await Bus.obtainPlaceDirectionDetails();

    setState(() {
      tripDirectionDetails = details!;
    });

    print("This is Encoded points::");
    print(details!.encodedpoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult = polylinePoints.decodePolyline(details.encodedpoints);


    Singleton index = Singleton();
    print(index.getindex);
    print("object");

    if(index.getindex==2){
      // print("Helllloooo 3");

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

    


    
    }
    else{
          
    if(decodePolyLinePointsResult.isNotEmpty){
        decodePolyLinePointsResult.forEach((PointLatLng ) {
        pLineCoerordinates.add(LatLng(PointLatLng.latitude, PointLatLng.longitude));

       });
    }

    }


    

      // pLineCoerordinates.add(LatLng(31.24737, 29.9716));
      // pLineCoerordinates.add(LatLng(31.24516, 29.96892));
      // pLineCoerordinates.add(LatLng(31.23102, 29.96805));
      // pLineCoerordinates.add(LatLng(31.22882, 29.95474));
      // pLineCoerordinates.add(LatLng(31.22444, 29.95131));
      // pLineCoerordinates.add(LatLng(31.21682 , 29.94868));
      // pLineCoerordinates.add(LatLng(31.21476 , 29.94517));
      // pLineCoerordinates.add(LatLng(31.21115  , 29.93292));



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
    if (pickUplatlng.latitude > dropOffLatlng.latitude &&
        pickUplatlng.longitude > dropOffLatlng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatlng, northeast: pickUplatlng);
    } else if (pickUplatlng.longitude >
        dropOffLatlng.longitude) //PLA DLO DLA PLO
    {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUplatlng.latitude, dropOffLatlng.longitude),
          northeast: LatLng(dropOffLatlng.latitude, pickUplatlng.longitude));
    } else if (pickUplatlng.latitude > dropOffLatlng.latitude) //
    {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatlng.latitude, pickUplatlng.longitude),
          northeast: LatLng(pickUplatlng.latitude, dropOffLatlng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUplatlng, northeast: dropOffLatlng);
    }

    newGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "My Location"),
      position: pickUplatlng,
      markerId: MarkerId("pickUpId"),
    );
    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos!.placeName, snippet: "DroppOff Location"),
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

  //-------------------------------------------------------------
  //-------------------------------------------------------------
  //-------------------------------------------------------------

//   Future<void> getBusPlaceDirection() async {
//     var pickUplatlng = LatLng(31.282688, 30.010827);
//     var dropOffLatlng = LatLng(31.210247, 29.908724);
//     // new Timer(, callback)

//     Timer? timer = Timer(Duration(milliseconds: 3000), () {
//       Navigator.of(context, rootNavigator: true).pop();
//     });
//     showDialog(
//         context: context,
//         builder: (BuildContext context) =>
//             PrograssDialog(message: "Please wait...")).then((value) {
//       timer!.cancel();
//       timer = null;
//     });

//     // var details = await Bus.obtainPlaceDirectionDetails();

//     setState(() {
//       tripDirectionDetails = details!;
//     });

//     print("This is Encoded points::");
//     print(details!.encodedpoints);

//     PolylinePoints polylinePoints = PolylinePoints();
//     List<PointLatLng> decodePolyLinePointsResult = polylinePoints.decodePolyline(details.encodedpoints);
//     // if(decodePolyLinePointsResult.isNotEmpty)
//     // {
//     //   decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
//     //     pLineCoerordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude));

//     //    });

//     // }
//     pLineCoerordinates.add(LatLng(31.248784,29.97956));
//     pLineCoerordinates.add(LatLng(31.251905,29.978776));
//     pLineCoerordinates.add(LatLng(31.252513,29.976544));
//     pLineCoerordinates.add(LatLng(31.251641,29.974224));
//     pLineCoerordinates.add(LatLng(31.249573,29.971596));
//     pLineCoerordinates.add(LatLng(31.24737,29.968919));


//     polylineSet.clear();
//     setState(() {
//          Polyline polyline = Polyline(
//          color: Colors.black,
//          polylineId: PolylineId("PolylineID"),
//          jointType: JointType.round,
//          points: pLineCoerordinates,
//          width: 5,
//          endCap : Cap.roundCap,
//          geodesic: true

//        );
//        polylineSet.add(polyline);
//       //  polylineSet.add(LatLng(31.242003, 29.963379))
       
//     });



//     LatLngBounds latLngBounds;
//     if (pickUplatlng.latitude > dropOffLatlng.latitude &&
//         pickUplatlng.longitude > dropOffLatlng.longitude) {
//       latLngBounds =
//           LatLngBounds(southwest: dropOffLatlng, northeast: pickUplatlng);
//     } else if (pickUplatlng.longitude >
//         dropOffLatlng.longitude) //PLA DLO DLA PLO
//     {
//       latLngBounds = LatLngBounds(
//           southwest: LatLng(pickUplatlng.latitude, dropOffLatlng.longitude),
//           northeast: LatLng(dropOffLatlng.latitude, pickUplatlng.longitude));
//     } else if (pickUplatlng.latitude > dropOffLatlng.latitude) //
//     {
//       latLngBounds = LatLngBounds(
//           southwest: LatLng(dropOffLatlng.latitude, pickUplatlng.longitude),
//           northeast: LatLng(pickUplatlng.latitude, dropOffLatlng.longitude));
//     } else {
//       latLngBounds =
//           LatLngBounds(southwest: pickUplatlng, northeast: dropOffLatlng);
//     }

//     newGoogleMapController
//         .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

//     Marker pickUpLocMarker = Marker(
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//       infoWindow: InfoWindow(title: "Start Location", snippet: "My Location"),
//       // position: LatLng(31.239141,29.958956),
//       position: pickUplatlng,
//       markerId: MarkerId("pickUpId"),
//     );
//     Marker dropOffLocMarker = Marker(
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       infoWindow: InfoWindow(title: "DropOff Location", snippet: "DroppOff Location"),
//       // position: LatLng(31.242003,29.963379),
//       position: dropOffLatlng,
//       markerId: MarkerId("dropOffId"),
//     );

//     setState(() {
//       markerSet.add(pickUpLocMarker);
//       markerSet.add(dropOffLocMarker);

//       // markerSet.add();

//     });

//     Circle pickUpLocCircle = Circle(
//       fillColor: Colors.blueAccent,
//       center: pickUplatlng,
//       radius: 12,
//       strokeWidth: 4,
//       strokeColor: Colors.blueAccent,
//       circleId: CircleId("pickUpId"),
//     );
//     Circle dropOffLocCircle = Circle(
//       fillColor: Colors.deepPurple,
//       center: pickUplatlng,
//       radius: 12,
//       strokeWidth: 4,
//       strokeColor: Colors.deepPurple,
//       circleId: CircleId("dropOffId"),
//     );

//     setState(() {
//       circlesSet.add(pickUpLocCircle);
//       circlesSet.add(dropOffLocCircle);
//     });
//   }

  void initGeoFireListener() {
    Geofire.initialize('availableDrivers');
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 50 )!
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
            if (nearbyAvailableDriverKeysLoaded == true) {
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
        markerId: MarkerId("${driver.key}"),
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
