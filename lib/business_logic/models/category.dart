class Category {
  String id;
  String name;

  Category(this.id, this.name);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(map['id'], map['name']);
  }
}
