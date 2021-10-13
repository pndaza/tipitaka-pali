import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:styled_text/styled_text.dart';
import 'package:tipitaka_pali/services/provider/theme_change_notifier.dart';

import '../../../../business_logic/models/search_result.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';

class SearchResultListTile extends StatelessWidget {
  final SearchResult result;
  // final String textToHighlight;
  final GestureTapCallback? onTap;

  const SearchResultListTile({Key? key, required this.result, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // print('text: ${result.description}');
    final bool isDarkMode = context.read<ThemeChangeNotifier>().isDarkMode;
    const style = TextStyle(fontSize: 18);
    final styles = {
      'hl': StyledTextTag(
          style: TextStyle(
              fontWeight: isDarkMode? null : FontWeight.bold,
              fontStyle: isDarkMode? null : FontStyle.italic,
              color: isDarkMode? Colors.white : Theme.of(context).primaryColor,
              backgroundColor: isDarkMode? Theme.of(context).primaryColor : null)),
    };

    final bookName = PaliScript.getScriptOf(
        language: context.read<ScriptLanguageProvider>().currentLanguage,
        romanText: result.book.name);
    final pageNumber = PaliScript.getScriptOf(
        language: context.read<ScriptLanguageProvider>().currentLanguage,
        romanText: result.pageNumber.toString());

    // TODO - page translation must be based on script
    // not on localization

    final bookNameAndPageNumber =
        '$bookName (${AppLocalizations.of(context)!.page} - $pageNumber)';

    final styelForBookName =
        TextStyle(fontSize: 14, color: Theme.of(context).primaryColor);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 8.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // book name and page number
                Text(
                  bookNameAndPageNumber,
                  textAlign: TextAlign.right,
                  style: styelForBookName,
                ),
                Divider(color: Theme.of(context).colorScheme.primary),
                // description text
                StyledText(
                  text: PaliScript.getScriptOf(
                      language: context
                          .read<ScriptLanguageProvider>()
                          .currentLanguage,
                      romanText: result.description,
                      isHtmlText: true),
                  style: style,
                  tags: styles,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
