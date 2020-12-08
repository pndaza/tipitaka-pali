import 'book.dart';

class SearchResult {
  final String textToHighlight;
  final String description;
  final Book book;
  final int pageNumber;

  SearchResult(
      {this.textToHighlight,
      this.description,
      this.book,
      this.pageNumber});
}
