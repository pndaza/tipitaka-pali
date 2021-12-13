import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../business_logic/view_models/reader_view_model.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';
import 'pali_page_widget.dart';

class DesktopPageView extends StatelessWidget {
  const DesktopPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReaderViewModel>(context, listen: true);
    vm.itemScrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();
    itemPositionsListener.itemPositions.addListener(() {
      final current = itemPositionsListener.itemPositions.value.first.index;
      // vm.currentPage = current + 1;
      vm.onPageChanged(current);
      print('current index: $current');
    });

    return ScrollablePositionedList.builder(
      initialScrollIndex: vm.currentPage == null ? 0 : vm.currentPage! - 1,
      itemScrollController: vm.itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemCount: vm.pages.length,
      itemBuilder: (_, index) {
        var content = vm.getPageContentForDesktop(index);
        final script = context.read<ScriptLanguageProvider>().currentScript;
        // transciption
        content = PaliScript.getScriptOf(
          script: script,
          romanText: content,
          isHtmlText: true,
        );
        return PaliPageWidget(
          htmlContent: content,
          script: script,
          fontSize: vm.fontSize,
          onClick: (clickedWord) {
            vm.showDictionary(clickedWord);
          },
        );
      },
    );
  }

}
