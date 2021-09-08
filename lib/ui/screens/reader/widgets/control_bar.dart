import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/models/paragraph_mapping.dart';
import 'package:tipitaka_pali/business_logic/models/toc.dart';
import 'package:tipitaka_pali/business_logic/view_models/reader_view_model.dart';
import 'package:tipitaka_pali/ui/dialogs/goto_dialog.dart';
import 'package:tipitaka_pali/ui/dialogs/toc_dialog.dart';
import 'package:tipitaka_pali/ui/screens/reader/widgets/slider.dart';
import 'package:tipitaka_pali/utils/mm_number.dart';

import '../../../../routes.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    myLogger.i('building control bar');
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    return Container(
      height: 56.0,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => _openGotoDialog(context, vm)),
          ),
          IconButton(
              icon: Icon(Icons.repeat),
              onPressed: () => _selectParagraphDialog(context, vm)),
          const Expanded(child: MySlider()),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
                icon: Icon(Icons.toc),
                onPressed: () {
                  _openTocDialog(context, vm);
                }),
          )
        ],
      ),
    );
  }

  void _openGotoDialog(BuildContext context, ReaderViewModel vm) async {
    final firstParagraph = await vm.getFirstParagraph();
    final lastParagraph = await vm.getLastParagraph();
    final gotoResult = await showDialog<GotoDialogResult>(
      context: context,
      builder: (BuildContext context) => GotoDialog(
        firstPage: vm.book.firstPage!,
        lastPage: vm.book.lastPage!,
        firstParagraph: firstParagraph,
        lastParagraph: lastParagraph,
      ),
    );
    if (gotoResult != null) {
      final int pageNumber = gotoResult.type == GotoType.page
          ? gotoResult.number
          : await vm.getPageNumber(gotoResult.number);
      vm.gotoPage(pageNumber.toDouble());
    }
  }

  void _selectParagraphDialog(BuildContext context, ReaderViewModel vm) async {
    final paragraphs = await vm.getParagraphs();
    paragraphs.isEmpty
        ? _showNoExplanationDialog(context)
        : _showParagraphSelectDialog(context, paragraphs);
  }

  Future<void> _showNoExplanationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // if current book is mula pali , it opens corresponded atthakatha
                // if attha, will open tika
                Text('ယခု စာမျက်နှာအတွက် အဖွင့် ကြည့်ရှု မရနိုင်ပါ။'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ပိတ်'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showParagraphSelectDialog(
      BuildContext context, List<ParagraphMapping> paragraphs) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'အဖွင့်ကြည့်လိုသော စာပိုဒ်ရွေးပါ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                Container(
                  height: 280,
                  child: ListView.separated(
                      itemBuilder: (_, i) => ListTile(
                            subtitle: Text(
                                '${paragraphs[i].bookName} - ${MmNumber.get(paragraphs[i].expPageNumber)}'),
                            title: Text(
                                'စာပိုဒ်အမှတ်: ${MmNumber.get(paragraphs[i].paragraph)}'),
                            onTap: () {
                              _openBook(
                                  context,
                                  paragraphs[i].expBookID,
                                  paragraphs[i].bookName,
                                  paragraphs[i].expPageNumber);
                            },
                          ),
                      separatorBuilder: (_, __) => Divider(),
                      itemCount: paragraphs.length),
                ),
              ],
            ),
          );
        });
  }

  void _openBook(
      BuildContext context, String bookID, String bookName, int pageNumber) {
    Navigator.of(context).pop();
    final book = Book(id: bookID, name: bookName);
    Navigator.pushNamed(context, ReaderRoute, arguments: {
      'book': book,
      'currentPage': pageNumber,
    });
  }

  void _openTocDialog(BuildContext context, ReaderViewModel vm) async {
    final toc = await showBarModalBottomSheet<Toc>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        expand: false,
        context: context,
        builder: (context) {
          return  TocDialog(vm.book.id);
        });
    if (toc != null) {
      vm.gotoPageAndScroll(toc.pageNumber.toDouble(), toc.name);
    }
  }
}
