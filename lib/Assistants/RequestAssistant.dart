import 'dart:convert';

import 'package:http/http.dart' as http; 

class RequestAssistant
{
  late String url;
  static Future<dynamic> getRequest(url) async
  {
    http.Response response = await http.get(Uri.parse(url));

    try
    {
          if(response.statusCode == 200)
    {
      String jSonData = response.body;
      var decodeDate = jsonDecode(jSonData);
      return decodeDate;
    }
    else
    {
      return 'Failed, No Response.';
    }

    }
    catch(exp)
    {
      return 'Failed, No Response.';
    }



  }

}