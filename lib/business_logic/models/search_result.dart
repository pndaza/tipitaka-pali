import 'book.dart';

class SearchResult {
  final String textToHighlight;
  final String description;
  final Book book;
  final int pageNumber;

  SearchResult(
      {required this.textToHighlight,
      required this.description,
      required this.book,
      required this.pageNumber});
}
