import 'package:flutter/material.dart';
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
    return Stack(
      children: [
        Image.asset('assets/images/background.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height),
        Padding(
          padding: const EdgeInsets.only(
              top: 100.0, bottom: 8.0, right: 20.0, left: 25.0),
          child: SizedBox(
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
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50, bottom: 50, left: 15, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                previsao != null ? "${previsao['temp']}ºC" : "",
                                style: const TextStyle(
                                  fontSize: 27,
                                  fontFamily: 'Sarabun',
                                  color: Color.fromRGBO(0, 191, 255, 1),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                previsao != null ? previsao['Clima'] : "",
                                style: const TextStyle(
                                  fontFamily: 'Mukta',
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset(
                            previsao != null
                                ? previsao['path_clima']
                                : "assets/images/padrao.png",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(height: 200),
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
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                            Color.fromRGBO(0, 191, 255, 1)),
                      ),
                      child: Text("Atualizar",
                          style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'Sarabun',
                              color: Color.fromRGBO(240, 240, 240, 1)))),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<Object?> ConsultarApi() async {
    var fetchedData = await Api_tempo().fetch();

    setState(() {
      previsao = fetchedData;
    });

    return fetchedData;
  }
}
