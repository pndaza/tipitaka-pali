import 'package:tipitaka_pali/business_logic/models/recent.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class RecentDao implements Dao<Recent> {
  final tableRecent = 'recent';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';
  final tableBooks = 'books';
  final columnID = 'id';
  final columnName = 'name'; // from book table

  @override
  List<Recent> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Recent fromMap(Map<String, dynamic> query) {
    return Recent(
        query[columnBookId], query[columnPageNumber], query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Recent object) {
    return <String, dynamic>{
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber
    };
  }
}
