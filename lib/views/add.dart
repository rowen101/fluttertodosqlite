//import 'package:Todo/main.dart';
import 'package:Todo/sqlite/todo.dart';
import 'package:flutter/material.dart';
import 'package:Todo/sqlite/db_helper.dart';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

class ADD extends StatefulWidget {
  final String title;
  final id;
  ADD({Key key, this.title, this.id}) : super(key: key);

  @override
  _ADDState createState() => _ADDState();
}

class _ADDState extends State<ADD> {
  Future<List<Todo>> todo;
  TextEditingController ctitle = TextEditingController();
  TextEditingController cdescription = TextEditingController();
  String title;

  String description;
  bool isDone = false;
  DateTime createdAt;
  int curUserId;
  String bgcolor;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      todo = dbHelper.getTodoID(1);
    });
  }

  clearName() {
    ctitle.text = '';
    cdescription.text = '';
  }

  routerpage() {}
  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Todo e = Todo(curUserId, title, description, isDone,bgcolor);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
        Fluttertoast.showToast(msg: 'Todo was Update', toastLength: Toast.LENGTH_SHORT,
         backgroundColor: Colors.green, textColor: Colors.white);
      } else {
        Todo e = Todo(null, title, description, isDone,bgcolor);
        dbHelper.save(e);
          Fluttertoast.showToast(msg: '$title was Save', toastLength: Toast.LENGTH_SHORT,
         backgroundColor: Colors.green, textColor: Colors.white);
      }
      //clearName();
      // refreshList();
      Navigator.pop(context);
    }
  }

  form() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            
            TextFormField(
              controller: ctitle,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Title',),
              validator: (val) => val.length == 0 ? 'Enter Title' : null,
              onSaved: (val) => title = val,
            ),
            Divider(),
            TextFormField(
              controller: cdescription,
              keyboardType: TextInputType.text,
              maxLines: 20,
              textCapitalization: TextCapitalization.sentences,

              decoration: InputDecoration.collapsed(hintText: 'Description'),
              validator: (val) => val.length == 0 ? 'Enter Description' : null,
              onSaved: (val) => description = val,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     FlatButton(
            //       onPressed: validate,

            //       child: Text(isUpdating ? 'UPDATE' : 'ADD'),
            //       //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
            //     ),
            //     FlatButton(
            //       onPressed: () {
            //         setState(() {
            //           isUpdating = false;
            //         });
            //         // clearName();
            //         Navigator.pop(context);
            //       },
            //       child: Text('CANCEL'),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('Add Todo'),
        actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: (
                validate
               
              )
            ),
        ],
      ),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[form()],
      )),
    );
    return scaffold;
  }
}
