import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabbed_view/tabbed_view.dart';

import '../../../business_logic/models/book.dart';
import '../../../services/provider/script_language_provider.dart';
import '../../../services/provider/theme_change_notifier.dart';
import '../../../utils/pali_script.dart';
import '../home/openning_books_provider.dart';
import 'reader.dart';

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
    final openedBookProvider = context.watch<OpenningBooksProvider>();
    final books = openedBookProvider.books;

    final tabDatas = books
        .map((element) => TabData(
            text: PaliScript.getScriptOf(
                script: context.watch<ScriptLanguageProvider>().currentScript,
                romanText: (element['book'] as Book).name),
            keepAlive: false))
        .toList();

    if (books.isEmpty) {
      return Container(
        color: const Color(0xfffbf0da),
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

    // cannot watch two notifiers simultaneity in a single widget
    // so warp in consumer for watching theme change
    return Consumer<ThemeChangeNotifier>(
      builder: ((context, themeChangeNotifier, child) {
        // tabbed view uses custom theme and provide TabbedViewTheme.
        // need to watch theme change and rebuild TabbedViewTheme with new one

        return TabbedViewTheme(
          data: themeChangeNotifier.isDarkMode
              ? TabbedViewThemeData.dark()
              : TabbedViewThemeData.mobile(
                  accentColor: Theme.of(context).appBarTheme.backgroundColor ??
                      Colors.blue,
                ),
          // data: TabbedViewThemeData.minimalist(),
          child: TabbedView(
            controller: TabbedViewController(tabDatas),
            contentBuilder: (_, index) {
              final book = books.elementAt(index)['book'] as Book;
              final currentPage =
                  books.elementAt(index)['current_page'] as int?;
              final textToHighlight =
                  books.elementAt(index)['text_to_highlight'] as String?;
              return Reader(
                book: book,
                initialPage: currentPage,
                textToHighlight: textToHighlight,
              );
            },
            onTabClose: (index, tabData) =>
                context.read<OpenningBooksProvider>().remove(index: index),
            onTabSelection: (selectedIndex) {
              if (selectedIndex != null) {
                context
                    .read<OpenningBooksProvider>()
                    .updateSelectedBookIndex(selectedIndex);
              }
            },
          ),
        );
      }),
    );
  }
}
