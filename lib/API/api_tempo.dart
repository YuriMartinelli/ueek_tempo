import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class Api_tempo {
  Future<List> fetch() async {
    var permissao = await Permission.location.status;

    if (permissao.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Uri url = Uri.https("api.open-meteo.com", "/v1/forecast", {
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
        "hourly": "temperature_2m",
        "timezone": "auto",
        "forecast_days": "1"
      });

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var datas_temps = TratarJson(response.body);


        return datas_temps;
      } else {
        print("Falhou a requisição: ${response.reasonPhrase}");
      }
    } else {
      if (permissao.isDenied) {
        await Permission.location.request();
      }
    }
    return [];
  }

  List TratarJson(var jsonOld) {

    var jsonDecodificado = json.decode(jsonOld);

    var datas = jsonDecodificado["hourly"];

    var datas_temps = [];

    for (var element in datas["time"]) {
      for (var temp in datas["temperature_2m"]) {
        datas_temps.add({"data": element, "temp": temp});
      }
    }

    return datas_temps;
  }
}
