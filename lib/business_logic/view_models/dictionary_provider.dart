import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/definition.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';
import 'package:tipitaka_pali/services/prefs.dart';
import 'package:tipitaka_pali/services/repositories/ditionary_repo.dart';
import 'package:tipitaka_pali/services/storage/asset_loader.dart';
import 'package:tipitaka_pali/utils/pali_stemmer.dart';

const kdartTheme = 'default_dark_theme';
const kblackTheme = 'black';

class DictionaryProvider {
  final BuildContext context;
  String? _cssData;
  int? _fontSize;

  DictionaryProvider(this.context) {
    init(context);
  }

  void init(BuildContext context) async {
    final cssFileName =
        _isDarkTheme(context) ? 'dict_night.css' : 'dict_day.css';
    _cssData = await AssetsProvider.loadCSS(cssFileName);
    _fontSize = Prefs.fontSize;
  }

  Future<List<Definition>> getDefinition(String word,
      {bool isAlreadyStem = false}) async {
    late String stemWord;
    if (!isAlreadyStem) {
      stemWord = PaliStemmer.getStem(word);
    }

    final DatabaseHelper databaseProvider = DatabaseHelper();
    final DictionaryRepository dictRepository =
        DictionaryDatabaseRepository(databaseProvider);

    // lookup using estimated stem word
    // print('dict word: $stemWord');
    final definitions = await dictRepository.getDefinition(word);
    return definitions;

    // return _formatDefinitions(definitions);
  }

  Future<String> getBreakup(String word) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('dpr_breakup',
        columns: ['breakup'], where: 'word = ?', whereArgs: [word]);
    // word column is unqiue
    // so list always one entry
    if (maps.isEmpty) return '';
    final breakup = maps.first['breakup'] as String;
    return breakup;
  }

  bool _isDarkTheme(BuildContext context) {
    return false;
    /*final themeID = ThemeProvider.themeOf(context).id;
    return (themeID == kdartTheme || themeID == kblackTheme);*/
  }
}
