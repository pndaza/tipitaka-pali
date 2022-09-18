import 'package:tipitaka_pali/business_logic/models/definition.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class DefinitionDao implements Dao<Definition> {
  final String tableDict = 'dictionary';
  final String columnWord = 'word';
  final String columnDefinition = 'definition';
  final String colunmnBookID = 'book_id';
  final String colunmnBookName = 'name';
  final String columnUserOrder = 'user_order';
/*
  final List<String> _books = [
    " ",
    "တိပိဋက ပါဠိ-မြန်မာ အဘိဓာန်",
    "ဦးဟုတ်စိန် ပါဠိ-မြန်မာအဘိဓာန်",
    "ဓာတွတ္ထပန်းကုံး",
    "ပါဠိဓာတ်အဘိဓာန်",
    "PTS Pali-English Dictionary",
    "Concise Pali-English Dictionary",
    "Pali-English Dictionary"
  ];
*/
  @override
  List<Definition> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Definition fromMap(Map<String, dynamic> query) {
    return Definition(
        word: query[columnWord],
        definition: query[columnDefinition],
        bookName: query[colunmnBookName],
        userOrder: query[columnUserOrder]);
  }

  @override
  Map<String, dynamic> toMap(Definition object) {
    throw UnimplementedError();
  }

  // String _getBookName(int id) {
  //   return _books[id];
  // }
}
