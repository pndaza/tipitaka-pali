import 'package:tipitaka_pali/business_logic/models/definition.dart';
import 'package:tipitaka_pali/services/dao/dictionary_dao.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';

abstract class DictionaryRepository {
  Future<List<Definition>> getDefinition(String id);
}

class DictionaryDatabaseRepository implements DictionaryRepository {
  final dao = DictionaryDao();
  final DatabaseProvider databaseProvider;
  DictionaryDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Definition>> getDefinition(String word) async {
    final db = await databaseProvider.database;
    final sql = '''
      SELECT word, definition, dictionary_books.name from dictionary, dictionary_books 
      WHERE word = '$word' AND dictionary.book_id = dictionary_books.id
      AND dictionary_books.user_choice = 1
      ORDER BY dictionary_books.user_order
    ''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return dao.fromList(maps);
  }
}
