//import 'package:Todo/main.dart';
import 'package:Todo/sqlite/todo.dart';
import 'package:flutter/material.dart';
import 'package:Todo/sqlite/db_helper.dart';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class ADD extends StatefulWidget {
  final Todo todos;
  final String title;
  final id;
  ADD({Key key, this.title, this.id, this.todos}) : super(key: key);

  @override
  _ADDState createState() => _ADDState();
}

class _ADDState extends State<ADD> {
  Future<List<Todo>> todo;
  final ctitle = TextEditingController();
  final cdescription = TextEditingController();

  bool appmethod;
  String title;
  String description;
  bool isDone = false;
  DateTime createdAt;
  int curUserId;
  int bgcolor;

  final formKey = new GlobalKey<FormState>();
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    appmethod = false;
    refreshList();
    if (widget.todos == null) {
      appmethod = true;
      bgcolor = 0xFFFFFFFF;
    } else {
      appmethod = false;
      curUserId = widget.todos.id;
      ctitle.text = widget.todos.title;
      cdescription.text = widget.todos.description;
      bgcolor = widget.todos.bgcolor;
    }
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
      if (appmethod == false) {
        Todo e = Todo(curUserId, title, description, isDone, bgcolor);
        dbHelper.update(e);
        setState(() {
          appmethod = false;
        });
        Fluttertoast.showToast(
            msg: 'Todo was Update',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      } else {
        Todo e = Todo(null, title, description, isDone, bgcolor);
        print(bgcolor);
        dbHelper.save(e);
        Fluttertoast.showToast(
            msg: '$title was Save',
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            textColor: Colors.white);
      }
      //clearName();
      // refreshList();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
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
              // style: TextStyle(
              //     color: bgcolor != 0xFFFFFFFF ? Colors.white : Colors.black,),
              decoration: new InputDecoration(
                  
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    fontSize: 20.0,
                    color: Colors.redAccent,
                  )),
              validator: (val) => val.length == 0 ? 'Enter Title' : null,
              onSaved: (val) => title = val,
            ),
            Divider(),

            TextFormField(
              controller: this.cdescription,
              keyboardType: TextInputType.text,
              maxLines: 25,
              textCapitalization: TextCapitalization.sentences,
              
              // style: TextStyle(
              //     color: bgcolor == 0xFFFFFFFF ? Colors.black : Colors.white),
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: 'Description',
                hintStyle: TextStyle(fontSize: 20.0, color: Colors.redAccent),
              ),
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

  Widget _buildButtonSave() {
    return IconButton(
        icon: Icon(appmethod == true ? Icons.save : Icons.mode_edit),
        onPressed: (validate));
  }

  Widget _buildButtonCOlor() {
    return IconButton(
      icon: Icon(Icons.color_lens),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFFFFFFFF;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 75.0,
                                height: 75.0,
                              ))
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFF673AB7;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFF673AB7)))
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFFE65100;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFFE65100)))
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFFD50000;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFFD50000)))
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFF1A237E;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFF1A237E)))
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFFD81B60;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFFD81B60)))
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFF1B5E20;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFF1B5E20)))
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFF0091EA;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFF0091EA)))
                        ],
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  bgcolor = 0xFF00695C;
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                  width: 75.0,
                                  height: 75.0,
                                  color: Color(0xFF00695C)))
                        ],
                      ),
                    ],
                  ),
                ],
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text(appmethod == true ? "Create" : "Update"),
        actions: <Widget>[
          _buildButtonCOlor(),
          _buildButtonSave(),
        ],
      ),
      body: Container(
          color: Color(bgcolor),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[form()],
            ),
          )),
    );
    return scaffold;
  }
}
