import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ueek_tempo/API/api_tempo.dart.';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 50, bottom: 50, left: 0, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Temperatura"), Text("Numvenzinha")],
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
                    onPressed: (){
                      var teste = Api_tempo().fetch();
                      print(teste);
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


}
