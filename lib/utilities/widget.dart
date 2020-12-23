import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarMain extends StatelessWidget {
  AppBarMain({@required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontSize: 25.0),
      ),
    );
  }
}
