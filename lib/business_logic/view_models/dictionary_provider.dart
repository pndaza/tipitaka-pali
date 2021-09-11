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

  Future<String> getDefinition(String word,
      {bool isAlreadyStem = false}) async {
    if (!isAlreadyStem) {
      word = PaliStemmer.getStem(word);
    }

    print('dict word: $word');

    final DatabaseHelper databaseProvider = DatabaseHelper();
    final DictionaryRepository dictRepository =
        DictionaryDatabaseRepository(databaseProvider);
    var definitions = await dictRepository.getDefinition(word);

    return _formatDefinitions(definitions);
  }

  String _formatDefinitions(List<Definition> definitions) {
    String htmlContent = '';
    for (Definition definition in definitions) {
      htmlContent += _addStyleToBook(definition.bookName);
      htmlContent += definition.definition;
    }
    if (definitions.isEmpty) {
      htmlContent = '<p style = "text-align:center">not found</p>';
    }
    return '''
    <html>
    <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
    <style>
    html {font-size: $_fontSize%}
    $_cssData
    </style>
    <body>
    $htmlContent
    </body>
    </html>
    ''';
  }

  String _addStyleToBook(String book) {
    return '\n<p class="book">$book</p>\n';
  }

  bool _isDarkTheme(BuildContext context) {
    return false;
    /*final themeID = ThemeProvider.themeOf(context).id;
    return (themeID == kdartTheme || themeID == kblackTheme);*/
  }
}
