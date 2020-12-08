import 'package:tipitaka_pali/business_logic/models/toc.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class TocDao implements Dao<Toc> {
  final String tableName = 'tocs';
  final String columnBookID = 'book_id';
  final String columnName = 'name';
  final String columnType = 'type';
  final String columnPageNumber = 'page_number';
  @override
  List<Toc> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Toc fromMap(Map<String, dynamic> query) {
    return Toc(query[columnName], query[columnType], query[columnPageNumber]);
  }

  @override
  Map<String, dynamic> toMap(Toc object) {
    throw UnimplementedError();
  }
}
