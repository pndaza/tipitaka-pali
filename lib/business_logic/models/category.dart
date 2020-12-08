class Category {
  String id;
  String name;

  Category(this.id, this.name);
  
  Map<String, dynamic> toMap(){
        return {
      'id': id,
      'name': name,
    };
  }
  Category.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.name = map['name'];
  }
}
