import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/models/recent.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';
import 'package:tipitaka_pali/services/repositories/recent_repo.dart';

import '../../routes.dart';

class RecentPageViewModel extends ChangeNotifier {
  List<Recent> recents = [];
  RecentRepository _repository = RecentDatabaseRepository(DatabaseProvider());

  Future<void> fetchRecents() async {
    recents = await _repository.getRecents();
    notifyListeners();
  }

  Future<void> delete(int index) async {
    final Recent recent = recents[index];
    recents.removeAt(index);
    notifyListeners();
    await _repository.delete(recent);
  }

  Future<void> deleteAll() async {
    recents.clear();
    notifyListeners();
    await _repository.deleteAll();
  }

  void openBook(Recent recent, BuildContext context) {
    final book = Book(id: recent.bookID, name: recent.bookName!);
    Navigator.pushNamed(context, ReaderRoute, arguments: {
      'book': book,
      'currentPage': recent.pageNumber,
    });
  }
}
