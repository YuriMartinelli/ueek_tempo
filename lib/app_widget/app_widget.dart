import 'package:flutter/material.dart';
import 'package:ueek_tempo/home/home_page.dart';

class AppWidget  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      title: 'Meu Aplicativo',
      home: HomePage()
    );
  }
}
