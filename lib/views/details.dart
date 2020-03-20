
import 'package:Todo/sqlite/todo.dart';
import 'package:flutter/material.dart';

class TodoDetails extends StatelessWidget {
  final Todo todos;
 TodoDetails({Key key ,@required this.todos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(todos.title),
         actions: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
         
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
         ]
      ),
      body: Container(
        child: Column(
           children: <Widget>[
             Text(todos.description, style: TextStyle(fontSize: (10.0)),)
           ],
        ),
      ),
    );
  }
}