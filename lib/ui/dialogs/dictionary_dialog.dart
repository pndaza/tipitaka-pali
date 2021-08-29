import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_view_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DictionaryDialog extends StatelessWidget {
  final String word;
  DictionaryDialog(this.word);

  @override
  Widget build(BuildContext context) {
    var textEditingController = new TextEditingController(text: word);

    return ChangeNotifierProvider<DictionaryViewModel>(
        create: (content) => DictionaryViewModel(content, word),
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Container(
                  height: 40,
                  child: Builder(
                    builder: (BuildContext buildContext) {
                      return TextField(                        
                        controller: textEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: new InputDecoration( 
                          // filled: true,
                          // fillColor: Colors.grey,                         
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white70),
                            ),
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(24, 4, 24, 4)),
                        cursorColor: Colors.redAccent,
                        onChanged: (text) => _onTextChanged(buildContext, text, textEditingController),
                      );
                    },
                  )),
                  actions: [SizedBox(width: 50,)],
            ),
            body: Consumer<DictionaryViewModel>(builder: (context, vm, child) {
              final pageContent = vm.definition;
              return pageContent.isEmpty
                  ? Container()
                  : WebView(
                          initialUrl: _getUri(pageContent).toString(),
                          onWebViewCreated: (controller) {
                            vm.webViewController = controller;
                          },
                          gestureRecognizers: Set()
              ..add(Factory<VerticalDragGestureRecognizer>(
                  () => VerticalDragGestureRecognizer())),
                    );
            })));
  }

  Uri _getUri(String pageContent) {
    return Uri.dataFromString('<!DOCTYPE html> $pageContent',
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
  }

  void _onTextChanged(BuildContext context, String text, TextEditingController controller) async {
    final vm = context.read<DictionaryViewModel>();
    vm.doSearch(text);
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  }
}
