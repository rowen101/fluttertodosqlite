import 'package:basicapp/sqlite/employee.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:basicapp/sqlite/db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
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
  //
  Future<List<Employee>> employees;
  TextEditingController controller = TextEditingController();
  TextEditingController cdescription = TextEditingController();
  String name;
  String description;
  int curUserId;

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
      employees = dbHelper.getEmployees();
    });
  }

  clearName() {
    controller.text = '';
    cdescription.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Employee e = Employee(curUserId, name, description);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Employee e = Employee(null, name, description);
        dbHelper.save(e);
      }
      clearName();
      refreshList();
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
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (val) => val.length == 0 ? 'Enter Title' : null,
              onSaved: (val) => name = val,
            ),
            TextFormField(
              controller: cdescription,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Description'),
              validator: (val) => val.length == 0 ? 'Enter Description' : null,
              onSaved: (val) => description = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  },
                  child: Text('CANCEL'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
 
  SingleChildScrollView dataTable(List<Employee> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(label: Text('TITLE')),
          DataColumn(label: Text('DESCRIPTON')),
          DataColumn(label: Text('DELETE'))
        ],
        rows: employees
            .map(
              (employees) => DataRow(cells: [
                DataCell(Text(employees.name), onTap: () {
                  setState(() {
                    isUpdating = true;
                    curUserId = employees.id;
                  });
                  controller.text = employees.name;
                  cdescription.text = employees.description;
                }),
                DataCell(Text(employees.description), onTap: (){
                  setState(() {
                    isUpdating = true;
                    curUserId = employees.id;
                  });
                   controller.text = employees.name;
                  cdescription.text = employees.description;
                }),
                DataCell(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    dbHelper.delete(employees.id);
                    refreshList();
                  },
                ))
              ]),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: employees,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[form(), list()],
        ),
      ),
    );
  }
}
