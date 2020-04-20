import 'package:Todo/sqlite/todo.dart';
import 'package:Todo/views/add.dart';

import 'package:flutter/material.dart';

class TodoDetails extends StatelessWidget {
  final Todo todos;
  TodoDetails({Key key, @required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(todos.title), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new ADD(todos: todos),
                ));
          },
        ),
        // PopupMenuButton(itemBuilder: (BuildContext context) {

        //   return [
        //     PopupMenuItem(
        //       child:Text('Check'),
        //       value: "1",
        //     ),
        //   ];

        // })
      ]),
      body: Container(
        padding: EdgeInsets.all(10.0),
        color: Color(todos.bgcolor),
        child: ListView(
          children: <Widget>[
            Text(
              todos.description,
              style: TextStyle(
                  fontSize: (20.0),
                  color: todos.bgcolor == 0xFFFFFFFF
                      ? Colors.black
                      : Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
