import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/view_models/reader_view_model.dart';
import 'package:tipitaka_pali/ui/screens/reader/widgets/app_bar.dart';
import 'package:tipitaka_pali/ui/screens/reader/widgets/control_bar.dart';
import 'package:tipitaka_pali/ui/screens/reader/widgets/mobile_page_view_temp.dart';

import 'widgets/desktop_page_view.dart';

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

    return ChangeNotifierProvider<ReaderViewModel>(
        create: (context) => ReaderViewModel(
            context: context,
            book: book,
            currentPage: currentPage,
            textToHighlight: textToHighlight),
        builder: (context, child) {
          final vm = Provider.of<ReaderViewModel>(context);
          return FutureBuilder<bool>(
              future: !vm.loadFinished ? vm.loadAllData() : vm.loadCached(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (Platform.isMacOS ||
                      Platform.isLinux ||
                      Platform.isWindows) {
                    return const Scaffold(
                    appBar: ReaderAppBar(),
                    body: DesktopPageView(),
                    bottomNavigationBar: SafeArea(child: ControlBar()));
                  }
                  return Scaffold(
                    appBar: ReaderAppBar(),
                    body: MobilePageViewTemp(),
                    bottomNavigationBar: SafeArea(child: ControlBar()),
                  );
                }
                return Container();
              });
        });
  }
}
