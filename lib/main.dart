import 'package:flutter/material.dart';

void main() {
  runApp(const EcoDataAtlasApp());
}

class EcoDataAtlasApp extends StatelessWidget {
  const EcoDataAtlasApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoDataAtlas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(body: Column(children: [Text('EcoDataAtlas')])),
    );
  }
}
