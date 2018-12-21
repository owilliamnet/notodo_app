import 'package:flutter/material.dart';
import 'package:notodo_app/UI/notodo_screen.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("NoTodo"),
      ),
      body: NoTodoScreen(),
    );
  }
}