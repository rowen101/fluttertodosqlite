import 'package:Todo/sqlite/todo.dart';
import 'package:Todo/views/details.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Todo/sqlite/db_helper.dart';
import 'package:Todo/views/about.dart';
import 'package:Todo/views/add.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Todo'),
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
  Future<List<Todo>> getTodoFromDB() async {
    var dbHelper = DBHelper();
    Future<List<Todo>> todos = dbHelper.getTodo();

    return todos;
  }

  TextEditingController controller = TextEditingController();
  TextEditingController cdescription = TextEditingController();
  String name;
  String description;
  int curUserId;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  bool isUpdating;

  @override
  void initState() {
    super.initState();

    isUpdating = false;
  }

  SingleChildScrollView dataTable(List<Todo> todo) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('TITLE')),
          DataColumn(label: Text('DESCRIPTON')),
          // DataColumn(label: Text('DELETE')),
          DataColumn(label: Text('View'))
        ],
        rows: todo
            .map(
              (todos) => DataRow(cells: [
                DataCell(Text(todos.title), onTap: () {
                  setState(() {
                    isUpdating = true;
                    curUserId = todos.id;
                  });
                  controller.text = todos.title;
                  cdescription.text = todos.description;
                }),
                DataCell(Text(todos.description), onTap: () {
                  // setState(() {
                  //   isUpdating = true;
                  //   curUserId = employees.id;
                  // });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ADD(
                                id: todos.id,
                              )));
                  controller.text = todos.title;
                  cdescription.text = todos.description;
                }),
                // DataCell(IconButton(
                //   icon: Icon(Icons.delete),
                //   onPressed: () {
                //     dbHelper.delete(todos.id);
                //     refreshList();
                //   },
                // )),
                DataCell(IconButton(
                  icon: Icon(Icons.details),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TodoDetails(todo: todos.title)));
                  },
                )),
              ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Text('Drawer Header'),
                  decoration: BoxDecoration(color: Colors.blueGrey)),
              ListTile(
                  title: Text("About"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => About(
                                  about: null,
                                )));
                  })
            ],
          ),
        ),
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ADD(id: null)));
              },
            ),
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text('About'),
                )
              ];
            })
          ],
        ),
        body: new Container(
            padding: EdgeInsets.all(20.0),
            child: FutureBuilder<List<Todo>>(
              future: getTodoFromDB(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return new Row(
                          
                          children: <Widget>[
                           
                            Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(snapshot.data[index].isdone
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank),
                                    onPressed: () {}),
                              ],
                            ),
                            Expanded(
                              
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(bottom: 9.0),
                                  child:  Text(snapshot.data[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: snapshot.data[index].isdone
                                              ? FontStyle.italic
                                              : null)),
                                ),
                                Text(snapshot.data[index].description,
                                    style: TextStyle(color: Colors.grey[500])),
                              ],
                            )),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    var dbHelper = DBHelper();
                                    dbHelper.delete(snapshot.data[index].id);
                                    setState(() {
                                      getTodoFromDB();
                                    });
                                    // showDialog(context: context,builder:(_) => new AlertDialog(
                                    //   contentPadding: const EdgeInsets.all(16.0),
                                    //   content: new Row(
                                    //     children: <Widget>[
                                    //         Expanded(child: Column(
                                    //           mainAxisAlignment: MainAxisAlignment.center,
                                    //           children: <Widget>[
                                    //            Text('dsfs')
                                    //           ],

                                    //         ))
                                    //   ],)
                                    // ));
                                  },
                                )
                              ],
                            )
                          ],
                        );
                      },
                    );
                  }
                } 
                else if(snapshot.data.length == 0)
                {
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

