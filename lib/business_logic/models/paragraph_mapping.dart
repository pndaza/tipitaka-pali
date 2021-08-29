class ParagraphMapping {
  int paragraph;
  String? baseBookID;
  int? basePageNumber;
  String expBookID;
  int expPageNumber;
  String bookName;
  ParagraphMapping(
      {required this.paragraph,
      this.baseBookID,
      this.basePageNumber,
      required this.expBookID,
      required this.expPageNumber,
      required this.bookName});
}
