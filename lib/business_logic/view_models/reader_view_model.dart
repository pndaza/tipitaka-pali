import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/models/bookmark.dart';
import 'package:tipitaka_pali/business_logic/models/page_content.dart';
import 'package:tipitaka_pali/business_logic/models/paragraph_mapping.dart';
import 'package:tipitaka_pali/business_logic/models/recent.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';
import 'package:tipitaka_pali/services/repositories/book_repo.dart';
import 'package:tipitaka_pali/services/repositories/bookmark_repo.dart';
import 'package:tipitaka_pali/services/repositories/page_content_repo.dart';
import 'package:tipitaka_pali/services/repositories/paragraph_mapping_repo.dart';
import 'package:tipitaka_pali/services/repositories/paragraph_repo.dart';
import 'package:tipitaka_pali/services/repositories/recent_repo.dart';
import 'package:tipitaka_pali/services/storage/asset_loader.dart';
import 'package:tipitaka_pali/ui/dialogs/dictionary_dialog.dart';
import 'package:tipitaka_pali/utils/mm_number.dart';
import 'package:tipitaka_pali/utils/shared_preferences_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

const kdartTheme = 'default_dark_theme';
const kblackTheme = 'black';
const String kGotoID = 'goto_001';

class ReaderViewModel with ChangeNotifier {
  final Book book;
  final String textToHighlight;
  int currentPage;
  List<PageContent> pages;
  int numberOfPage;
  int _fontSize;
  String _cssFont;
  String _cssData;
  String javascriptData;
  bool loadFinished = false;
  final int preLoadPageCount = 3;
  PreloadPageController pageController;
  List<WebViewController> webViewControllers;
  final BuildContext context;

  ReaderViewModel({
    this.context,
    this.book,
    this.currentPage,
    this.textToHighlight,
  });

  Future<bool> loadAllData() async {
    // print('loading all required data');
    final fontName = 'NotoSansMyanmar-Regular.otf';
    _cssFont = await loadCssFont(fontName: fontName);
    _fontSize = await loadFontSize();
    _cssData = await loadCssData();
    javascriptData = await loadJavaScript('click.js');
    pages = await loadBook(book.id);
    await _loadBookInfo(book.id);
    // book.firstPage = 1;
    // book.lastPage = pages.length;
    numberOfPage = pages.length;
    webViewControllers = List<WebViewController>(pages.length);

    return true;
    // print('number of pages: ${pages.length}');
    // print('loading finished');
  }

  Future<ByteData> loadFont(String fontName) async {
    return await AssetsProvider.loadFont(fontName);
  }

  Future<String> loadCssFont(
      {@required String fontName,
      String fontExt = 'otf',
      String fontMineType = 'font/truetype'}) async {
    final fontData = await loadFont(fontName);
    final buffer = fontData.buffer;
    final fontUri = Uri.dataFromBytes(
            buffer.asUint8List(fontData.offsetInBytes, fontData.lengthInBytes),
            mimeType: fontMineType)
        .toString();
    return '@font-face { font-family: NotoSansMyanmar; src: url($fontUri); }';
  }

  Future<String> loadCssData() async {
    final cssFileName = _isDarkTheme() ? 'style_night.css' : 'style_day.css';

    return await AssetsProvider.loadCSS(cssFileName);
  }

  Future<String> loadJavaScript(String fileName) async {
    return await AssetsProvider.loadCSS(fileName);
  }

  Future<List<PageContent>> loadBook(String bookID) async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final PageContentRepository pageContentRepository =
        PageContentDatabaseRepository(databaseProvider);
    return await pageContentRepository.getPages(bookID);
  }

  Future<void> _loadBookInfo(String bookID) async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final BookRepository bookRepository =
        BookDatabaseRepository(databaseProvider);
    book.firstPage = await bookRepository.getFirstPage(bookID);
    book.lastPage = await bookRepository.getLastPage(bookID);
    if (currentPage == null) {
      currentPage = book.firstPage;
    }
  }

  Uri getPageContent(int index) {
    String pageContent = pages[index].content;
    if (textToHighlight != null) {
      pageContent = setHighlight(pageContent, textToHighlight);
    }

    pageContent = _fixSafari(pageContent);
    return Uri.dataFromString('''
    <!DOCTYPE html>
          <html>
          <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
          </head>
          <style>
            html {font-size: $_fontSize%}
            $_cssFont
            $_cssData
          </style>
          <body>
            <p>${MmNumber.get(index + book.firstPage)}</p>
            <div id="page_content">
              $pageContent
            </div>
          </body>
          </html>
    ''', mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
  }

  String setHighlight(String content, String textToHighlight) {
    // TODO optimize highlight for some query text
    String highlightedText =
        '<span class = "highlighted">' + textToHighlight + "</span>";
    if (!content.contains(textToHighlight)) {
      // Log.d("if not found highlight", "yes");
      // removing တိ at end
      String trimHighlight = textToHighlight.replaceAll(r'(န္တိ|တိ)$', '');
      highlightedText =
          '<span class = "highlighted">' + trimHighlight + "</span>";

      content = content.replaceAll(trimHighlight, highlightedText);
      content = content.replaceFirst('<span class = "highlighted">',
          '<span id="goto_001" class="highlighted">');

      return content;
    }
    content = content.replaceAll(textToHighlight, highlightedText);
    content = content.replaceFirst('<span class = "highlighted">',
        '<span id="goto_001" class="highlighted">');
    return content;
  }

  String _fixSafari(String pageContent) {
    // add space bofore span content
    pageContent = pageContent.replaceAll('class="bld">', 'class="bld"> ');
    pageContent = pageContent.replaceAll('class="note">', 'class="note"> ');
    return pageContent;
  }

  Future<int> getFirstParagraph() async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final ParagraphRepository repository =
        ParagraphDatabaseRepository(databaseProvider);
    return await repository.getFirstParagraph(book.id);
  }

  Future<int> getLastParagraph() async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final ParagraphRepository repository =
        ParagraphDatabaseRepository(databaseProvider);
    return await repository.getLastParagraph(book.id);
  }

  List<int> getFakeParagraphs() {
    List<int> paragraphs = <int>[1, 2];

    return paragraphs;
  }

  Future<List<ParagraphMapping>> getParagraphs() async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final ParagraphMappingRepository repository =
        ParagraphMappingDatabaseRepository(databaseProvider);

    return await repository.getParagraphMappings(book.id, currentPage);
  }

  Future<int> getPageNumber(int paragraphNumber) async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final ParagraphRepository repository =
        ParagraphDatabaseRepository(databaseProvider);
    return await repository.getPageNumber(book.id, paragraphNumber);
  }

  Future onPageChanged(int index) async {
    currentPage = book.firstPage + index + 1;
    notifyListeners();
    await _saveToRecent();
  }

  Future onSliderChanged(double value) async {
    currentPage = value.toInt();
    notifyListeners();
  }

  Future gotoPage(double value) async {
    currentPage = value.toInt();
    pageController.jumpToPage(currentPage - book.firstPage);
    await _saveToRecent();
  }

  Future<int> loadFontSize() async {
    return await SharedPrefProvider.getInt(key: k_key_fontSize);
  }

  void increaseFontSize() {
    _fontSize += 5;
    var currentPageIndex = currentPage - book.firstPage;
    webViewControllers[currentPageIndex]
        .loadUrl(getPageContent(currentPageIndex).toString());
    // notifyListeners();
    SharedPrefProvider.setInt(key: k_key_fontSize, value: _fontSize);
    // update preload pages
    // for right pages
    var count = 0;
    var pageIndex = currentPageIndex;
    while (pageIndex++ < numberOfPage && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]
          .loadUrl(getPageContent(pageIndex).toString());
    }
    // for left pages
    count = 0;
    pageIndex = currentPageIndex;
    while (pageIndex-- > 0 && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]
          .loadUrl(getPageContent(pageIndex).toString());
    }
  }

  void decreaseFontSize() {
    _fontSize -= 5;
    var currentPageIndex = currentPage - book.firstPage;
    webViewControllers[currentPageIndex]
        .loadUrl(getPageContent(currentPageIndex).toString());
    // notifyListeners();
    SharedPrefProvider.setInt(key: k_key_fontSize, value: _fontSize);
    // update preload pages
    // for right pages
    var count = 0;
    var pageIndex = currentPageIndex;
    while (pageIndex++ < numberOfPage && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]
          .loadUrl(getPageContent(pageIndex).toString());
    }
    // left pages
    count = 0;
    pageIndex = currentPageIndex;
    while (pageIndex-- > 0 && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]
          .loadUrl(getPageContent(pageIndex).toString());
    }
  }

  bool _isDarkTheme() {
    final themeID = ThemeProvider.themeOf(context).id;
    return (themeID == kdartTheme || themeID == kblackTheme);
  }

  void saveToBookmark(String note) {
    BookmarkRepository repository =
        BookmarkDatabaseRepository(DatabaseProvider());
    repository.insert(Bookmark(book.id, currentPage, note));
  }

  Future _saveToRecent() async {
    final DatabaseProvider databaseProvider = DatabaseProvider();
    final RecentRepository recentRepository =
        RecentDatabaseRepository(databaseProvider);
    recentRepository.insertOrReplace(Recent(book.id, currentPage));
  }

  Future<void> showDictionary(String word) async {
    showCupertinoModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        expand: false,
        context: context,
        builder: (context, _) {
          return ThemeConsumer(child: DictionaryDialog(word));
        });
  }
}
