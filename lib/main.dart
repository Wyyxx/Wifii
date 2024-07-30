import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('ESP32 Communication')),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final String _esp32Ip = 'http://192.168.1.79'; 

  Future<void> _sendMessage() async {
    final String message = _controller.text;
    try {
      final response = await http.post(
        Uri.parse('$_esp32Ip/send'),
        body: {'message': message},
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Respuesta del ESP32'),
              content: Text(response.body),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al enviar mensaje: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Ingrese un mensaje',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendMessage,
            child: Text('Enviar mensaje al ESP32'),
          ),
        ],
      ),
    );
  }
}
