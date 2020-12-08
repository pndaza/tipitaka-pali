import 'package:tipitaka_pali/business_logic/models/bookmark.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class BookmarkDao extends Dao<Bookmark> {
  final tableBookmark = 'bookmark';
  final columnBookId = 'book_id';
  final columnPageNumber = 'page_number';
  final columnNote = 'note';
  final tableBooks = 'books';
  final columnID = 'id';
  final columnName = 'name'; // from book table

  @override
  Bookmark fromMap(Map<String, dynamic> query) {
    return Bookmark(query[columnBookId], query[columnPageNumber],
        query[columnNote], query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Bookmark object) {
    return {
      columnBookId: object.bookID,
      columnPageNumber: object.pageNumber,
      columnNote: object.note
    };
  }

  @override
  List<Bookmark> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }
}
