import 'package:flutter/material.dart';

import '../../business_logic/models/book.dart';
import '../../business_logic/models/search_result.dart';
import '../../data/constants.dart';
import '../../ui/screens/home/search_page/search_page.dart';
import '../database/database_helper.dart';

abstract class FtsRespository {
  Future<List<SearchResult>> getResults(
      String phrase, QueryMode queryMode, int wordDistance);
}

class FtsDatabaseRepository implements FtsRespository {
  // final dao = IndexDao();
  final DatabaseHelper databaseHelper;

  FtsDatabaseRepository(this.databaseHelper);

  @override
  Future<List<SearchResult>> getResults(
      String phrase, QueryMode queryMode, int wordDistance) async {
    final results = <SearchResult>[];
    final db = await databaseHelper.database;

    late String sql;
    if (queryMode == QueryMode.exact) {
      sql = '''
      SELECT fts_pages.id, bookid, name, page, content
      FROM fts_pages INNER JOIN books ON fts_pages.bookid = books.id
      WHERE fts_pages MATCH '"$phrase"'
      ''';
    }
    if (queryMode == QueryMode.prefix) {
      final value = '$phrase '.replaceAll(' ', '* ').trim();
      sql = '''
      SELECT fts_pages.id, bookid, name, page, content
      FROM fts_pages INNER JOIN books ON fts_pages.bookid = books.id
      WHERE fts_pages MATCH '"$value"'
      ''';
    }

    if (queryMode == QueryMode.distance) {
      final value = phrase.replaceAll(' ', ' NEAR/$wordDistance ');
      sql = '''
      SELECT fts_pages.id, bookid, name, page,
      SNIPPET(fts_pages, '<$highlightTagName>', '</$highlightTagName>', '',-15, 25) AS content
      FROM fts_pages INNER JOIN books ON fts_pages.bookid = books.id
      WHERE fts_pages MATCH "$value"
      ''';
    }

    if (queryMode == QueryMode.anywhere) {
      sql = '''
      SELECT fts_pages.id, bookid, name, page, content
      FROM fts_pages INNER JOIN books ON fts_pages.bookid = books.id
      WHERE content LIKE '%$phrase%'
      ''';
    }
    var maps = await db.rawQuery(sql);

    // debugPrint('query count:${maps.length}');

    var regexMatchWords = _createExactMatch(phrase);
    if (queryMode == QueryMode.prefix) {
      regexMatchWords = _createPrefixMatch(phrase);
    }

    for (var element in maps) {
      final id = element['id'] as int;
      final bookId = element['bookid'] as String;
      final bookName = element['name'] as String;
      final pageNumber = element['page'] as int;
      var content = element['content'] as String;
      // adding hightlight tag to query words
      if (queryMode == QueryMode.exact ||
          queryMode == QueryMode.prefix ||
          queryMode == QueryMode.anywhere) {
        content = _buildHighlight(content, phrase);
      }

      if (queryMode == QueryMode.distance) {
        final SearchResult searchResult = SearchResult(
          id: id,
          book: Book(id: bookId, name: bookName),
          pageNumber: pageNumber,
          description: content,
        );
        results.add(searchResult);
      } else if (queryMode == QueryMode.exact ||
          queryMode == QueryMode.prefix || queryMode == QueryMode.anywhere) {
        // debugPrint('finding match in page:${allMatches.length}');

        final matches = regexMatchWords.allMatches(content);
        // debugPrint('${matches.length} in $pageNumber of $bookId');
        // only one match in a page
        if (matches.length == 1) {
          final String description = _extractDescription(
              content, matches.first.start, matches.first.end);
          final SearchResult searchResult = SearchResult(
            id: id,
            book: Book(id: bookId, name: bookName),
            pageNumber: pageNumber,
            description: description,
          );
          results.add(searchResult);
        } else {
          // multiple matches in single page
          for (var i = 0, length = matches.length; i < length; i++) {
            final current = matches.elementAt(i);
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

  RegExp _createExactMatch(String phrase) {
    final patterns = <String>[];
    final words = phrase.split(' ');
    for (var word in words) {
      patterns.add('<$highlightTagName>$word</$highlightTagName>');
    }
    return RegExp(patterns.join(' '));
  }

  RegExp _createPrefixMatch(String phrase) {
    final patterns = <String>[];
    final words = phrase.split(' ');
    for (var word in words) {
      patterns.add('<$highlightTagName>$word.*?</$highlightTagName>');
    }
    return RegExp(patterns.join(' '));
  }

  String _buildHighlight(String content, String phrase) {
    final words = phrase.split(' ');
    for (var word in words) {
      content = content.replaceAllMapped(
          // ignore: unnecessary_string_escapes
          RegExp('($word\S*)'),
          (match) =>
              '<$highlightTagName>${match.group(1)}</$highlightTagName>');

      // content.replaceAll(word, '<$_highlightTag>$word</_highlightTag>');
    }
    return content;
  }
}
