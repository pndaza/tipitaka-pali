import 'package:tipitaka_pali/business_logic/models/page_content.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class PageContentDao implements Dao<PageContent> {
  final String tableName = 'pages';
  final String columnID = 'id';
  final String columnBookID = 'bookid';
  final String columnPage = 'page';
  final String columnContent = 'content';

  @override
  List<PageContent> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  PageContent fromMap(Map<String, dynamic> query) {
    return PageContent(
        id: query[columnID],
        bookID: query[columnBookID],
        pageNumber: query[columnPage],
        content: query[columnContent]);
  }

  @override
  Map<String, dynamic> toMap(PageContent object) {
    throw UnimplementedError();
  }
}
