import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_view_model.dart';
import 'package:tipitaka_pali/utils/pali_tools.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DictionaryDialog extends StatelessWidget {
  final String word;
  DictionaryDialog(this.word);

  @override
  Widget build(BuildContext context) {
    var textEditingController = new TextEditingController(text: word);

    return ChangeNotifierProvider<DictionaryViewModel>(
      create: (content) => DictionaryViewModel(content, word),
      builder: (context, child) {
        return Consumer(builder: (context, DictionaryViewModel vm, __) {
          final currentAlgorithmMode = vm.currentAlgorithmMode;
          final pageContent = vm.definition;

          vm.webViewController?.loadUrl(_getUri(pageContent).toString());

          // fix for webview scroll in modal bottom sheet
          // https://stackoverflow.com/a/62276169/
          final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers =
              [Factory(() => EagerGestureRecognizer())].toSet();
          UniqueKey _key = UniqueKey();

          return Material(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 56.0),
                  child: pageContent.isEmpty
                      ? Container(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()))
                      : WebView(
                          key: _key,
                          initialUrl: _getUri(pageContent).toString(),
                          onWebViewCreated: (controller) {
                            vm.webViewController = controller;
                          },
                          gestureRecognizers: gestureRecognizers,
                        ),
                ),
                ListTile(
                  leading: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: TextField(
                    controller: textEditingController,
                    // style: TextStyle(
                    //     color: Theme.of(context).colorScheme.onBackground),
                    decoration: new InputDecoration(
                        // filled: true,
                        // fillColor: Theme.of(context).colorScheme.background,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        contentPadding: EdgeInsets.fromLTRB(24, 4, 24, 4)),
                    cursorColor: Colors.redAccent,
                    onChanged: (text) {
                      final uniText =
                          PaliTools.velthuisToUni(velthiusInput: text);
                      textEditingController.text = uniText;
                      textEditingController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: textEditingController.text.length));
                      context
                          .read<DictionaryViewModel>()
                          .onTextChanged(uniText);
                    },
                  ),
                  trailing: DropdownButton<DictAlgorithm>(
                    value: currentAlgorithmMode,
                    items: DictAlgorithm.values
                        .map((algo) => DropdownMenuItem<DictAlgorithm>(
                            value: algo,
                            child: Text(
                              algo.toShortString(),
                              // style: TextStyle(
                              //   color: Theme.of(context).colorScheme.onSecondary,
                              //   backgroundColor: Theme.of(context).colorScheme.secondary),
                            )))
                        .toList(),
                    onChanged: context
                        .read<DictionaryViewModel>()
                        .onAlgorithmModeChanged,
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Uri _getUri(String pageContent) {
    return Uri.dataFromString('<!DOCTYPE html> $pageContent',
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
  }
}
