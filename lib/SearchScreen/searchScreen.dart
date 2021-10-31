import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Assistants/RequestAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/placePredictions.dart';
import 'package:mowasla_prototype/all_Widgets/Divider.dart';
import 'package:provider/provider.dart';


class SearchScreen extends StatefulWidget {


  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {

      TextEditingController pickUpTextEdtingController = TextEditingController();
      TextEditingController dropOffTextEditingController = TextEditingController();
      String placeAddress = Provider.of<AppData>(context).pickupLocation!.placeName ?? "";
      pickUpTextEdtingController.text = placeAddress;
      
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 225.0,
            decoration: BoxDecoration(
              color:Colors.white,
              boxShadow: 
              [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                )
              ] ),

              child: Padding(
                padding: EdgeInsets.only(left: 25.0,top: 20.0,right: 25.0,bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: ()
                          {
                            Navigator.pop(context);
                          } ,
                          child: Icon(
                            Icons.arrow_back
                            ),
                        ),
                        Center(
                          child: Text("Set Drop off", style: TextStyle(fontSize: 18.0),),
                        )
                       ]
                      ,),
                      SizedBox(height:16.0,),
                      Row(
                        children: [
                          // Image.asset("images/pickIcon.png",height: 16.0,width: 16.0,),
                          Icon(Icons.ac_unit),
                          SizedBox(width: 18.0,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                              color:Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Padding(
                              padding:EdgeInsets.all(3.0),
                              child: TextField(
                                controller:pickUpTextEdtingController ,
                                decoration: InputDecoration(
                                  hintText: "Pickup Location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left:11.0 , top: 8.0,bottom:8.0),
                                ),
                              ),),
                          )
                        )
                      ],
                    ),

                    SizedBox(height:16.0,),
                      Row(
                        children: [
                          // Image.asset("images/pickIcon.png",height: 16.0,width: 16.0,),
                          Icon(Icons.ac_unit),
                          SizedBox(width: 18.0,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                              color:Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Padding(
                              padding:EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (val)
                                {
                                  findPlace(val);
                                },
                                controller:dropOffTextEditingController ,
                                decoration: InputDecoration(
                                  hintText: "Where to ?",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left:11.0 , top: 8.0,bottom:8.0),
                                ),
                              ),
                              ),
                          ),
                          
                        )
                      ],
                    )


                  ],
                ),
              ),
          ),(placePredictionList.length > 0) ? Padding
          (padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListView.separated(padding: EdgeInsets.all(0.0),
          itemBuilder: (context, index)
          {
            return PredictionTile(placePredictions: placePredictionList[index]);
          },
          separatorBuilder: (BuildContext context, int index) => DividerWidget()
          ,itemCount: placePredictionList.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),),
          )
          : Container()
        ],
      ),
      
    );
  }

  void findPlace(String placename) async
  {
    if(placename.length > 1)
    {
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placename&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI&sessiontoken=1234567890&components=country:eg";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      

      if(res == "failed")
      {
        return;
      }

      if(res["status"] == "OK")
      {
        var predictions = res["predictions"];

        var placeList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();
        
        setState(() {
          placePredictionList = placeList;
          
          
        });



      }

    }

  }
}


class PredictionTile extends StatelessWidget {

  PredictionTile({required this.placePredictions});

   late final PlacePredictions placePredictions;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(width: 14.0,),
          Row(
            children: [
            Icon(Icons.add_location),
            SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${placePredictions.main_text}",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                  SizedBox(height: 3.0,),
                  Text("${placePredictions.secondart_text}",overflow : TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0,color: Colors.grey),)
                ],
              ),
            )
          ],
          
        ),
        SizedBox(width: 10.0,),
        ],
        
      ),
      
    );
  }
  
  
}