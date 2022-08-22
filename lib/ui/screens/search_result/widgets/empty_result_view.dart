import 'package:flutter/material.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({Key? key, required this.searchWord}) : super(key: key);
  final String searchWord;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text('Cannot find $searchWord.')),
    );
  }
}