import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/models/search_result.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class FtsRespository {
  Future<List<SearchResult>> getResults(String word);
}

class FtsDatabaseRepository implements FtsRespository {
  // final dao = IndexDao();
  final DatabaseHelper databaseHelper;

  FtsDatabaseRepository(this.databaseHelper);

  @override
  Future<List<SearchResult>> getResults(String words) async {
    final results = <SearchResult>[];
    final pharse = words.trim().replaceAll(' ', '+');
    final regexMatchWords = RegExp('<hl>$words</hl>');
    final db = await databaseHelper.database;
    // will be use fts's hightlight function to higlight words
    var maps = await db.rawQuery('''
      SELECT fts_pages.id, bookid, name, page, highlight(fts_pages, 3, "<hl>", "</hl>") content, paranum 
      FROM fts_pages INNER JOIN books ON fts_pages.bookid = books.id
      WHERE content MATCH "$pharse"
      ''');

    // debugPrint('fts maps:${maps.length}');

    for (var element in maps) {
      final id = element['id'] as int;
      final bookId = element['bookid'] as String;
      final bookName = element['name'] as String;
      final pageNumber = element['page'] as int;
      var content = element['content'] as String;
      final allMatches = regexMatchWords.allMatches(content);

      // debugPrint('finding match in page:${allMatches.length}');
      // only one match in a page
      if (allMatches.length == 1) {
        final String description = _extractDescription(
            content, allMatches.first.start, allMatches.first.end);
        final SearchResult searchResult = SearchResult(
            id: id,
            book: Book(id: bookId, name: bookName),
            pageNumber: pageNumber,
            description: description,
            );
        results.add(searchResult);
      } else {
        // multiple matches in single page
        for (var i = 0, length = allMatches.length; i < length; i++) {
          final current = allMatches.elementAt(i);
          final String description =
              _extractDescription(content, current.start, current.end);
          final SearchResult searchResult = SearchResult(
            id: id,
            book: Book(id: bookId, name: bookName),
            pageNumber: pageNumber,
            description: description,
              );
          results.add(searchResult);
        }
      }
    }

    debugPrint('total results:${results.length}');
    return results;
  }

  String _extractDescription(String content, int start, int end) {
    final word = content.substring(start, end);
    const wordCountForDescription = 8;
    final leftText = _geLeftHandSideWords(
        content.substring(0, start), wordCountForDescription);
    final rightText = _getRightHandSideWords(
        content.substring(end, content.length), wordCountForDescription);

    return '$leftText $word $rightText';
  }

  String _geLeftHandSideWords(String text, int count) {
    if (text.isEmpty) return text;
    // remove alternate pali 
    final regexAlternateText = RegExp(r'\[.+?\]');
    text = text.replaceAll(regexAlternateText, '');
    final words = <String>[];
    final wordList = text.split(' ');
    final wordCounts = wordList.length;
    for (int i = 1; i <= count; i++) {
      final index = wordCounts - i;
      if (index - i >= 0) {
        words.add(wordList[index]);
      }
    }
    return words.reversed.join(' ');
  }

  String _getRightHandSideWords(String text, int count) {
    if (text.isEmpty) return text;
    // remove alternate pali 
    final regexAlternateText = RegExp(r'\[.+?\]');
    text = text.replaceAll(regexAlternateText, '');

    final words = <String>[];
    final wordList = text.split(' ');
    final wordCounts = wordList.length;
    for (int i = 0; i < count; i++) {
      if (i < wordCounts) {
        words.add(wordList[i]);
      }
    }
    return words.join(' ');
  }
}
