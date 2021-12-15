import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Assistants/singleton_handler.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/Models/address_pickup.dart';
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

  Widget ticketButton (path,action){
    return InkWell(child:Image.asset(path),
    onTap:(){action;}  );
  }
  
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
                // Image.asset("assets/Images/tripCard4.png"),
                // ticketButton("assets/Images/tripCard4.png", getBusPlaceAddressDetails("abo qir",31.267422,30.000164, "ba7ry" ,31.202047,29.916242)),
                InkWell(child:Image.asset("assets/Images/tripCard4.png"),
                onTap:(){getBusPlaceAddressDetails("abo qir",31.267422,30.000164, "" ,31.202047,29.916242);}  ),
                // IconButton(onPressed: ()
                // {
                //   getBusPlaceAddressDetails("Montaza",31.281936,30.010829, "ba7ry" , 31.204301,29.903726);
                //   s1.setindex=2;
                  

                // },iconSize: 300
                // , icon: Image.asset("assets/Images/tripCard4.png")),


      ],
    ),),)
    
    
      
    );
  }
 getBusPlaceAddressDetails(addressNamedDropoff, addressLatDropoff, addressLonDropOff,addressNamedPickUp,addressLatPickup,addressLonPickup )
  {

    // PickUpAddress pickUpAddress = PickUpAddress();
    Address pickUpAddress = Address();

    pickUpAddress.placeName = addressNamedPickUp;
    pickUpAddress.placeId = "null";
    pickUpAddress.latitude= addressLatPickup;
    pickUpAddress.longitude = addressLonPickup;

    Provider.of<AppData>(context,listen: false).updatePickUpLocationAddress(pickUpAddress);


    Address address = Address();
    address.placeName = addressNamedDropoff;
    address.placeId = "null";
    address.latitude = addressLatDropoff;
    address.longitude=addressLonDropOff;

    Provider.of<AppData>(context,listen: false).updateDropOffocationAddress(address);

    

    // Navigator.pop(context);
    int count = 0;
    Navigator.popUntil(context, (route) {
    return count++ == 2;
    });
    


  }
}
