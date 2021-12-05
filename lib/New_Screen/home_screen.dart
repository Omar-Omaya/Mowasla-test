import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:mowasla_prototype/Assistants/assistantMethods.dart';
import 'package:mowasla_prototype/Assistants/geoFireAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Assistants/Singleton.dart';
import 'package:mowasla_prototype/Models/direct_details.dart';
import 'package:mowasla_prototype/Models/nearByAvailableDrivers.dart';
import 'package:mowasla_prototype/New_Screen/transportationDesicion.dart';
import 'package:mowasla_prototype/SearchScreen/search_screen.dart';
import 'package:mowasla_prototype/all_Widgets/progressDialog.dart';
import 'package:provider/provider.dart';
import 'package:mowasla_prototype/Models/bus.dart';
import 'navigation_drawer_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:mowasla_prototype/main_screen.dart';
import 'package:flutter_geofire/flutter_geofire.dart';


class Homeroute extends StatefulWidget {
  const Homeroute({ Key? key }) : super(key: key);

  static const String idScreen = "MainScreen";

  @override
  _HomerouteState createState() => _HomerouteState();
   
}

//GoogleMapController _googleMapController;

//
// void dispose()
// {
//   _googleMapController.dispose();
//   super.dispose();
// }



class _HomerouteState extends State<Homeroute> with TickerProviderStateMixin {
  static const String idScreen = "HomeScreen";
  static final CameraPosition _kGooglePlex =
   CameraPosition(target: LatLng(31.2264784, 29.9379636), zoom: 14.4746);
   Completer<GoogleMapController> _controllerGoogleMap = Completer();

  late GoogleMapController newGoogleMapController;

  final Location _locationTracker = Location();
  late StreamSubscription _locationSubscription;

  double rotation = 0;

  bool nearbyAvailableDriverKeysLoaded = false;

  Set<Marker> markerSet = Set<Marker>();
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  var s1 = Singleton();
  

  late Position currentPosition;

  List<LatLng> pLineCoerordinates = [];
  Set<Polyline> polylineSet = {};

  
  double bottomPaddingOfMap = 0;

  DirectionDetails? tripDirectionDetails;

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
     
     
     return Scaffold(
    appBar: AppBar(
      centerTitle: false,
      title: const Image(image: AssetImage('assets/Images/mwasla_logo.png'),height: 45.0,
      ),
      backgroundColor: Colors.black,
    ),
    endDrawer: NavigationDrawerWidget(),
    body: SlidingUpPanel(
      
      body:GoogleMap(initialCameraPosition: _kGooglePlex,
      padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
      myLocationButtonEnabled: false,
      
       mapType: MapType.normal,
       myLocationEnabled: true,
       zoomGesturesEnabled: true,
       zoomControlsEnabled: true,
       onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 300.0;
              });
              locatePosition();
            },
            polylines: polylineSet,
            markers: markerSet,
            circles: circlesSet,
      


      ),
          collapsed: Container(
          decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),child: Center(child: OutlinedButton(onPressed: () async
         { 
           var res = await
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => chooseRoute()));
          // getBusPlaceDirection();

                    // setState(() {
                    //   s1.setindex = 1;
                    // });
                    // getPlaceDirection();

          getPlaceDirection();

         },
        child:Text("رايح فين") ,)
        


          // TextFormField(decoration: 
          // InputDecoration(
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.only(
          //     topLeft: Radius.circular(30),
          //     topRight: Radius.circular(30),
          //     bottomLeft: Radius.circular(30),
          //     bottomRight: Radius.circular(30),

          //   ),
          //   borderSide: BorderSide(color: Colors.black,
          //   width: 2)
            
          // ),
          // hintText: "رايح فين",
          // prefixIcon: Padding(
          //   padding: EdgeInsets.only(top: 0),
          //   child: Icon(Icons.search),
          // ),
          // contentPadding: new EdgeInsets.symmetric(vertical: 5,horizontal: 5)
          // ),textAlign: TextAlign.center,
          
          
          // ) 
          
         ) 
         
        ,),
        
        
        
          panel:
          Container(child: new SingleChildScrollView(
            child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start
            ,children: [


          Image.asset("assets/Images/Tram.png"),
          Container(
          decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),child: Center(child:
          TextFormField(decoration: 
          InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),

            ),
            borderSide: BorderSide(color: Colors.black,
            width: 2)
            
          ),
          hintText: "رايح فين",
          prefixIcon: Padding(
            padding: EdgeInsets.only(top: 0),
            child: Icon(Icons.search),
            
          ),
          contentPadding: new EdgeInsets.symmetric(vertical: 5,horizontal: 5)
          ),textAlign: TextAlign.center,
          
          
          ) 
          
         ) 
        ,),

        Row(
          mainAxisAlignment: MainAxisAlignment.start
          ,children: [

            

            ClipRRect(borderRadius: BorderRadius.circular(24.0)
            ,child: Image.asset("assets/Images/Tram.png",
            width: 10,
            height: 10,
            
            )
            ,),
            ClipRRect(borderRadius: BorderRadius.circular(24.0)
            ,child: Image.asset("assets/Images/Actionable_tab.png",
            width: 370,
            height: 160
            ,)
            ,),
            

          ],
        )

            ,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(24.0)
            ,child: Image.asset("assets/Images/taxi.png",
            width: 128,
            height: 128
            
            ,)
            ,)
            

              ],
            ),
            ClipRRect(borderRadius: BorderRadius.circular(24.0)
            ,child: Image.asset("assets/Images/Tram.png",
            width: 16,
            height: 10
            ,)
            ,),

          ClipRRect(
          child: Image.asset("assets/Images/action2.png",
          width: 440,
          height: 128
          ,),borderRadius:
           BorderRadius.circular(30.0)
            
            ,),

          
          ],)
          ),
          )
          
          
          
          

        ),

    ); 

    
}
Future<void> getPlaceDirection() async {
  
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickupLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOfAddress;
    // print(res);
    // var pickUplatlng = LatLng(31.282688, 30.010827);
    // var dropOffLatlng = LatLng(31.210247, 29.908724);

    var pickUplatlng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropOffLatlng = LatLng(finalPos!.latitude, finalPos.longitude);
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
    // List<PointLatLng> decodePolyLinePointsResult = polylinePoints;
    if(decodePolyLinePointsResult.isNotEmpty)
    {
      decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoerordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
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
          InfoWindow(title: initialPos!.placeName, snippet: "My Location"),
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
// --------------------------------------------
// --------------------------------------------
// --------------------------------------------
// --------------------------------------------
// --------------------------------------------
// --------------------------------------------
// --------------------------------------------
// --------------------------------------------
// --------------------------------------------


Future<void> getBusPlaceDirection() async {
    var pickUplatlng = LatLng(31.282688, 30.010827);
    var dropOffLatlng = LatLng(31.210247, 29.908724);
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

    var details = await Bus.obtainPlaceDirectionDetails();

    setState(() {
      tripDirectionDetails = details!;
    });

    print("This is Encoded points::");
    print(details!.encodedpoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult = polylinePoints.decodePolyline(details.encodedpoints);
    // if(decodePolyLinePointsResult.isNotEmpty)
    // {
    //   decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
    //     pLineCoerordinates.add(LatLng(pointLatLng.latitude,pointLatLng.longitude));

    //    });

    // }
    pLineCoerordinates.add(LatLng(31.242003, 29.963379));
    pLineCoerordinates.add(LatLng(31.242919, 29.965066));

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
      //  polylineSet.add(LatLng(31.242003, 29.963379))
       
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
      infoWindow: InfoWindow(title: "Start Location", snippet: "My Location"),
      // position: LatLng(31.239141,29.958956),
      position: pickUplatlng,
      markerId: MarkerId("pickUpId"),
    );
    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: "DropOff Location", snippet: "DroppOff Location"),
      // position: LatLng(31.242003,29.963379),
      position: dropOffLatlng,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markerSet.add(pickUpLocMarker);
      markerSet.add(dropOffLocMarker);

      // markerSet.add();

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

  void getBusesPlaceDirection() async
  {

    

  }







}
