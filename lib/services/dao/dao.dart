abstract class Dao<T> {

  //abstract mapping methods
  T fromMap(Map<String, dynamic> query);

  List<T> fromList(List<Map<String,dynamic>> query);
  
  Map<String, dynamic> toMap(T object);
}