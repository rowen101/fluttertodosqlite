import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final  about;
   About({Key key, @required this.about}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text('About'),
       elevation: 1.0,
     ),
     body:Center(child: Text('About '),),
    );
  }
}