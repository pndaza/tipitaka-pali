import 'package:flutter/services.dart';
import 'package:path/path.dart';

class AssetsProvider {
  static const String _assetsPath = 'assets';
  // static final String _bookFolderPath = 'books';
  static const String _fontFolderPath = 'fonts';
  static const String _cssFolderPath = 'web';
  static const String _jsFolderPath = 'web';

  // static Future<String> loadBook(String bookID) async {
  //   final path = join(_assetsPath, _bookFolderPath, '$bookID.html');
  //   return await rootBundle.loadString(path);
  // }

  static Future<ByteData> loadFont(String fontName) async {
    final path = join(_assetsPath, _fontFolderPath, fontName);
    return await rootBundle.load(path);
  }

  static Future<String> loadCSS(String cssFileName) async {
    // proper way is below but does not work for MS Windos
    //  final path = join(_assetsPath, _cssFolderPath, cssFileName);
    // fix is here below
    final path = '$_assetsPath/$_cssFolderPath/$cssFileName';
    return await rootBundle.loadString(path);
  }

  static Future<String> loadJS(String jsFileName) async {
    final path = join(_assetsPath, _jsFolderPath, jsFileName);
    return await rootBundle.loadString(path);
  }
}
