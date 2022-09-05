import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/repositories/bookmark_repo.dart';
import '../../ui/screens/home/openning_books_provider.dart';
import '../../ui/screens/reader/mobile_reader_container.dart';
import '../../utils/platform_info.dart';
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
    final openningBookProvider = context.read<OpenningBooksProvider>();
    openningBookProvider.add(book: book);

    if (Mobile.isPhone(context)) {
      // Navigator.pushNamed(context, readerRoute,
      //     arguments: {'book': bookItem.book});
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const MobileReaderContrainer()));
    }
    // update bookmarks
    _bookmarks = await repository.getBookmarks();
    notifyListeners();
  }
}
