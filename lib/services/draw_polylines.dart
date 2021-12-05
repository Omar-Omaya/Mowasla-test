//   import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mowasla_prototype/Models/Bus.dart';
// import 'package:mowasla_prototype/all_Widgets/progressDialog.dart';

// Future<void> getBusPlaceDirection() async {
//     var pickUplatlng = LatLng(31.282688, 30.010827);
//     var dropOffLatlng = LatLng(31.210247, 29.908724);
//     // new Timer(, callback)

//     // Timer? timer = Timer(Duration(milliseconds: 3000), () {
//     //   Navigator.of(context, rootNavigator: true).pop();
//     // });
//     // showDialog(
//     //     context: context,
//     //     builder: (BuildContext context) =>
//     //         PrograssDialog(message: "Please wait...")).then((value) {
//     //   timer!.cancel();
//     //   timer = null;
//     // });

//     var details = await Bus.obtainPlaceDirectionDetails();

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
//     // pLineCoerordinates.add(LatLng(31.248784,29.97956));
//     // pLineCoerordinates.add(LatLng(31.251905,29.978776));
//     // pLineCoerordinates.add(LatLng(31.252513,29.976544));
//     // pLineCoerordinates.add(LatLng(31.251641,29.974224));
//     // pLineCoerordinates.add(LatLng(31.249573,29.971596));
//     // pLineCoerordinates.add(LatLng(31.24737,29.968919));


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