import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/repositories/recent_repo.dart';
import '../../ui/screens/home/openning_books_provider.dart';
import '../../ui/screens/reader/mobile_reader_container.dart';
import '../../utils/platform_info.dart';
import '../models/book.dart';
import '../models/recent.dart';

class RecentPageViewModel extends ChangeNotifier {
  final RecentRepository repository;
  RecentPageViewModel(this.repository);
  //
  List<Recent> _recents = [];
  List<Recent> get recents => _recents;

  Future<void> fetchRecents() async {
    _recents = await repository.getRecents();
    notifyListeners();
  }

  Future<void> delete(Recent recent) async {
    _recents.remove(recent);
    notifyListeners();
    await repository.delete(recent);
  }

  Future<void> deleteAll() async {
    _recents.clear();
    notifyListeners();
    await repository.deleteAll();
  }

  void openBook(Recent recent, BuildContext context) async {
    final book = Book(id: recent.bookID, name: recent.bookName!);
    final openningBookProvider = context.read<OpenningBooksProvider>();
    openningBookProvider.add(book: book);

    if (Mobile.isPhone(context)) {
      // Navigator.pushNamed(context, readerRoute,
      //     arguments: {'book': bookItem.book});
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const MobileReaderContrainer()));
    }

    // update recents
    _recents = await repository.getRecents();
    notifyListeners();
  }
}
