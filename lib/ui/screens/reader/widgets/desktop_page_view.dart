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
    int pageIndex = vm.currentPage! - vm.book.firstPage!;

    vm.itemScrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener =
        ItemPositionsListener.create();

    itemPositionsListener.itemPositions.addListener(() {
      // final firstIndex = itemPositionsListener.itemPositions.value.first.index;
      final lastIndex = itemPositionsListener.itemPositions.value.last.index;

      if (pageIndex != lastIndex) {
        debugPrint('scrolled to next or previous page');
        vm.onPageChanged(lastIndex);
      }
    });

    return ScrollablePositionedList.builder(
      initialScrollIndex: pageIndex,
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
          fontSize: vm.fontSize + 0.0,
          onClick: (clickedWord) {
            vm.showDictionary(clickedWord);
          },
        );
      },
    );
  }
}
