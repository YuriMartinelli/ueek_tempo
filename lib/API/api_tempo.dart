import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class Api_tempo {
Future<Object?> fetch() async {
  var permissionStatus = await Permission.location.request();
  
  if (permissionStatus.isDenied) {
    // A permissão foi negada pelo usuário
    print("Permissão de localização negada pelo usuário.");
    return null;
  }
  
  var permissao = await Permission.location.status;

  if (permissao.isGranted) {
    Position posicao = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    Uri url = Uri.https("api.open-meteo.com", "/v1/forecast", {
      "latitude": posicao.latitude.toString(),
      "longitude": posicao.longitude.toString(),
      "current": "temperature_2m,weather_code"
    });

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var previsao = TratarJson(response.body);
      return previsao;
    } else {
      print("Falhou a requisição: ${response.reasonPhrase}");
    }
  }
  return null;
}


  Object TratarJson(var jsonOld) {
    var jsonDecodificado = json.decode(jsonOld);

    var temperatura = jsonDecodificado['current']['temperature_2m'];

    var codigo_clima = jsonDecodificado['current']['weather_code'];

    Object previsao = {'temp': temperatura, 'condicao': codigo_clima};

    previsao = DefinirClima(previsao);

    return previsao;
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

    return previsao;
  }
}
