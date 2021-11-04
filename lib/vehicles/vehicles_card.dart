import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class VehicleCard extends StatelessWidget {
  VehicleCard({Key? key, required this.index}) : super(key: key);

  final index;

  static DateTime now = DateTime.now();
  static DateFormat formatter = DateFormat('hh:mm');


  var startDateText = 'اليوم';
  var startDate = formatter.format(now);
  var reachDateText = 'الوصول';
  var reachDate = formatter.format(now.add(Duration(minutes: 40)));

  var pickUpLocations = ['محطة ترام رشدي', 'شارع ابو قير'];
  var dropOffLocations = ['سان ستيفانو', 'سان ستيفانو'];

  var minutesRemainingStart = ['دقيقتين مشي للمحطة', 'خمسة عشر دقيقة مشي للمحطة'];
  var minutesRemainingEnd = ['خمسة دقائق مشي للمحطة', 'سبعة عشر دقيقة مشي للمحطة'];

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
                                Text(minutesRemainingStart[index], style: TextStyle(fontSize: 12),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(pickUpLocations[index], style: TextStyle(fontSize: 20))
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
                                Text(startDateText, style: TextStyle(fontSize: 25))
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
                                Text(minutesRemainingEnd[index], style: TextStyle(fontSize: 12),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(dropOffLocations[index], style: TextStyle(fontSize: 20))
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
                                Text(reachDateText, style: TextStyle(fontSize: 25)),
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
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
