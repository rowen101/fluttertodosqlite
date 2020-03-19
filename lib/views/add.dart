//import 'package:Todo/main.dart';
import 'package:Todo/sqlite/todo.dart';
import 'package:flutter/material.dart';
import 'package:Todo/sqlite/db_helper.dart';
import 'dart:async';


class ADD extends StatefulWidget {
  final  String title;
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
  bool isDone = false ;
  DateTime createdAt;
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
      todo = dbHelper.getTodoID(1) ;
    });
  }

  clearName() {
    ctitle.text = '';
    cdescription.text = '';
  }
  routerpage(){
    
  }
  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        Todo e = Todo(curUserId,title, description,isDone);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        
        });
         
      } else {
        Todo e = Todo(null, title, description, isDone);
        dbHelper.save(e);
       
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
            Text('Id '),
            TextFormField(
              controller: ctitle,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (val) => val.length == 0 ? 'Enter Title' : null,
              onSaved: (val) => title = val,
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
                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      isUpdating = false;
                    });
                    // clearName();
                      Navigator.pop(context);
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
  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar:AppBar(
        title: Text('Add Todo'),
      ),
      body:Container (
         child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[ form()],
        )
      ),
    );
    return scaffold;
  }
}
