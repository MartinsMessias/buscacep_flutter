import 'package:flutter/material.dart';
import 'package:buscacep_flutter/components/home_page.dart';


void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      title: "Pet Life",
      home: HomePage(),
    );
  }
}