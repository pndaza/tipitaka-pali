import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../services/repositories/bookmark_repo.dart';
import '../models/book.dart';
import '../models/bookmark.dart';

class BookmarkPageViewModel extends ChangeNotifier {
  BookmarkPageViewModel(this.repository);
  final BookmarkRepository repository;

  List<Bookmark> _bookmarks = [];
  List<Bookmark> get bookmarks => _bookmarks;

  Future<void> fetchBookmarks() async {
    _bookmarks = await repository.getBookmarks();
    notifyListeners();
  }

  Future<void> delete(Bookmark bookmark) async {
    _bookmarks.remove(bookmark);
    notifyListeners();
    await repository.delete(bookmark);
  }

  Future<void> deleteAll() async {
    _bookmarks.clear();
    notifyListeners();
    await repository.deleteAll();
  }

  void openBook(Bookmark bookmark, BuildContext context) async {
    final book = Book(id: bookmark.bookID, name: bookmark.bookName!);
    await Navigator.pushNamed(context, readerRoute,
        arguments: {'book': book, 'currentPage': bookmark.pageNumber});
    // update bookmarks
    _bookmarks = await repository.getBookmarks();
    notifyListeners();
  }
}
