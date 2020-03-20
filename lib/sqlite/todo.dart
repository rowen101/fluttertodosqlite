class Todo{
  int id;
  String title;
  String description;
  bool isdone;
  // DateTime createAt;
  Todo(this.id, this.title, this.description, this.isdone,);
    Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isdone' : isdone ? 1 : 0,
      // 'createAt' : createAt.millisecondsSinceEpoch,

    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic>map){
    id = map['id'];
    title = map['title'];
    description = map['description'];
    isdone = map['isdone'] == 1;
    // createAt = DateTime.fromMillisecondsSinceEpoch(map['creatAt']);
  }
}