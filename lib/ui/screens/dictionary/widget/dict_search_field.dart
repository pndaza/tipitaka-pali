import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';
import '../../../../utils/pali_tools.dart';
import '../../../../utils/script_detector.dart';
import '../controller/dictionary_controller.dart';

class DictionarySearchField extends StatefulWidget {
  const DictionarySearchField({Key? key, this.initialValue}) : super(key: key);
  final String? initialValue;

  @override
  State<DictionarySearchField> createState() => _DictionarySearchFieldState();
}

class _DictionarySearchFieldState extends State<DictionarySearchField> {
  // late final TextEditingController textEditingController;
  @override
  void initState() {
    context.read<DictionaryViewModel>().textEditingController.text =
        widget.initialValue == null
            ? ''
            : PaliScript.getScriptOf(
                script: context.read<ScriptLanguageProvider>().currentScript,
                romanText: widget.initialValue!);

    // textEditingController = TextEditingController(
    //     text: widget.initialValue == null
    //         ? null
    //         : PaliScript.getScriptOf(
    //             script: context.read<ScriptLanguageProvider>().currentScript,
    //             romanText: widget.initialValue!));
    super.initState();
  }

  @override
  void dispose() {
    // textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textEditingController =
        context.watch<DictionaryViewModel>().textEditingController;
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            autocorrect: false,
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 4,
              ),
            ),
            onChanged: (text) {
              // convert velthuis input to uni
              if (text.isNotEmpty) {
                final uniText = PaliTools.velthuisToUni(velthiusInput: text);
                textEditingController.text = uniText;
                textEditingController.selection = TextSelection.fromPosition(
                    TextPosition(offset: textEditingController.text.length));
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
                .read<DictionaryViewModel>()
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
          context.read<DictionaryViewModel>().onClickSuggestion(suggestion);
        });
  }
}
