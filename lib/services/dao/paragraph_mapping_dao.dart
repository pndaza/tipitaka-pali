import 'package:tipitaka_pali/business_logic/models/paragraph_mapping.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class ParagraphMappingDao implements Dao<ParagraphMapping> {
  final String tableParagraphMapping = 'paragraph_mapping';
  final String tableBooks = 'books';
  final String columnParagraph = 'paragraph';
  final String columnBaseBookID = 'base_book_id';
  final String columnBasePageNumber = 'base_page_number';
  final String columnExpBookID = 'exp_book_id';
  final String columnExpPageNumber = 'exp_page_number';
  final String columnBookID = 'id';
  final String columnBookName = 'name';

  @override
  List<ParagraphMapping> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  ParagraphMapping fromMap(Map<String, dynamic> query) {

    return ParagraphMapping(
        paragraph: query[columnParagraph],
        baseBookID: query[columnBaseBookID],
        basePageNumber: query[columnBasePageNumber],
        expBookID: query[columnExpBookID],
        expPageNumber: query[columnExpPageNumber],
        bookName: query[columnBookName]);
  }

  @override
  Map<String, dynamic> toMap(ParagraphMapping object) {
    throw UnimplementedError();
  }
}
