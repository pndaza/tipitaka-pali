import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app.dart';
import '../../../../business_logic/view_models/reader_view_model.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';
import 'pali_page_widget.dart';

class MobileBookView extends StatelessWidget {
  const MobileBookView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    myLogger.i('building pageview for mobile');
    final vm = Provider.of<ReaderViewModel>(context, listen: false);

    vm.pageController =
        PageController(initialPage: vm.currentPage! - vm.book.firstPage!);

    return PageView.builder(
      // physics: RangeMaintainingScrollPhysics(),
      physics: const ClampingScrollPhysics(),
      pageSnapping: true,
      controller: vm.pageController,
      itemCount: vm.pages.length,
      itemBuilder: (context, index) {
        var content = vm.getPageContentForDesktop(index);
        final script = context.read<ScriptLanguageProvider>().currentScript;
        // transciption
        content = PaliScript.getScriptOf(
          script: script,
          romanText: content,
          isHtmlText: true,
        );
        // content = _formatContent(content, script, vm.fontSize);
        return SingleChildScrollView(
          child: PaliPageWidget(
            htmlContent: content,
            script: script,
            fontSize: vm.fontSize + 0.0,
            onClick: (clickedWord) {
              vm.onClickedWord(clickedWord);
            },
          ),
        );
      },
      onPageChanged: vm.onPageChanged,
    );
  }
}
