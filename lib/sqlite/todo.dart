class Todo{
  int id;
  String title;
  String description;
  bool isdone;
  int bgcolor;
  // DateTime createAt;
  Todo(this.id, this.title, this.description, this.isdone,this.bgcolor);
    Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isdone' : isdone ? 1 : 0,
      'bgcolor' : bgcolor,
      // 'createAt' : createAt.millisecondsSinceEpoch,

    };
    return map;
  }

  Todo.fromMap(Map<String, dynamic>map){
    id = map['id'];
    title = map['title'];
    description = map['description'];
    isdone = map['isdone'] == 1;
    bgcolor = map['bgcolor'];
    // createAt = DateTime.fromMillisecondsSinceEpoch(map['creatAt']);
  }
}