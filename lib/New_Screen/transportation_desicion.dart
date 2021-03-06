import 'package:flutter/material.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/Models/bus_search.dart';
import 'package:mowasla_prototype/New_Screen/bus_screen.dart';
import 'package:mowasla_prototype/Assistants/singleton_handler.dart';
import 'package:mowasla_prototype/New_Screen/bottomNav.dart';
import 'package:mowasla_prototype/New_Screen/home_screen.dart';
import 'package:mowasla_prototype/New_Screen/rail_train.dart';
import 'package:mowasla_prototype/New_Screen/taxi.dart';
// import 'package:mowasla_prototype/SearchScreen/search_screen.dart';
import 'search_trips.dart';
import 'package:provider/provider.dart';

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

          IconButton(icon: Image.asset("assets/Images/tram.jpg"),
            onPressed: ()
            {
              s1.setindex=1;
              s1.getindex;
              print(s1.getindex);
              // Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => Bus()));

              
            }
          ),
            IconButton(icon: Image.asset("assets/Images/train.jpg"),
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
            IconButton(icon: Image.asset("assets/Images/taxi.jpg"),
            onPressed: ()
            {
              s1.setindex=1;
              s1.getindex;
              print(s1.getindex);
              Navigator.pushNamedAndRemoveUntil(context, Homeroute.idScreen, (route) => false);
            }
          ),
            IconButton(icon: Image.asset("assets/Images/bus.jpg", width: 200,height: 200,),
            onPressed: ()
            {
              Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              // getBusPlaceAddressDetails();
            }
          ),


        ],

              
              
            ),
      ]
        
      )
    )
  );
  }

//   void getBusPlaceAddressDetails()
//   {
//     Address address = Address();
//     address.placeName = "Montaza";
//     address.placeId = "NULL";
//     address.latitude = 31.281936;
//     address.longitude=30.010829;

//     Provider.of<AppData>(context,listen: false).updateDropOffocationAddress(address);

//     // Navigator.pop(context);
//     int count = 0;
//     Navigator.popUntil(context, (route) {
//     return count++ == 2;
// });


//   }
}