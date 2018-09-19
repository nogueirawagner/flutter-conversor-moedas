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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text("Conversor"),
          backgroundColor: Colors.amber,
          centerTitle: true),
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
                          TextField(
                            decoration: InputDecoration(
                                labelText: "Reais",
                                labelStyle: TextStyle(color: Colors.amber),
                                border: OutlineInputBorder(),
                                prefixText: "R\$"),
                            style:
                                TextStyle(color: Colors.amber, fontSize: 25.0),
                          ),
                          Divider(),
                          TextField(
                            decoration: InputDecoration(
                                labelText: "Dólares",
                                labelStyle: TextStyle(color: Colors.amber),
                                border: OutlineInputBorder(),
                                prefixText: "US\$"),
                            style:
                                TextStyle(color: Colors.amber, fontSize: 25.0),
                          ),
                          Divider(),
                           TextField(
                            decoration: InputDecoration(
                                labelText: "Euros",
                                labelStyle: TextStyle(color: Colors.amber),
                                border: OutlineInputBorder(),
                                prefixText: "€\$"),
                            style:
                                TextStyle(color: Colors.amber, fontSize: 25.0),
                          )
                        ],
                      ));
                }
            }
          }),
    );
  }
}
