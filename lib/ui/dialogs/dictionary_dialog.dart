import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/utils/script_detector.dart';

import '../../business_logic/view_models/dictionary_state.dart';
import '../../business_logic/view_models/dictionary_view_model.dart';
import '../../services/provider/script_language_provider.dart';
import '../../utils/pali_script.dart';
import '../../utils/pali_tools.dart';

class DictionaryDialog extends StatelessWidget {
  final String? word;
  const DictionaryDialog({Key? key, this.word}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DictionaryViewModel>(
      create: (context) => DictionaryViewModel(context, word),
      child: Material(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 56.0),
              child: DictionaryContentView(),
            ),
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(child: DictionarySearchField(initialValue: word)),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DictionaryAlgorithmModeView(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DictionarySearchField extends StatefulWidget {
  const DictionarySearchField({Key? key, this.initialValue}) : super(key: key);
  final String? initialValue;

  @override
  State<DictionarySearchField> createState() => _DictionarySearchFieldState();
}

class _DictionarySearchFieldState extends State<DictionarySearchField> {
  late final TextEditingController textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController(
        text: widget.initialValue == null
            ? null
            : PaliScript.getScriptOf(
                script: context.read<ScriptLanguageProvider>().currentScript,
                romanText: widget.initialValue!));
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            autocorrect: false,
            controller: textEditingController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 4)),
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
            return context
                .read<DictionaryViewModel>()
                .getSuggestions(romanText);
          }
        },
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

class DictionaryAlgorithmModeView extends StatelessWidget {
  const DictionaryAlgorithmModeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final algoMode = context.select<DictionaryViewModel, DictAlgorithm>(
        (vm) => vm.currentAlgorithmMode);

    return DropdownButton<DictAlgorithm>(
      value: algoMode,
      items: DictAlgorithm.values
          .map((algo) => DropdownMenuItem<DictAlgorithm>(
              value: algo, child: Text(algo.toStr())))
          .toList(),
      onChanged: context.read<DictionaryViewModel>().onModeChanged,
    );
  }
}

class DictionaryContentView extends StatelessWidget {
  const DictionaryContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.select<DictionaryViewModel, DictionaryState>(
        (DictionaryViewModel vm) => vm.dictionaryState);

    return state.when(
        initial: () => Container(),
        loading: () => const SizedBox(
            height: 100, child: Center(child: CircularProgressIndicator())),
        data: (content) => SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  content,
                  isSelectable: true,
                ))),
        noData: () => const SizedBox(
              height: 100,
              child: Center(child: Text('Not found')),
            ));
  }
}
