import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/ui/screens/home/opened_books_provider.dart';
import 'package:tipitaka_pali/ui/screens/reader/reader.dart';

import '../../../business_logic/models/book.dart';
import '../../../services/provider/script_language_provider.dart';
import '../../../utils/pali_script.dart';

class ReaderContainer extends StatefulWidget {
  const ReaderContainer({Key? key}) : super(key: key);

  @override
  State<ReaderContainer> createState() => _ReaderContainerState();
}

class _ReaderContainerState extends State<ReaderContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openedBookProvider = context.watch<OpenedBooksProvider>();
    final books = openedBookProvider.openedBooks;

    final tabDatas = books
        .map((element) => TabData(
            text: PaliScript.getScriptOf(
                script: context.watch<ScriptLanguageProvider>().currentScript,
                romanText: (element['book'] as Book).name),
            keepAlive: true))
        .toList();

    if (books.isEmpty) {
      return Container(
        color: Colors.blueGrey[50],
        child: Center(
          child: Text(
            PaliScript.getScriptOf(
              script: context.watch<ScriptLanguageProvider>().currentScript,
              romanText: ('''
Sabbapāpassa akaraṇaṃ
Kusalassa upasampadā
Sacittapa⁠riyodāpanaṃ
Etaṃ buddhānasāsanaṃ
          '''),
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25),
          ),
        ),
      );
    }
    return TabbedView(
      controller: TabbedViewController(
        tabDatas,
      ),
      contentBuilder: (_, index) {
        final book = books.elementAt(index)['book'] as Book;
        final currentPage = books.elementAt(index)['current_page'] as int?;
        final textToHighlight =
            books.elementAt(index)['text_to_highlight'] as String?;
        return Reader(
          book: book,
          currentPage: currentPage,
          textToHighlight: textToHighlight,
        );
        // return Container(
        //     child: Center(
        //   child: Text(book.name),
        // ));
      },
      onTabClose: (index, tabData) {
        final provider = context.read<OpenedBooksProvider>();
        // final book = books.elementAt(index)['book'] as Book;
        // final currentPage = books.elementAt(index)['current_page'] as int?;
        provider.remove(index: index);
      },
      onTabSelection: (selectedIndex) {
        if (selectedIndex != null) {
          final openedBookController = context.read<OpenedBooksProvider>();
          openedBookController.updateSelectedBookIndex(selectedIndex);
        }
      },
    );
  }
}
