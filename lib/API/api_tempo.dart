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

      print(position);

      Uri url = Uri.https("api.open-meteo.com", "/v1/forecast", {
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
        "current": "weather_code",
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
    var codigo_clima = jsonDecodificado["current"]["weather_code"];

    var datas_temps = [];

    for (var element in datas["time"]) {
      for (var temp in datas["temperature_2m"]) {
        datas_temps
            .add({"data": element, "temp": temp, "condicao": codigo_clima});
      }
    }

    var data_agora = DateTime.now();

    var hora_certa_previsao = null;

    for (var data in datas_temps) {
      var diferenca = DateTime.parse(data["data"]).difference(data_agora).abs();

      if (diferenca < Duration(hours: 4)) {
        hora_certa_previsao = data;
        break;
      }
    }

    hora_certa_previsao = DefinirClima(hora_certa_previsao);

    return hora_certa_previsao;
  }

  Object DefinirClima(var previsao) {
    var path = 'assets/images/';

    if (previsao['condicao'] == 0) {
      path = path + 'sunny.png';
      previsao["Clima"] = "Ensolarado";
    } else if (previsao['condicao'] < 4 && previsao['condicao'] > 0) {
      path = path + 'partly cloudy.png';
      previsao["Clima"] = "Parcialmente Nublado";
    } else if (previsao['condicao'] == 45 || previsao['condicao'] == 48) {
      path = path + 'foggy.png';
      previsao["Clima"] = "Nebuloso";
    } else if (previsao['condicao'] > 50 && previsao['condicao'] < 56) {
      path = path + 'drizzle.png';
      previsao["Clima"] = "Chuvisco";
    } else if (previsao['condicao'] > 60 && previsao['condicao'] < 66) {
      path = path + 'rainy.png';
      previsao["Clima"] = "Chuvoso";
    } else if (previsao['condicao'] > 70 && previsao['condicao'] < 76) {
      path = path + 'snowy.png';
      previsao["Clima"] = "Nevado";
    } else if (previsao['condicao'] > 90) {
      path = path + 'thunderstorm.png';
      previsao["Clima"] = "Tempestade de raios";
    }

    previsao['path_clima'] = path;

    print(previsao);

    return previsao;
  }
}
