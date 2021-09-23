import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
//import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/models/bookmark.dart';
import 'package:tipitaka_pali/business_logic/models/page_content.dart';
import 'package:tipitaka_pali/business_logic/models/paragraph_mapping.dart';
import 'package:tipitaka_pali/business_logic/models/recent.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';
import 'package:tipitaka_pali/services/prefs.dart';
import 'package:tipitaka_pali/services/repositories/book_repo.dart';
import 'package:tipitaka_pali/services/repositories/bookmark_repo.dart';
import 'package:tipitaka_pali/services/repositories/page_content_repo.dart';
import 'package:tipitaka_pali/services/repositories/paragraph_mapping_repo.dart';
import 'package:tipitaka_pali/services/repositories/paragraph_repo.dart';
import 'package:tipitaka_pali/services/repositories/recent_repo.dart';
import 'package:tipitaka_pali/services/storage/asset_loader.dart';
import 'package:tipitaka_pali/ui/dialogs/dictionary_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

const kdartTheme = 'default_dark_theme';
const kblackTheme = 'black';
const String kGotoID = 'goto_001';

class ReaderViewModel with ChangeNotifier {
  final BuildContext context;
  final Book book;
  int? currentPage;
  String? textToHighlight;
  // will be use this for scroll to this
  String? tocHeader;
  late List<PageContent> pages;
  late int numberOfPage;
  late int _fontSize;
  late String _cssFont;
  late String _cssData;
  late String javascriptData;
  bool loadFinished = false;
  final int preLoadPageCount = 3;
  late PreloadPageController pageController;
  late final List<WebViewController?> webViewControllers;

  late final bool _isDarkMode;

  // script features
  late final bool _isShowAlternatePali;
  late final bool _isShowPtsPageNumber;
  late final bool _isShowThaiPageNumber;
  late final bool _isShowVriPageNubmer;

  ReaderViewModel({
    required this.context,
    required this.book,
    this.currentPage,
    this.textToHighlight,
  });

  Future<bool> loadAllData() async {
    // disable embedding font
    // final fontName = 'NotoSansMyanmar-Regular.otf';
    // _cssFont = await loadCssFont(fontName: fontName);
    print('loading all data');
    _cssFont = '';
    _fontSize = Prefs.fontSize;
    _isDarkMode = Prefs.dartThemeOn;
    // load script feature and will modify css value
    _isShowAlternatePali = Prefs.isShowAlternatePali;
    _isShowPtsPageNumber = Prefs.isShowPtsNumber;
    _isShowThaiPageNumber = Prefs.isShowThaiNumber;
    _isShowVriPageNubmer = Prefs.isShowVriNumber;

    _cssData = await loadCssData();
    javascriptData = await loadJavaScript('click.js');
    pages = await loadBook(book.id);
    await _loadBookInfo(book.id);
    // book.firstPage = 1;
    // book.lastPage = pages.length;
    numberOfPage = pages.length;
    print('inititalizing controllers for pages');
    webViewControllers = List.filled(pages.length, null);
    // List<WebViewController>(pages.length);

    loadFinished = true;

    return true;
    // print('number of pages: ${pages.length}');
    // print('loading finished');
  }

// current fix for reloading data
// Todo to find why widget is rebuilding
  Future<bool> loadCached() async {
    return true;
  }

  Future<ByteData> loadFont(String fontName) async {
    return await AssetsProvider.loadFont(fontName);
  }

  Future<String> loadCssFont(
      {required String fontName,
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
    final cssFileName = _isDarkMode ? 'style_night.css' : 'style_day.css';
    String cssData = await AssetsProvider.loadCSS(cssFileName);
    // alternate pali will be displayed based on user setting
    if (_isShowAlternatePali) {
      cssData = cssData.replaceAll('display: none;', '');
    }
    return cssData;
  }

  Future<String> loadJavaScript(String fileName) async {
    return await AssetsProvider.loadCSS(fileName);
  }

  Future<List<PageContent>> loadBook(String bookID) async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final PageContentRepository pageContentRepository =
        PageContentDatabaseRepository(databaseProvider);
    return await pageContentRepository.getPages(bookID);
  }

  Future<void> _loadBookInfo(String bookID) async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final BookRepository bookRepository =
        BookDatabaseRepository(databaseProvider);
    book.firstPage = await bookRepository.getFirstPage(bookID);
    book.lastPage = await bookRepository.getLastPage(bookID);
    if (currentPage == null) {
      currentPage = book.firstPage!;
    }
  }

  Uri getPageContent(int index) {
    String pageContent = pages[index].content;
    if (textToHighlight != null) {
      pageContent = setHighlight(pageContent, textToHighlight!);
    }

    if (tocHeader != null) {
      pageContent = addIDforScroll(pageContent, tocHeader!);
    }

    // showing page number based on user settings
    var publicationKeys = <String>['P', 'T', 'V'];
    if (!_isShowPtsPageNumber) publicationKeys.remove('P');
    if (!_isShowThaiPageNumber) publicationKeys.remove('T');
    if (!_isShowVriPageNubmer) publicationKeys.remove('V');

    if (publicationKeys.isNotEmpty) {
      publicationKeys.forEach((publicationKey) {
        final publicationFormat =
            RegExp('(<a name="$publicationKey(\\d+)\\.(\\d+)">)');
        pageContent = pageContent.replaceAllMapped(publicationFormat, (match) {
          final volume = match.group(2)!;
          // remove leading zero from page number
          final pageNumber = int.parse(match.group(3)!).toString();
          return '${match.group(1)}[$publicationKey $volume.$pageNumber]';
        });
      });
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
            <p>${index + book.firstPage!}</p>
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
      // removing ti (တိ) at end
      String trimHighlight = textToHighlight.replaceAll(r'(nti|ti)$', '');
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

  String addIDforScroll(String content, String tocHeader) {
    String _tocHeader = '<span id="goto_001">' + tocHeader + "</span>";
    content = content.replaceAll(tocHeader, _tocHeader);

    return content;
  }

  String _fixSafari(String pageContent) {
    // add space bofore span content
    pageContent = pageContent.replaceAll('class="bld">', 'class="bld"> ');
    pageContent = pageContent.replaceAll('class="note">', 'class="note"> ');
    return pageContent;
  }

  Future<int> getFirstParagraph() async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final ParagraphRepository repository =
        ParagraphDatabaseRepository(databaseProvider);
    return await repository.getFirstParagraph(book.id);
  }

  Future<int> getLastParagraph() async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final ParagraphRepository repository =
        ParagraphDatabaseRepository(databaseProvider);
    return await repository.getLastParagraph(book.id);
  }

  List<int> getFakeParagraphs() {
    List<int> paragraphs = <int>[1, 2];

    return paragraphs;
  }

  Future<List<ParagraphMapping>> getParagraphs() async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final ParagraphMappingRepository repository =
        ParagraphMappingDatabaseRepository(databaseProvider);

    return await repository.getParagraphMappings(book.id, currentPage!);
  }

  Future<int> getPageNumber(int paragraphNumber) async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final ParagraphRepository repository =
        ParagraphDatabaseRepository(databaseProvider);
    return await repository.getPageNumber(book.id, paragraphNumber);
  }

  Future onPageChanged(int index) async {
    currentPage = book.firstPage! + index;
    notifyListeners();
    await _saveToRecent();
  }

  Future onSliderChanged(double value) async {
    currentPage = value.toInt();
    notifyListeners();
  }

  Future gotoPage(double value) async {
    currentPage = value.toInt();
    pageController.jumpToPage(currentPage! - book.firstPage!);
    await _saveToRecent();
  }

  Future gotoPageAndScroll(double value, String tocText) async {
    currentPage = value.toInt();
    tocHeader = tocText;
    pageController.jumpToPage(currentPage! - book.firstPage!);
    await _saveToRecent();
  }

  void increaseFontSize() {
    _fontSize += 5;
    var currentPageIndex = currentPage! - book.firstPage!;

    webViewControllers[currentPageIndex]!
        .loadUrl(getPageContent(currentPageIndex).toString());
    // notifyListeners();
    Prefs.fontSize = _fontSize;
    // update preload pages
    // for right pages
    var count = 0;
    var pageIndex = currentPageIndex;
    while (pageIndex++ < numberOfPage && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]!
          .loadUrl(getPageContent(pageIndex).toString());
    }
    // for left pages
    count = 0;
    pageIndex = currentPageIndex;
    while (pageIndex-- > 0 && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]!
          .loadUrl(getPageContent(pageIndex).toString());
    }
  }

  void decreaseFontSize() {
    _fontSize -= 5;
    var currentPageIndex = currentPage! - book.firstPage!;
    webViewControllers[currentPageIndex]!
        .loadUrl(getPageContent(currentPageIndex).toString());
    // notifyListeners();
    Prefs.fontSize = _fontSize;
    // update preload pages
    // for right pages
    var count = 0;
    var pageIndex = currentPageIndex;
    while (pageIndex++ < numberOfPage && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]!
          .loadUrl(getPageContent(pageIndex).toString());
    }
    // left pages
    count = 0;
    pageIndex = currentPageIndex;
    while (pageIndex-- > 0 && count++ < preLoadPageCount) {
      webViewControllers[pageIndex]!
          .loadUrl(getPageContent(pageIndex).toString());
    }
  }

  void saveToBookmark(String note) {
    BookmarkRepository repository =
        BookmarkDatabaseRepository(DatabaseHelper());
    repository.insert(Bookmark(book.id, currentPage!, note));
  }

  Future _saveToRecent() async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final RecentRepository recentRepository =
        RecentDatabaseRepository(databaseProvider);
    recentRepository.insertOrReplace(Recent(book.id, currentPage!));
  }

  Future<void> showDictionary(String word) async {
    // removing puntuations etc.
    word = word.replaceAll(new RegExp(r'[^a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]'), '');
    // convert ot lower case
    word = word.toLowerCase();
    await showSlidingBottomSheet(context, builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        // minHeight: 200,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.6, 0.8, 1.0],
          positioning: SnapPositioning.relativeToSheetHeight,
        ),
        headerBuilder: (context, _) {
          // building drag handle view
          return Center(
              heightFactor: 1,
              child: Container(
                width: 56,
                height: 10,
                // color: Colors.black45,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.red),
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ));
        },
        builder: (context, state) {
          final statusBarHeight = MediaQuery.of(context).padding.top;
          final screenHeight = MediaQuery.of(context).size.height;
          final marginTop = 24.0;
          return Container(
            height: screenHeight - (statusBarHeight + marginTop),
            child: DictionaryDialog(word),
          );
        },
      );
    });
  }
}
