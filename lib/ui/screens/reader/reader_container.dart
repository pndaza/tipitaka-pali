import 'package:flutter/material.dart';
import 'package:tabbed_view/tabbed_view.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/services/provider/theme_change_notifier.dart';
import 'package:tipitaka_pali/ui/screens/home/opened_books_provider.dart';
import 'package:tipitaka_pali/ui/screens/reader/reader.dart';

import '../../../app.dart';
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
    // TODO: There are two states, empty state and data state
    // only rebuild when states are not equal.
    // when previous and new state is same,
    // add new books to tabbed view by TabbedViewController
    final openedBookProvider = context.watch<OpenedBooksProvider>();

    // tabbed view uses custom theme and provide TabbedViewTheme.
    // need to watch theme change and rebuild TabbedViewTheme with new one

    final isDarkMode = context
        .select<ThemeChangeNotifier, bool>((notifier) => notifier.isDarkMode);
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
        color: const Color.fromARGB(200, 254, 229, 171),
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
            style: const TextStyle(
              fontSize: 22,
              color: Colors.brown,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return TabbedViewTheme(
      data: isDarkMode
          ? TabbedViewThemeData.dark()
          : TabbedViewThemeData.classic(),
      child: TabbedView(
        controller: TabbedViewController(tabDatas),
        contentBuilder: (_, index) {
          final book = books.elementAt(index)['book'] as Book;
          final currentPage = books.elementAt(index)['current_page'] as int?;
          final textToHighlight =
              books.elementAt(index)['text_to_highlight'] as String?;
          return Reader(
            book: book,
            initialPage: currentPage,
            textToHighlight: textToHighlight,
          );
        },
        onTabClose: (index, tabData) =>
            context.read<OpenedBooksProvider>().remove(index: index),
        onTabSelection: (selectedIndex) {
          if (selectedIndex != null) {
            context
                .read<OpenedBooksProvider>()
                .updateSelectedBookIndex(selectedIndex);
          }
        },
      ),
    );
  }
}
