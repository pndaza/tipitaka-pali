import 'package:flutter/material.dart';

import '../../../business_logic/models/book.dart';

class OpenningBooksProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _books = [];
  List<Map<String, dynamic>> get books => _books;

  int _selectedBookIndex = 0;
  int get selectedBookIndex => _selectedBookIndex;

  void add({required Book book, int? currentPage, String? textToHighlight}) {
    _books.insert(0, {
      'book': book,
      'current_page': currentPage,
      'text_to_highlight': textToHighlight,
    });
    notifyListeners();
  }

  void remove({required int index}) {
    books.removeAt(index);
    if (books.isEmpty) {
      _selectedBookIndex = 0;
    }
    notifyListeners();
  }

  void removeAll() {
    books.clear();
    _selectedBookIndex = 0;
    notifyListeners();
  }

  void update({required int newPageNumber}) {
    var current = books[_selectedBookIndex];
    current['current_page'] = newPageNumber;
    books[_selectedBookIndex] = current;
  }

  void updateSelectedBookIndex(int index) {
    _selectedBookIndex = index;
    notifyListeners();
  }
}
