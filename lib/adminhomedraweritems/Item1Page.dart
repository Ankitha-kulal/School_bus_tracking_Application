
import 'package:flutter/material.dart';

class Item1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Bus Management'),
      ),
      body: Center(
        child: Text('This is Item 1 Page'),
      ),
    );
  }
}