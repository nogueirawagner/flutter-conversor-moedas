import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const req =
    "https://api.hgbrasil.com/finance/quotations?format=json&key=f7e5fa97";

void main() async {
  runApp(MaterialApp(
    home: Home()
  ));
}

Future<Map> getData() async {
  http.Response res = await http.get(req);
  return json.decode(res.body);
}

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Home>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Conversor"),
        backgroundColor: Colors.amber,
        centerTitle: true,

      ),

    );
  }
}

