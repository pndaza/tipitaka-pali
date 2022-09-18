import 'package:tipitaka_pali/business_logic/models/dictionary_book.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class DictionaryBookDao implements Dao<DictionaryBook> {
  final tableUserDict = 'dictionary_books';
  final columnBookId = 'id';
  final columnName = 'name';
  final columnOrder = 'user_order';
  final columnUserChoice = 'user_choice';

  @override
  List<DictionaryBook> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  DictionaryBook fromMap(Map<String, dynamic> query) {
    return DictionaryBook(
        bookID: query[columnBookId],
        name: query[columnName],
        order: query[columnOrder],
        userChoice: query[columnUserChoice] == 1 ? true : false);
  }

  @override
  Map<String, dynamic> toMap(DictionaryBook object) {
    return <String, dynamic>{
      columnBookId: object.bookID,
      columnName: object.name,
      columnOrder: object.order,
      columnUserChoice: object.userChoice ? 1 : 0
    };
  }
}
