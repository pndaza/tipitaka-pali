class PageContent {
  int? id;
  String? bookID;
  int? pageNumber;
  String content;
  String? paragraphNumber;
  PageContent(
      {this.id,
      this.bookID,
      this.pageNumber,
      required this.content,
      this.paragraphNumber});
}
