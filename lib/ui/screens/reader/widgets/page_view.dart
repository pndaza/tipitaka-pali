import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app.dart';
import '../../../../business_logic/view_models/reader_view_model.dart';

class MyPageView extends StatelessWidget {
  const MyPageView();
  @override
  Widget build(BuildContext context) {
    myLogger.i('building pageview');
    final vm = Provider.of<ReaderViewModel>(context, listen: false);

    vm.pageController = PreloadPageController(
        initialPage: vm.currentPage! - vm.book.firstPage!);

    return PreloadPageView.builder(
      physics: RangeMaintainingScrollPhysics(),
      // allowImplicitScrolling: true,
      preloadPagesCount: vm.preLoadPageCount,
      controller: vm.pageController,
      itemCount: vm.pages.length,
      itemBuilder: (context, index) {
        return WebView(
          // initialUrl: vm.getPageContent(index).toString(),
          initialUrl: Uri.dataFromString(vm.getPageContent(index),
                  mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
              .toString(),
          javascriptMode: JavascriptMode.unrestricted,
          javascriptChannels: [
            JavascriptChannel(
                name: 'Define',
                onMessageReceived: (JavascriptMessage message) {
                  vm.showDictionary(message.message);
                })
          ].toSet(),
          gestureRecognizers: Set()
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          onWebViewCreated: (controller) =>
              vm.webViewControllers[index] = controller,
          onPageFinished: (_) {
            vm.webViewControllers[index]!.evaluateJavascript('''
                      var goto = document.getElementById("goto_001");
                      if(goto != null){
                        goto.scrollIntoView();
                      }
                      ''');
            vm.webViewControllers[index]!.evaluateJavascript(vm.javascriptData);
          },
        );
      },
      onPageChanged: vm.onPageChanged,
    );
  }
}
