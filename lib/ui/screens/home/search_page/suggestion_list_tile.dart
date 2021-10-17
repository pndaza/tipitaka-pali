import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';

class SuggestionListTile extends StatelessWidget {
  const SuggestionListTile({
    Key? key,
    required this.suggestedWord,
    required this.frequency,
    this.isFirstWord = true,
    this.onTap,
  }) : super(key: key);
  final String suggestedWord;
  final int frequency;
  final bool isFirstWord;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String scriptWord = PaliScript.getScriptOf(
        language: context.read<ScriptLanguageProvider>().currentLanguage,
        romanText: suggestedWord);
    if (!isFirstWord) {
      scriptWord = '... $scriptWord';
    }
    return ListTile(
      dense: true,
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      // suggested word
      title: Text(scriptWord, style: const TextStyle(fontSize: 20)),
      leading: const Icon(Icons.search),
      // word frequency
      trailing: Text(
          PaliScript.getScriptOf(
              language: context.read<ScriptLanguageProvider>().currentLanguage,
              romanText: frequency.toString()),
          style: const TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}