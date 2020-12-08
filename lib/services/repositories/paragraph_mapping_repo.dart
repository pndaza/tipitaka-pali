import 'package:tipitaka_pali/business_logic/models/paragraph_mapping.dart';
import 'package:tipitaka_pali/services/dao/paragraph_mapping_dao.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';

abstract class ParagraphMappingRepository {
  Future<List<ParagraphMapping>> getParagraphMappings(
      String bookID, int pageNumber);
}

class ParagraphMappingDatabaseRepository implements ParagraphMappingRepository {
  final dao = ParagraphMappingDao();
  final DatabaseProvider databaseProvider;
  ParagraphMappingDatabaseRepository(this.databaseProvider);

  @override
  @override
  Future<List<ParagraphMapping>> getParagraphMappings(
      String bookID, int pageNumber) async {
    final db = await databaseProvider.database;

    List<Map> maps = await db.rawQuery('''
      SELECT ${dao.columnParagraph}, ${dao.columnExpBookID}, ${dao.columnBookName}, ${dao.columnExpPageNumber}
      FROM ${dao.tableParagraphMapping}
      INNER JOIN ${dao.tableBooks} ON ${dao.columnBookID} = 
      ${dao.columnExpBookID}
      WHERE ${dao.columnBaseBookID} = '$bookID' AND 
      ${dao.columnBasePageNumber} = $pageNumber AND 
      ${dao.columnParagraph} != 0
      ''');

    // List<Map> maps = await db.query(dao.tableParagraphMapping,
    //     columns: [dao.columnParagraph, dao.columnExpBookID, dao.columnExpPageNumber],
    //     where:
    //         '${dao.columnBaseBookID} = ? AND ${dao.columnBasePageNumber} = ? AND ${dao.columnParagraph} != ?',
    //     whereArgs: [bookID, pageNumber, 0]);

    return dao.fromList(maps);
  }
}
