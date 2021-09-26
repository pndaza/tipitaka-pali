import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';

import '../../business_logic/view_models/dictionary_state.dart';
import '../../business_logic/view_models/dictionary_view_model.dart';
import '../../utils/pali_tools.dart';

class DictionaryDialog extends StatelessWidget {
  final String? word;
  DictionaryDialog({this.word});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DictionaryViewModel>(
      create: (content) => DictionaryViewModel(word),
      child: Material(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 56.0),
              child: DictionaryContentView(),
            ),
            ListTile(
              // close button
              leading: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: DictionarySearchField(
                initialValue: word,
              ),
              trailing: DictionaryAlgorithmModeView(),
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
  late final textEditingController;
  @override
  void initState() {
    textEditingController = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
              autocorrect: false,
              controller: textEditingController,
              decoration: InputDecoration(border: OutlineInputBorder()),
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
              return context.read<DictionaryViewModel>().getSuggestions(text);
            }
          },
          itemBuilder: (context, String suggestion) {
            return ListTile(title: Text(suggestion));
          },
          onSuggestionSelected: (String suggestion) {
            textEditingController.text = suggestion;
            context.read<DictionaryViewModel>().onClickSuggestion(suggestion);
          }),
    );
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
        loading: () => Container(
            height: 100, child: Center(child: CircularProgressIndicator())),
        data: (content) => SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(16.0), child: HtmlWidget(content))),
        noData: () => Container(
              height: 100,
              child: Center(child: Text('Not found')),
            ));
  }
}
