import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';
import '../../../../utils/pali_tools.dart';
import '../../../../utils/script_detector.dart';
import '../controller/dictionary_controller.dart';

class DictionarySearchField extends StatefulWidget {
  const DictionarySearchField({
    Key? key,
  }) : super(key: key);

  @override
  State<DictionarySearchField> createState() => _DictionarySearchFieldState();
}

class _DictionarySearchFieldState extends State<DictionarySearchField> {
  late final TextEditingController textEditingController;
  late final DictionaryController dictionaryController;

  @override
  void initState() {
    super.initState();

    dictionaryController = context.read<DictionaryController>();
    textEditingController = TextEditingController();

    final lookupWord = dictionaryController.lookupWord;
    if (lookupWord != null) {
      textEditingController.text = PaliScript.getScriptOf(
          script: context.read<ScriptLanguageProvider>().currentScript,
          romanText: lookupWord);
    } else {
      textEditingController.text = '';
    }
    dictionaryController.addListener(_lookUpWordListener);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _lookUpWordListener() {
    final lookupWord = dictionaryController.lookupWord;
    if (lookupWord != null) {
      textEditingController.text = PaliScript.getScriptOf(
          script: context.read<ScriptLanguageProvider>().currentScript,
          romanText: lookupWord);
    } else {
      textEditingController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            autocorrect: false,
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
            ),
            onChanged: (text) {
              // convert velthuis input to uni
              if (text.isNotEmpty) {
                // text controller naturally pushes to the beginning
                // fixed to keep natural position

                // before conversion get cursor position and length
                int origTextLen = text.length;
                int pos = textEditingController.selection.start;
                final uniText = PaliTools.velthuisToUni(velthiusInput: text);
                // after conversion get length and add the difference (if any)
                int uniTextlen = uniText.length;
                textEditingController.text = uniText;
                textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: pos + uniTextlen - origTextLen));
              }
            }),
        suggestionsCallback: (text) async {
          if (text.isEmpty) {
            return <String>[];
          } else {
            final inputLanguage = ScriptDetector.getLanguage(text);
            final romanText = PaliScript.getRomanScriptFrom(
                script: inputLanguage, text: text);
            final suggestions = await context
                .read<DictionaryController>()
                .getSuggestions(romanText);
            return suggestions;
          }
        },
        debounceDuration: Duration.zero,
        itemBuilder: (context, String suggestion) {
          return ListTile(
              title: Text(PaliScript.getScriptOf(
                  script: context.read<ScriptLanguageProvider>().currentScript,
                  romanText: suggestion)));
        },
        onSuggestionSelected: (String suggestion) {
          final inputLanguage =
              ScriptDetector.getLanguage(textEditingController.text);
          textEditingController.text = PaliScript.getScriptOf(
              script: inputLanguage, romanText: suggestion);
          context.read<DictionaryController>().onLookup(suggestion);
        });
  }
}
