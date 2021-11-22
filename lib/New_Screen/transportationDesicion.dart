import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/New_Screen/bus.dart';
import 'package:mowasla_prototype/Assistants/Singleton.dart';
import 'package:mowasla_prototype/New_Screen/bottomNav.dart';
import 'package:mowasla_prototype/New_Screen/homeScreen.dart';
import 'package:mowasla_prototype/New_Screen/rail_train.dart';
import 'package:mowasla_prototype/New_Screen/taxi.dart';

class chooseRoute extends StatefulWidget {
  const chooseRoute({ Key? key }) : super(key: key);

  @override
  _chooseRouteState createState() => _chooseRouteState();
}

class _chooseRouteState extends State<chooseRoute> {
  var s1 = Singleton();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(child:Column(children: [SizedBox(height: 100.0,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          IconButton(icon: const Icon(Icons.bus_alert),
            onPressed: ()
            {
              s1.setindex=1;
              s1.getindex;
              print(s1.getindex);
              // Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Bus()));

              
            }
          ),
            IconButton(icon: const Icon(Icons.bus_alert),
            onPressed: ()
            {
              s1.setindex=1;
              s1.getindex;
              print(s1.getindex);
              // Navigator.push(context,
                    // MaterialPageRoute(builder: (context) => Taxi()));

              Navigator.pushNamedAndRemoveUntil(context, Bus.idScreen, (route) => true);
            }
          ),
            IconButton(icon: const Icon(Icons.local_taxi),
            onPressed: ()
            {
              s1.setindex=1;
              s1.getindex;
              print(s1.getindex);
              Navigator.pushNamedAndRemoveUntil(context, Homeroute.idScreen, (route) => false);
            }
          ),
            IconButton(icon: const Icon(Icons.local_taxi),
            onPressed: ()
            {
              s1.setindex=1;
              s1.getindex;
              print(s1.getindex);
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Bus()));
            }
          ),


        ],

              
              
            ),
      ]
        
      )
    )
  );
  }

  void getBusPlaceAddressDetails()
  {
    Address address = Address();
    address.placeName = "Montaza";
    address.placeId = "NULL";
    address.latitude = 31.282013;
    // address.longitude=

  }
}