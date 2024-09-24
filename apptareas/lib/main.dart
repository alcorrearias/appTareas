import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MaterialApp(
      home: HomePage()
    ),
  );
}

class HomePage extends StatefulWidget {
 

  // This widget is the root of your application.
  @override
  _HomePageState createState() =>_HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  getTareas() async {
    http.Response response = await http.get(Uri.http("http://127.0.0.1:8001/api/tareas"));
    debugPrint(response.body);
  }
  
@override
  void initState(){
    super.initState();
    getTareas();
  }

  Widget build(BuildContext context) {
      return Scaffold(appBar: AppBar(title: Text('Lista Tareas') ,
      backgroundColor: Colors.indigo[300],),
      //body: ListView.builder(),
      );
    }
}


