class Dictionary {
  int bookID;
  String name;
  int order;
  bool userChoice;

  Dictionary(
      {required this.bookID,
      required this.name,
      required this.order,
      required this.userChoice});

Dictionary copyWith({int? bookID,String? name,int? order,bool? userChoice}){
  return Dictionary(bookID: bookID?? this.bookID, name: name?? this.name,
   order: order?? this.order, userChoice: userChoice?? this.userChoice);
}
}
