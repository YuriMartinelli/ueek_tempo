import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class Api_tempo {

  Future<Object> fetch() async {
    var permissao = await Permission.location.status;

    if (permissao.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Uri url = Uri.https("api.open-meteo.com", "/v1/forecast", {
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
        "hourly": "temperature_2m,weather_code",
        "timezone": "auto",
        "forecast_days": "1"
      });

      print(url);

      var response = await http.get(url);

      if (response.statusCode == 200) {
        var previsao = TratarJson(response.body);

        return previsao;
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

  Object TratarJson(var jsonOld) {

    var jsonDecodificado = json.decode(jsonOld);
    var datas = jsonDecodificado["hourly"];
    var codigo_clima = jsonDecodificado["hourly_units"]["weather_code"];

    var datas_temps = [];

    for (var element in datas["time"]) {
      for (var temp in datas["temperature_2m"]) {
        datas_temps.add({"data": element, "temp": temp, "condicao":codigo_clima});
      }
    }

    var data_agora = DateTime.now();

    var hora_certa_previsao = null;

    for (var data in datas_temps) {
      var diferenca = DateTime.parse(data["data"]).difference(data_agora).abs();

      if (diferenca < Duration(hours: 4))  {
        hora_certa_previsao = data;
        break;
      }
    }
    return hora_certa_previsao;
  }
}
