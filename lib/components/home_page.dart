import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textCep = new TextEditingController();
  String resultado = "";
  final key = new GlobalKey<ScaffoldState>();
  var maskFormatter = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  _consultaCep() async {
    String cep = textCep.text;
    String url = "https://viacep.com.br/ws/$cep/json/";

    http.Response response;
    response = await http.get(url);

    Map<String, dynamic> resposta = json.decode(response.body);

    String logradouro = resposta["logradouro"];
    String cidade = resposta["localidade"];
    String bairro = resposta["bairro"];
    String uf = resposta["uf"];

    setState(() {
      resultado = logradouro != null
          ? "$cidade - $uf\n$logradouro\nBairro $bairro"
          : "Digite um CEP válido";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(children: <Widget>[
              Icon(
                Icons.pin_drop,
                size: 100,
                color: Colors.amber,
              ),
              Text("Busca CEP",
                  style: GoogleFonts.getFont('Krona One',
                      textStyle: TextStyle(fontSize: 30, color: Colors.amber))),
            ]),
            GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: resultado));
                key.currentState.showSnackBar(SnackBar(
                  content: Text("Copiado!"),
                ));
              },
              child: Text(
                resultado != null ? "$resultado" : "Digite um CEP válido",
                style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20)),
                textAlign: TextAlign.justify,
              ),
            ),
            TextField(
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              cursorColor: Colors.amber,
              style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 20)),
              decoration: InputDecoration(
                  labelText: "Digite o CEP para consultar",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.amber))),
              controller: textCep,
            ),
            ButtonTheme(
              minWidth: 200.0,
              height: 50,
              child: RaisedButton(
                onPressed: () {
                  _consultaCep();
                },
                color: Colors.amber,
                child: Text(
                  'Consultar',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
