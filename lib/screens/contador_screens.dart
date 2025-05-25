import 'package:flutter/material.dart';

class ContadorScreen extends StatefulWidget {
  ContadorScreen({super.key});

  @override
  State<ContadorScreen> createState() => _ContadorScreenState();
}

class _ContadorScreenState extends State<ContadorScreen> {
  var contador = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi primer App', style: TextStyle(color: Color(0xFFFFFFFF)),),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text('Valor del Contador $contador', style: TextStyle(fontSize: 25, color: Color.fromARGB(219, 242, 126, 24)),)
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.ads_click),
        onPressed: (){
          contador++;
          print(contador);
          setState(() {
            
          });
        }
      ),
    ); 
  }
}