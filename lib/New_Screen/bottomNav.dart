import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Assistants/singleton_handler.dart';
import 'package:mowasla_prototype/New_Screen/home_screen.dart';
import 'package:mowasla_prototype/Register/sign_in.dart';
import 'package:mowasla_prototype/Register/sign_up.dart';
import 'package:mowasla_prototype/main_final.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:mowasla_prototype/New_Screen/bus_screen.dart';
import 'package:mowasla_prototype/New_Screen/rail_train.dart';
import 'package:mowasla_prototype/New_Screen/taxi.dart';
import 'package:mowasla_prototype/New_Screen/train.dart';


import 'navigation_drawer_widget.dart';

class contextNav extends StatefulWidget {
  // static int indexpage = 2;
  // static const String idScreen = "MainScreen";

    int getcurrentindex()
  {
    int indexpage=2;


    return indexpage;
  }

  // const contextNav({ Key? key }) : super(key: key);

  @override
  _contextNavState createState() => _contextNavState();
}
    
    var s1 = Singleton();
    int __currentIndex = s1.getindex;

    // ValueNotifier<int> _notifier = s1.getindex as ValueNotifier<int>;
    
    

     
    final List<Widget> __children = [
      const Taxi(),
      const Train(),
      const Homeroute(),
      // const Bus(),
      const rail_train()
    ];

class _contextNavState extends State<contextNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      __children[s1.getindex],
      
      // __children[__currentIndex]
      bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: s1.getindex,
      // currentIndex: __currentIndex,
      
      

      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.local_taxi),
            title: Text('Taxi'),
            backgroundColor: Colors.orange.shade500
            ),
            BottomNavigationBarItem(icon: Icon(Icons.train,)
            ,title: Text("Train"),
            backgroundColor: Colors.red
            ),

            BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.white,)
            ,title: Text("Home"),
            backgroundColor: Colors.black
            
            ),
            BottomNavigationBarItem(icon: new Image.asset("assets/Images/Bus.png",
            width: 24.0
            ,height: 24.0,
            ),title: Text("Bus")
            ,backgroundColor: Colors.blue
            
            ),
            
            BottomNavigationBarItem(icon: new Image.asset("assets/Images/Tram.png",
            height: 24.0,
            width: 24.0,)
            ,title: Text("Rail Trains"),
            backgroundColor: Colors.purple ),

      ],

        onTap: (index)
        {
          setState(() {
            s1.setindex = index;
            print(s1.getindex);
            print(s1.getindex);
          });
          
        },
      
    )
    
    );

    

    

  }


}
