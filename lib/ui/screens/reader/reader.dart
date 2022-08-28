import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidable_bar/slidable_bar.dart';

import '../../../app.dart';
import '../../../business_logic/models/book.dart';
import '../../../services/database/database_helper.dart';
import '../../../services/repositories/book_repo.dart';
import '../../../services/repositories/page_content_repo.dart';
import '../../../utils/platform_info.dart';
import 'controller/reader_view_controller.dart';
import 'widgets/desktop_book_view.dart';
import 'widgets/mobile_book_view.dart';
import 'widgets/reader_app_bar.dart';
import 'widgets/reader_tool_bar.dart';

class Reader extends StatelessWidget {
  final Book book;
  final int? initialPage;
  final String? textToHighlight;
  const Reader({
    Key? key,
    required this.book,
    this.initialPage,
    this.textToHighlight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    myLogger.i('calling Reader build method');
    // logger.i('pass parameter: book: ${book.id} --- ${book.name}');
    // logger.i('current Page in Reader Screen: $currentPage');
    // logger.i('textToHighlight in Reader Screen: $textToHighlight');

    return ChangeNotifierProvider<ReaderViewController>(
      create: (context) => ReaderViewController(
          context: context,
          bookRepository: BookDatabaseRepository(DatabaseHelper()),
          pageContentRepository:
              PageContentDatabaseRepository(DatabaseHelper()),
          book: book,
          initialPage: initialPage,
          textToHighlight: textToHighlight)
        ..loadDocument(),
      child: const ReaderView(),
    );
  }
}

class ReaderView extends StatelessWidget {
  const ReaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoaded = context.select<ReaderViewController, bool>(
        (controller) => controller.isloadingFinished);

    if (!isLoaded) {
      // display fade loading
      // circular progessing is somehow annoying
      return const Material(
        child: Center(
          child: Text('. . .'),
        ),
      );
    }

    //
    if (PlatformInfo.isDesktop) {
      return Scaffold(
        // appBar: ReaderAppBar(),
        body: SlidableBar(
          side: Side.bottom,
          child: const DesktopBookView(),
          barContent: const ReaderToolbar(),
          size: 100,
          clicker: Container(
            width: 32,
            height: 20,
            child: const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
          ),
          frontColor: Colors.white,
          backgroundColor: Colors.blue.withOpacity(0.3),
          clickerSize: 32,
          clickerPosition: 0.98,
        ),
        // bottomNavigationBar: SafeArea(child: ControlBar()),
      );
    }
    // default mobile
    return const Scaffold(
      appBar: ReaderAppBar(),
      body: MobileBookView(),
      bottomNavigationBar: SafeArea(child: ReaderToolbar()),
    );
  }
}
