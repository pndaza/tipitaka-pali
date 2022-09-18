class DictionaryBook {
  int bookID;
  String name;
  int order;
  bool userChoice;

  DictionaryBook(
      {required this.bookID,
      required this.name,
      required this.order,
      required this.userChoice});

  DictionaryBook copyWith(
      {int? bookID, String? name, int? order, bool? userChoice}) {
    return DictionaryBook(
        bookID: bookID ?? this.bookID,
        name: name ?? this.name,
        order: order ?? this.order,
        userChoice: userChoice ?? this.userChoice);
  }
}
