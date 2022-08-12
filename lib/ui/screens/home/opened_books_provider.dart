import 'package:flutter/material.dart';

import '../../../business_logic/models/book.dart';

class OpenedBooksProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _openedBooks = [];
  List<Map<String, dynamic>> get openedBooks => _openedBooks;

  int _selectedBookIndex = 0;
  int get selectedBookIndex => _selectedBookIndex;

  void add({required Book book, int? currentPage, String? textToHighlight}) {
    _openedBooks.insert(0, {
      'book': book,
      'current_page': currentPage,
      'text_to_highlight': textToHighlight,
    });
    notifyListeners();
  }

  void remove({required int index}) {
    openedBooks.removeAt(index);
    notifyListeners();
  }

  void update({required int newPageNumber}) {
    var current = openedBooks[_selectedBookIndex];
    current['current_page'] = newPageNumber;
    openedBooks[_selectedBookIndex] = current;
  }

  void updateSelectedBookIndex(int index) {
    _selectedBookIndex = index;
  }
}
