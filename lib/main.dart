import 'package:Todo/sqlite/todo.dart';
import 'package:Todo/views/details.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Todo/sqlite/db_helper.dart';
import 'package:Todo/views/add.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NOTE',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'NOTE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Todo>> todo;
  String title;
  String description;
  bool isDone;
  DateTime createdAt;
  int todoid;
  int bgcolor;

  Future<List<Todo>> getTodoFromDB() async {
    var dbHelper = DBHelper();
    Future<List<Todo>> todos = dbHelper.getTodo();

    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // drawer: Drawer(
        //   child: ListView(
        //     padding: EdgeInsets.zero,
        //     children: <Widget>[
        //       DrawerHeader(
        //           child: Text('Drawer Header'),
        //           decoration: BoxDecoration(color: Colors.blueGrey)),
        //       ListTile(
        //           title: Text("About"),
        //           onTap: () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => About(
        //                           about: null,
        //                         )));
        //           })
        //     ],
        //   ),
        // ),
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ADD(todos: null)));
              },
            ),
            // PopupMenuButton(itemBuilder: (BuildContext context) {
            //   return [
            //     PopupMenuItem(
            //       child: Text('About'),
            //     )
            //   ];
            // })
          ],
        ),
        body: new Container(
          color: Color(0xFFBDBDBD),
            padding: EdgeInsets.all(2.0),
            child: FutureBuilder<List<Todo>>(
              future: getTodoFromDB(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.all(0.0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TodoDetails(
                                            todos: snapshot.data[index],
                                          )));
                            },
                            child: Card(
                              color: Color(snapshot.data[index].bgcolor),
                              child: new Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      IconButton(
                                        color: Color(0xFFEEEEEE),
                                          icon: Icon(snapshot.data[index].isdone
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank),
                                          onPressed: () {
                                            var dbHelper = DBHelper();
                                            todoid = snapshot.data[index].id;
                                            title = snapshot.data[index].title;
                                            description = snapshot
                                                .data[index].description;
                                            isDone =
                                                snapshot.data[index].isdone;
                                            bgcolor =
                                                snapshot.data[index].bgcolor;
                                            if (isDone != true) {
                                              Todo e = Todo(todoid, title,
                                                  description, true, bgcolor);
                                              dbHelper.toggleTodoItem(e);
                                              setState(() {
                                                getTodoFromDB();
                                              });
                                            } else {
                                              Todo e = Todo(todoid, title,
                                                  description, false, bgcolor);
                                              dbHelper.toggleTodoItem(e);
                                              setState(() {
                                                getTodoFromDB();
                                              });
                                            }
                                          }),
                                    ],
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20.0,
                                          color: snapshot.data[index].bgcolor ==
                                                  0xFFFFFFFF
                                              ? Colors.black
                                              : Colors.white,
                                          decoration:
                                              snapshot.data[index].isdone
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                          fontStyle: snapshot.data[index].isdone
                                              ? FontStyle.italic
                                              : null,
                                        ),
                                      ),

                                      // Text(snapshot.data[index].description,
                                      //     style: TextStyle(color: Colors.grey[500])
                                      //     ),
                                    ],
                                  )),
                                  Column(
                                    children: <Widget>[
                                      IconButton(
                                        color: Color(0xFFEEEEEE),
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Delete"),
                                                  content: Text(
                                                      "Are you sure you want to move the note to the trash can?"),
                                                  actions: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('CANCEL'),
                                                        ),
                                                        FlatButton(
                                                          onPressed: () {
                                                            var dbHelper =
                                                                DBHelper();
                                                            dbHelper.delete(
                                                                snapshot
                                                                    .data[index]
                                                                    .id);
                                                            var toast = snapshot
                                                                .data[index]
                                                                .title;
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    '$toast move to trash',
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white);
                                                            setState(() {
                                                              getTodoFromDB();
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('OK'),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                      },
                    );
                  }
                } else if (snapshot.data.length == 0) {
                  return Text('No Record');
                }
                return new Container(
                  alignment: AlignmentDirectional.center,
                  child: new CircularProgressIndicator(),
                );
              },
            )));
  }
}
