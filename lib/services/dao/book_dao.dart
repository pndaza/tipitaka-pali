import 'package:tipitaka_pali/services/dao/dao.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';

class BookDao implements Dao<Book> {
  final String tableName = 'books';
  final String columnID = 'id';
  final String columnName = 'name';
  final String columnBasket = 'basket';
  final String colunmnCategory = 'category';
  final String columnFirstPage = 'firstpage';
  final String columnLastPage = 'lastpage';

  @override
  List<Book> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Book fromMap(Map<String, dynamic> query) {
    return Book(id: query[columnID], name: query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Book object) {
    throw UnimplementedError();
  }
}
