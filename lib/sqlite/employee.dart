class Employee{
  int id;
  String name;
  String description;
  Employee(this.id, this.name, this.description);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'description': description
    };
    return map;
  }

  Employee.fromMap(Map<String, dynamic>map){
    id = map['id'];
    name = map['name'];
    description = map['description'];
  }
}