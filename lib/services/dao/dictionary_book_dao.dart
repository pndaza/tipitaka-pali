import 'package:tipitaka_pali/business_logic/models/dictionary.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class DictionaryBookDao implements Dao<Dictionary> {
  final tableUserDict = 'dictionary_books';
  final columnBookId = 'id';
  final columnName = 'name';
  final columnOrder = 'user_order';
  final columnUserChoice = 'user_choice';

  @override
  List<Dictionary> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Dictionary fromMap(Map<String, dynamic> query) {
    return Dictionary(
        bookID: query[columnBookId],
        name: query[columnName],
        order: query[columnOrder],
        userChoice: query[columnUserChoice] == 1 ? true : false);
  }

  @override
  Map<String, dynamic> toMap(Dictionary object) {
    return <String, dynamic>{
      columnBookId: object.bookID,
      columnName: object.name,
      columnOrder: object.order,
      columnUserChoice: object.userChoice ? 1 : 0
    };
  }
}
