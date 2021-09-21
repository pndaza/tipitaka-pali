class Definition {
  String? word;
  String definition;
  String bookName;

  Definition({this.word,required this.definition,required this.bookName});

  @override
  String toString() {
    // TODO: implement toString
    return definition;
  }
}
