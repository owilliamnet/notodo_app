import 'package:flutter/material.dart';
import 'package:notodo_app/UI/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoTodo',
      home: Home(),
    );
  }
}