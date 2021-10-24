import 'package:geolocator/geolocator.dart';
import 'package:mowasla_prototype/Assistants/RequestAssistant.dart';

class AssistantMehtods
{
  static Future<String> searchCoodinateAddress(Position position) async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyDpGaGpj9uoLbfhxGzXru_25FkoOjsl_mI";

    var response = await RequestAssistant.getRequest(url);

    if(response != "failed")
    {
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }
}