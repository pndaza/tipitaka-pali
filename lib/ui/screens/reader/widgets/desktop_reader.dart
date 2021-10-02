import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:tipitaka_pali/ui/dialogs/dictionary_dialog.dart';

import '../../../../business_logic/view_models/reader_view_model.dart';

class DesktopReader extends StatelessWidget {
  const DesktopReader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(vm.book.name),
      ),
      body: ListView.builder(
          itemCount: vm.pages.length,
          itemBuilder: (_, index) {
            var content = vm.getPageContentForDesktop(index);
            content = _formatContent(content);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: HtmlWidget(
                content,
                onTapUrl: (word) async {
                  showDictionary(context, word);
                  return true;
                },
              ),
            );
          }),
    );
  }

  String _formatContent(String content) {
    final RegExp regExpClassAttribute =
        RegExp(r'class="[a-zA-Z0-9:;\.\s\(\)\,]*"');
    content = content.replaceAllMapped(regExpClassAttribute, (match) => '');

        final RegExp regExpNameAttribute =
        RegExp(r'name=".+?"');
    content = content.replaceAllMapped(regExpNameAttribute, (match) => '');
    
    final RegExp regExpWord = RegExp(r'([a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]{2,30})');
    content = content.replaceAllMapped(regExpWord,
        (match) => '<a href="${match.group(1)}">${match.group(1)}</a>');
    return content;
  }

  Future<void> showDictionary(BuildContext context, String word) async {
    // removing puntuations etc.
    word = word.replaceAll(new RegExp(r'[^a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]'), '');
    // convert ot lower case
    word = word.toLowerCase();
    await showSlidingBottomSheet(context, builder: (context) {
      //Widget for SlidingSheetDialog's builder method
      final statusBarHeight = MediaQuery.of(context).padding.top;
      final screenHeight = MediaQuery.of(context).size.height;
      final marginTop = 24.0;
      final slidingSheetDialogContent = Container(
        height: screenHeight - (statusBarHeight + marginTop),
        child: DictionaryDialog(word: word),
      );

      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        // minHeight: 200,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.6, 0.8, 1.0],
          positioning: SnapPositioning.relativeToSheetHeight,
        ),
        headerBuilder: (context, _) {
          // building drag handle view
          return Center(
              heightFactor: 1,
              child: Container(
                width: 56,
                height: 10,
                // color: Colors.black45,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.red),
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ));
        },
        // this builder is called when state change
        // normaly three states occurs
        // first state - isLaidOut = false
        // second state - islaidOut = true , isShown = false
        // thirs state - islaidOut = true , isShown = ture
        // to avoid there times rebuilding, return  prebuild content
        builder: (context, state) => slidingSheetDialogContent,
      );
    });
  }
}
