import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../../business_logic/view_models/reader_view_model.dart';
import '../../../dialogs/dictionary_dialog.dart';

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
                customStylesBuilder: (element) {
                  // if (element.className == 'title' ||
                  //     element.className == 'book' ||
                  //     element.className == 'chapter' ||
                  //     element.className == 'subhead' ||
                  //     element.className == 'nikaya') {
                  //   return {
                  //     'text-align': 'center',
                  //     // 'text-decoration': 'none',
                  //   };
                  // }
                  if (element.localName == 'a') {
                    // print('found a tag: ${element.outerHtml}');
                    return {
                      'color': 'black',
                      'text-decoration': 'none',
                    };
                  }
                  // no style
                  return {'text-decoration': 'none'};
                },
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
    content = _makeClickable(content);
    content = _changeToInlineStyle(content);
    return content;
  }

  String _makeClickable(String content) {
    // pali word not inside html tag
    final regexPaliWord =
        RegExp(r'[a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]+(?![^<>]*>)');
    return content.replaceAllMapped(regexPaliWord,
        (match) => '<a href="${match.group(0)}">${match.group(0)}</a>');
    /*
    final regexHtmlTag = RegExp(r'<[^>]+>');
    final regexPaliWord = RegExp(r'([a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]+)');
    final matches = regexHtmlTag.allMatches(content);

    var formattedContent = '';
    for (var i = 0, length = matches.length; i < length - 1; i++) {
      final curretTag = matches.elementAt(i);
      final nextTag = matches.elementAt(i + 1);
      // add current tag to formatted content
      formattedContent += content.substring(curretTag.start, curretTag.end);
      if (curretTag.end == nextTag.start) continue; // no text data
      // extract text data
      var text = content.substring(curretTag.end, nextTag.start);
      // add a tag to every word to make clickable
      text = text.replaceAllMapped(regexPaliWord, (match) {
        String word = match.group(0)!;
        return '<a href="$word">$word</a>';
      });
      // add text to formatted context
      formattedContent += text;
    }
    // add last tag to formatted content
    formattedContent += content.substring(matches.last.start);

    return formattedContent;
    */
  }

  String _changeToInlineStyle(String content) {
    final styleMaps = <String, String>{
      r'class="bld"': r'style="font-weight:bold;"',
      r'class="centered"': r'style="text-align:center;"',
      r'class="paranum"': r'style="font-weight: bold;"',
      r'class="indent"': r'style="text-indent:1.3em;margin-left:2em;"',
      r'class="bodytext"':
          r'style="text-indent:1.3em;"',
      r'class="unindented"': r'style=""',
      r'class="noindentbodytext"': r'style=""',
      r'class="book"':
          r'style="font-size: 1.9em; text-align:center; font-weight: bold;"',
      r'class="chapter"':
          r'style="font-size: 1.7em; text-align:center; font-weight: bold;"',
      r'class="nikaya"':
          r'style="font-size: 1.6em; text-align:center; font-weight: bold;"',
      r'class="title"':
          r'style="font-size: 1.3em; text-align:center; font-weight: bold;"',
      r'class="subhead"':
          r'style="font-size: 1.6em; text-align:center; font-weight: bold;"',
      r'class="subsubhead"':
          r'style="font-size: 1.6em; text-align:center; font-weight: bold;"',
      r'class="gatha1"': r'style="margin-bottom: 0em; margin-left: 5em;"',
      r'class="gatha2"': r'style="margin-bottom: 0em; margin-left: 5em;"',
      r'class="gatha3"': r'style="margin-bottom: 0em; margin-left: 5em;"',
      r'class="gathalast"': r'style="margin-bottom: 1.3em; margin-left: 5em;"',
      r'class="pageheader"': r'style="font-size: 0.9em; color: deeppink;"',
      r'class="highlighted"':
          r'style="background: rgb(255, 114, 20); color: white;"',
    };

    styleMaps.forEach((key, value) {
      content = content.replaceAll(key, value);
    });

    return content;
  }

  Future<void> showDictionary(BuildContext context, String word) async {
    // removing puntuations etc.
    word = word.replaceAll(RegExp(r'[^a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ]'), '');
    // convert ot lower case
    word = word.toLowerCase();
    await showSlidingBottomSheet(context, builder: (context) {
      //Widget for SlidingSheetDialog's builder method
      final statusBarHeight = MediaQuery.of(context).padding.top;
      final screenHeight = MediaQuery.of(context).size.height;
      const marginTop = 24.0;
      final slidingSheetDialogContent = SizedBox(
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
