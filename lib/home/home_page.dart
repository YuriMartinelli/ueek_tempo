import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ueek_tempo/API/api_tempo.dart.';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic previsao;

  @override
  void initState() {
    super.initState();
    ConsultarApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 100.0, bottom: 8.0, right: 20.0, left: 25.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(children: [
                Image.asset('assets/images/Logo_ueek.png'),
              ]),
              Container(height: 50),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 50, bottom: 50, left: 0, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Verificando se previsao foi inicializada antes de acessá-la
                        Text(
                          previsao != null ? previsao['temp'].toString() : "",
                          style:
                              TextStyle(fontSize: 27, color: Colors.blueAccent),
                        ),
                        Text(
                          previsao != null
                              ? previsao['condicao'].toString()
                              : "",
                          style: TextStyle(fontSize: 27),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(height: 250),
              Container(
                color: const Color.fromARGB(255, 54, 49, 49),
                width: 375,
                height: 97,
                child: ElevatedButton(
                    onPressed: () async {
                      await ConsultarApi();
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8))),
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          const Color.fromARGB(255, 71, 119, 158)),
                    ),
                    child: Text("Atualizar", style: TextStyle(fontSize: 30))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Object> ConsultarApi() async {
    var fetchedData = await Api_tempo().fetch();
    setState(() {
      previsao = fetchedData;
    });
    return fetchedData;
  }
}
