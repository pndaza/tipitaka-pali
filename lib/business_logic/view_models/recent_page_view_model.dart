import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../services/repositories/recent_repo.dart';
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
    await Navigator.pushNamed(context, readerRoute, arguments: {
      'book': book,
      'currentPage': recent.pageNumber,
    });
    // update recents
    _recents = await repository.getRecents();
    notifyListeners();
  }
}
