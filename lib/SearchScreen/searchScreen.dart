import 'package:flutter/material.dart';
import 'package:mowasla_prototype/Assistants/RequestAssistant.dart';
import 'package:mowasla_prototype/DataHandler/appData.dart';
import 'package:mowasla_prototype/Models/address.dart';
import 'package:mowasla_prototype/Models/placePredictions.dart';
import 'package:mowasla_prototype/all_Widgets/Divider.dart';
import 'package:mowasla_prototype/mainScreen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController pickUpTextEdtingController = TextEditingController();
    TextEditingController dropOffTextEditingController =
        TextEditingController();
    String placeAddress =
        Provider.of<AppData>(context).pickupLocation!.placeName ?? "";
    pickUpTextEdtingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 225.0,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 6.0,
                spreadRadius: 0.5,
                offset: Offset(0.7, 0.7),
              )
            ]),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 5.0,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Center(
                        child: Text(
                          "Set Drop off",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      // Image.asset("images/pickIcon.png",height: 16.0,width: 16.0,),
                      Icon(Icons.ac_unit),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: TextField(
                            controller: pickUpTextEdtingController,
                            decoration: InputDecoration(
                              hintText: "Pickup Location",
                              fillColor: Colors.grey[400],
                              filled: true,
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 11.0, top: 8.0, bottom: 8.0),
                            ),
                          ),
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    children: [
                      // Image.asset("images/pickIcon.png",height: 16.0,width: 16.0,),
                      Icon(Icons.ac_unit),
                      SizedBox(
                        width: 18.0,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val) {
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to ?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11.0, top: 8.0, bottom: 8.0),
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
          ),
          (placePredictionList.length > 0)
              ? Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return PredictionTile(
                          placePredictions: placePredictionList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        DividerWidget(),
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  void findPlace(String placename) async {
    if (placename.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placename&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI&sessiontoken=1234567890&components=country:eg";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if (res == "failed") {
        return;
      }

      if (res["status"] == "OK") {
        var predictions = res["predictions"];

        var placeList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();

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
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SuggestionsScreen(place_id: placePredictions.place_id,)));
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(
              width: 14.0,
            ),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${placePredictions.main_text}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        "${placePredictions.secondart_text}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({Key? key, required this.place_id}) : super(key: key);

  final place_id;

  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image(
          image: AssetImage('assets/images/mwasla_logo.png'),
          height: 40.0,
        ),
      ),
      body: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return VehicleCard(index: index, place_id: widget.place_id,);
          }),
    );
  }
}

class VehicleCard extends StatelessWidget {
  VehicleCard({Key? key, required this.index, required this.place_id}) : super(key: key);

  final index;
  final place_id;

  static DateTime now = DateTime.now();
  static DateFormat formatter = DateFormat('hh:mm');

  var startDateText = 'اليوم';
  var startDate = formatter.format(now);
  var reachDateText = 'الوصول';
  var reachDate = formatter.format(now.add(Duration(minutes: 40)));

  var pickUpLocations = ['محطة ترام رشدي', 'شارع ابو قير'];
  var dropOffLocations = ['سان ستيفانو', 'سان ستيفانو'];

  var minutesRemainingStart = [
    'دقيقتين مشي للمحطة',
    'خمسة عشر دقيقة مشي للمحطة'
  ];
  var minutesRemainingEnd = [
    'خمسة دقائق مشي للمحطة',
    'سبعة عشر دقيقة مشي للمحطة'
  ];

  var prices = ['5', '4'];

  var categories = ['ترام', 'اوتوبيس'];
  var conditioningState = ['مكيف', 'غير مكيف'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          padding: EdgeInsets.only(top: 10, right: 5, left: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
          ),
          child: Card(
            elevation: 10,
            child: ListTile(
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 170,
                        height: 100,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  minutesRemainingStart[index],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(pickUpLocations[index],
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 100,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(startDateText,
                                    style: TextStyle(fontSize: 25))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(startDate.toString()),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 170,
                        height: 100,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  minutesRemainingEnd[index],
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(dropOffLocations[index],
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 100,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(reachDateText,
                                    style: TextStyle(fontSize: 25)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(reachDate.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text("${prices[index]} EGP"),
                          ],
                        ),
                        SizedBox(width: 170),
                        Text(conditioningState[index]),
                        SizedBox(width: 10),
                        Text(categories[index]),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () {
                getPlaceAddressDetails(place_id, context);
              },
            ),
          ),
        ),
      ],
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI';

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    if (res == "failed") {
      return;
    }

    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];

      Provider.of<AppData>(context, listen: false)
          .updateDropOffocationAddress(address);
      print("this is Drop off Location :: ");
      print(address.placeName);

      Navigator.of(context).pushNamed(mainScreen.idScreen);
    }
  }
}
