import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/app.dart';

import '../../../../business_logic/models/book.dart';
import '../../../../business_logic/models/bookmark.dart';
import '../../../../business_logic/models/page_content.dart';
import '../../../../business_logic/models/paragraph_mapping.dart';
import '../../../../business_logic/models/recent.dart';
import '../../../../services/dao/bookmark_dao.dart';
import '../../../../services/dao/recent_dao.dart';
import '../../../../services/database/database_helper.dart';
import '../../../../services/repositories/book_repo.dart';
import '../../../../services/repositories/bookmark_repo.dart';
import '../../../../services/repositories/page_content_repo.dart';
import '../../../../services/repositories/paragraph_mapping_repo.dart';
import '../../../../services/repositories/paragraph_repo.dart';
import '../../../../services/repositories/recent_repo.dart';
import '../../home/opened_books_provider.dart';

class ReaderViewController with ChangeNotifier {
  final BuildContext context;
  final PageContentRepository pageContentRepository;
  final BookRepository bookRepository;
  final Book book;
  int? initialPage;
  String? textToHighlight;

  bool isloadingFinished = false;
  late ValueNotifier<int> _currentPage;
  ValueListenable<int> get currentPage => _currentPage;
  // will be use this for scroll to this
  String? tocHeader;
  late List<PageContent> pages;
  late int numberOfPage;

  // // script features
  // late final bool _isShowAlternatePali;

  ReaderViewController({
    required this.context,
    required this.pageContentRepository,
    required this.bookRepository,
    required this.book,
    this.initialPage,
    this.textToHighlight,
  });

  Future<void> loadDocument() async {
    pages = List.unmodifiable(await _loadPages(book.id));
    numberOfPage = pages.length;
    await _loadBookInfo(book.id);
    isloadingFinished = true;
    notifyListeners();
    // save to recent table on load of the book.
    // from general book opening and also tapping a search result tile..
    await _saveToRecent();
  }

  Future<List<PageContent>> _loadPages(String bookID) async {
    return await pageContentRepository.getPages(bookID);
  }

  Future<void> _loadBookInfo(String bookID) async {
    book.firstPage = await bookRepository.getFirstPage(bookID);
    book.lastPage = await bookRepository.getLastPage(bookID);
    _currentPage = ValueNotifier(initialPage ?? book.firstPage!);
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

  Future<List<ParagraphMapping>> getParagraphs() async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final ParagraphMappingRepository repository =
        ParagraphMappingDatabaseRepository(databaseProvider);

    return await repository.getParagraphMappings(book.id, _currentPage.value);
  }

  Future<int> getPageNumber(int paragraphNumber) async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final ParagraphRepository repository =
        ParagraphDatabaseRepository(databaseProvider);
    return await repository.getPageNumber(book.id, paragraphNumber);
  }

  Future<void> onGoto({required int pageNumber, String? word}) async {
    myLogger.i('current page number: $pageNumber');
    // update current page
    _currentPage.value = pageNumber;
    // update opened book list
    final openedBookController = context.read<OpenedBooksProvider>();
    openedBookController.update(newPageNumber: _currentPage.value);
    // persit
    await _saveToRecent();
  }

  // Future onPageChanged(int index) async {
  //   _currentPage.value = book.firstPage! + index;
  //   // notifyListeners();

  //   final openedBookController = context.read<OpenedBooksProvider>();
  //   openedBookController.update(newPageNumber: _currentPage.value);
  //   await _saveToRecent();
  // }

  // Future gotoPage(double value) async {
  //   _currentPage.value = value.toInt();
  //   final index = _currentPage.value - book.firstPage!;
  //   // pageController?.jumpToPage(index);
  //   // itemScrollController?.jumpTo(index: index);

  //   final openedBookController = context.read<OpenedBooksProvider>();
  //   openedBookController.update(newPageNumber: _currentPage.value);

  //   //await _saveToRecent();
  // }

  // Future gotoPageAndScroll(double value, String tocText) async {
  //   _currentPage = value.toInt();
  //   tocHeader = tocText;
  //   final index = _currentPage! - book.firstPage!;
  //   // pageController?.jumpToPage(index);
  //   // itemScrollController?.jumpTo(index: _currentPage! - book.firstPage!);
  //   //await _saveToRecent();
  // }

  void saveToBookmark(String note) {
    BookmarkRepository repository =
        BookmarkDatabaseRepository(DatabaseHelper(), BookmarkDao());
    repository.insert(Bookmark(book.id, _currentPage.value, note));
  }

  Future _saveToRecent() async {
    final RecentRepository recentRepository =
        RecentDatabaseRepository(DatabaseHelper(), RecentDao());
    recentRepository.insertOrReplace(Recent(book.id, _currentPage.value));
  }
}
