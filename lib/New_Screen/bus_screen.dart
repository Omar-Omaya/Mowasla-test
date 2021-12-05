import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Assistants/Singleton.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/New_Screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'navigation_drawer_widget.dart';

class Bus extends StatefulWidget {
  // const Bus({ Key? key }) : super(key: key);
  static String idScreen = "bus";
  

  @override
  _BusState createState() => _BusState();
}

class _BusState extends State<Bus> {
  
  @override
  Widget build(BuildContext context) {
    var s1 = Singleton();
    return Scaffold(
      appBar: AppBar(
      centerTitle: false,
      title: const Image(image: AssetImage('assets/Images/mwasla_logo.png'),height: 45.0,
      ),
      backgroundColor: Colors.black,
    ),
    endDrawer: NavigationDrawerWidget(),

    body: 
    Container(child: 
    SingleChildScrollView(child: 
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [
                
                Image.asset("assets/Images/FastB1.png"),
                
                //Image.asset("assets/Images/tripCar3.png"),
                Image.asset("assets/Images/tripCard4.png"),
                Image.asset("assets/Images/tripCard5.png"),
                IconButton(onPressed: ()
                {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> Homeroute()));
                  getBusPlaceAddressDetails();
                  s1.setindex=2;
                  

                },iconSize: 300
                , icon: Image.asset("assets/Images/tripCard4.png")),
                



            // ClipRRect(
            // child: Image.asset("assets/Images/FastB1.png",
            // width: 700,
            // height: 80
            // ,)
            // ,),

            // ClipRRect(
            // child: Image.asset("assets/Images/near_Places.png",
            // width: 113,
            // height: 22
            // ,)
            // ,),
            // ClipRRect(
            // child: Image.asset("assets/Images/tripCard.png",
            // width: 389,
            // height: 128
            // ,)
            // ,),

            // ClipRRect(
            // child: Image.asset("assets/Images/tripCard2.png",
            // width: 389,
            // height: 128
            // ,)
            // ,),

      ],
    ),),)
    
    
      
    );
  }
  void getBusPlaceAddressDetails()
  {
    Address address = Address();
    address.placeName = "Montaza";
    address.placeId = "NULL";
    address.latitude = 31.281936;
    address.longitude=30.010829;

    Provider.of<AppData>(context,listen: false).updateDropOffocationAddress(address);

    // Navigator.pop(context);
    int count = 0;
    Navigator.popUntil(context, (route) {
    return count++ == 3;
});


  }
}
