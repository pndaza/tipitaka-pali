import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slidable_bar/slidable_bar.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/ui/screens/reader/controller/reader_view_controller.dart';
import 'package:tipitaka_pali/ui/screens/reader/widgets/reader_app_bar.dart';
import 'package:tipitaka_pali/ui/screens/reader/widgets/reader_tool_bar.dart';
import 'package:tipitaka_pali/ui/screens/reader/widgets/mobile_book_view.dart';
import 'package:tipitaka_pali/utils/platform_info.dart';

import 'widgets/desktop_book_view.dart';

class Reader extends StatelessWidget {
  final Book book;
  int? currentPage;
  String? textToHighlight;
  Reader({Key? key, required this.book, this.currentPage, this.textToHighlight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    myLogger.i('calling Reader build method');
    // logger.i('pass parameter: book: ${book.id} --- ${book.name}');
    // logger.i('current Page in Reader Screen: $currentPage');
    // logger.i('textToHighlight in Reader Screen: $textToHighlight');

    return ChangeNotifierProvider<ReaderViewController>(
        create: (context) => ReaderViewController(
            context: context,
            book: book,
            currentPage: currentPage,
            textToHighlight: textToHighlight),
        builder: (context, child) {
          final vm = Provider.of<ReaderViewController>(context);
          return FutureBuilder<bool>(
              future: !vm.loadFinished ? vm.loadAllData() : vm.loadCached(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
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
                  return const Scaffold(
                    appBar: ReaderAppBar(),
                    body: MobileBookView(),
                    bottomNavigationBar: SafeArea(child: ReaderToolbar()),
                  );
                }
                return Container();
              });
        });
  }
}
