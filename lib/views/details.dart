import 'package:flutter/material.dart';

class TodoDetails extends StatelessWidget {
  final  todo;
  const TodoDetails({Key key ,@required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$todo'),
      ),
      body: Container(
        child: Column(
           children: <Widget>[
             Text('$todo')
           ],
        ),
      ),
    );
  }
}