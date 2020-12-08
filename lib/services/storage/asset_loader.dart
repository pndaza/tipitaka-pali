import 'package:flutter/services.dart';
import 'package:path/path.dart';

class AssetsProvider {
  static final String _assetsPath = 'assets';
  // static final String _bookFolderPath = 'books';
  static final String _fontFolderPath = 'fonts';
  static final String _cssFolderPath = 'web';
  static final String _jsFolderPath = 'web';

  // static Future<String> loadBook(String bookID) async {
  //   final path = join(_assetsPath, _bookFolderPath, '$bookID.html');
  //   return await rootBundle.loadString(path);
  // }

  static Future<ByteData> loadFont(String fontName) async {
    final path = join(_assetsPath, _fontFolderPath, '$fontName');
    return await rootBundle.load(path);
  }

  static Future<String> loadCSS(String cssFileName) async {
    final path = join(_assetsPath, _cssFolderPath, '$cssFileName');
    return await rootBundle.loadString(path);
  }

    static Future<String> loadJS(String jsFileName) async {
    final path = join(_assetsPath, _jsFolderPath, '$jsFileName');
    return await rootBundle.loadString(path);
  }
}
