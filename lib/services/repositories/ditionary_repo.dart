import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/definition.dart';
import 'package:tipitaka_pali/services/dao/dictionary_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class DictionaryRepository {
  Future<List<Definition>> getDefinition(String id);
  Future<List<String>> getSuggestions(String word);
  Future<String> getDprBreakup(String word);
  Future<String> getDprStem(String word);
}

class DictionaryDatabaseRepository implements DictionaryRepository {
  final dao = DictionaryDao();
  final DatabaseHelper databaseHelper;
  DictionaryDatabaseRepository(this.databaseHelper);

  @override
  Future<List<Definition>> getDefinition(String word) async {
    final db = await databaseHelper.database;
    final sql = '''
      SELECT word, definition, dictionary_books.name from dictionary, dictionary_books 
      WHERE word = '$word' AND dictionary.book_id = dictionary_books.id
      AND dictionary_books.user_choice = 1
      ORDER BY dictionary_books.user_order
    ''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return dao.fromList(maps);
  }

  @override
  Future<List<String>> getSuggestions(String word) async {
    final db = await databaseHelper.database;
    final sql = '''
      SELECT word from dictionary, dictionary_books 
      WHERE word LIKE '$word%' AND dictionary.book_id = dictionary_books.id
      AND dictionary_books.user_choice = 1
      ORDER BY dictionary_books.user_order
    ''';
    List<Map<String, dynamic>> maps = await db.rawQuery(sql);
    return maps.map((e) => e['word'] as String).toList();
  }

  @override
  Future<String> getDprBreakup(String word) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('dpr_breakup',
        columns: ['breakup'], where: 'word = ?', whereArgs: [word]);
    // word column is unqiue
    // so list always one entry
    if (maps.isEmpty) return '';
    return maps.first['breakup'] as String;
  }

  @override
  Future<String> getDprStem(String word) async{
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('dpr_stem',
        columns: ['stem'], where: 'word = ?', whereArgs: [word]);
    // word column is unqiue
    // so list always one entry
    if (maps.isEmpty) return '';
    return maps.first['breakup'] as String;
  }
}
