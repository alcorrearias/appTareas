import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const MaterialApp(
      home: HomePage()
    ),
  );
}

class MyModel {
  final String titulo;
  final String estado;

  MyModel({required this.titulo, required this.estado});

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      titulo: json['titulo'],
      estado: json['estado'],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key}); 

  // This widget is the root of your application.
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    
  getTareas() async {
    var url = Uri.parse('http://127.0.0.1:8001/api/tareas');
    http.Response response = await http.get(url);    
    debugPrint(response.body);
    if (response.statusCode == 200) {
      
  } else {
    
  }
    
  }
  
@override
  void initState(){
    super.initState();
    getTareas();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: const Text('Lista Tareas') ,
      backgroundColor: Colors.indigo[300],),
      //body: ListView.builder(),
      );
    }
}


