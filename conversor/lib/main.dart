import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const req =
    "https://api.hgbrasil.com/finance/quotations?format=json&key=f7e5fa97";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white)));
}

Future<Map> getData() async {
  http.Response res = await http.get(req);
  return json.decode(res.body);
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Home> {
  double dolar;
  double euro;

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = " " + (real / dolar).toStringAsFixed(2);
    euroController.text = " " + (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolarTxt = double.parse(text);
    realController.text = " " + (dolarTxt * dolar).toStringAsFixed(2);
    euroController.text = " " + (dolarTxt * dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euroTxt = double.parse(text);
    realController.text = " " + (euroTxt * euro).toStringAsFixed(2);
    dolarController.text = " " + (euroTxt * euro / dolar).toStringAsFixed(2);
  }

  void _refresh() {
    setState(() {
      realController.text = " ";
      dolarController.text = " ";
      euroController.text = " ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _refresh)
        ],
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text("Carregando dados...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Ocorreu um erro ao carregar os dados",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center),
                  );
                } else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber[300]),
                          buildTextField(
                              "Reais", "R\$ ", realController, _realChanged),
                          Divider(),
                          buildTextField("Dólares", "US\$ ", dolarController,
                              _dolarChanged),
                          Divider(),
                          buildTextField(
                              "Euros", "€\$ ", euroController, _euroChanged),
                        ],
                      ));
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController moedaCtrl, Function f) {
  return TextField(
    controller: moedaCtrl,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: f,
    keyboardType: TextInputType.number,
  );
}
