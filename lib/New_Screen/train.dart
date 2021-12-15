import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:provider/provider.dart';
import 'navigation_drawer_widget.dart';



class Train extends StatefulWidget {
  const Train({ Key? key }) : super(key: key);
  static String idScreen = "train";

  @override
  _TrainState createState() => _TrainState();
}

class _TrainState extends State<Train> {
  
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
    body: 
    Container(child: 
    SingleChildScrollView(child: 
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: [

                Image.asset("assets/Images/FastB1.png"),
                
                //Image.asset("assets/Images/tripCar6.png"),

                InkWell(child:
                  Image.asset("assets/Images/tripCard7.png"),
                  onTap: (){
                    int count = 0;
                    Navigator.popUntil(context, (route) {
                    return count++ == 2;
                    });
                    // getTrainPlaceAddressDetails(addressNamedDropoff, addressLatDropoff, addressLonDropOff, addressNamedPickUp, addressLatPickup, addressLonPickup)

                    },

                ),
                
                Image.asset("assets/Images/tripCard8.png"),


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
  getTrainPlaceAddressDetails(addressNamedDropoff, addressLatDropoff, addressLonDropOff,addressNamedPickUp,addressLatPickup,addressLonPickup )
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