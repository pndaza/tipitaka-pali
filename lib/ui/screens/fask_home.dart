import 'package:flutter/material.dart';

class FakeHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.yellowAccent,
      child: Center(child: Text('hello'),),
    );
  }
}