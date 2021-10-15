import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../../../app.dart';
import '../../../../business_logic/models/book.dart';
import '../../../../business_logic/models/paragraph_mapping.dart';
import '../../../../business_logic/models/toc.dart';
import '../../../../business_logic/view_models/reader_view_model.dart';
import '../../../../routes.dart';
import '../../../dialogs/goto_dialog.dart';
import '../../../dialogs/simple_input_dialog.dart';
import '../../../dialogs/toc_dialog.dart';
import 'slider.dart';
import '../../../widgets/icon_text_button.dart';
import '../../../../utils/mm_number.dart';

class ControlBar extends StatelessWidget {
  const ControlBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    myLogger.i('building control bar');
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    return SizedBox(
      height: 56.0,
      child: Row(
        children: [
          // used for padding
          const SizedBox(
            width: 16,
          ),
          const Expanded(child: MySlider()),
          IconButton(
              icon: const Icon(Icons.more_vert_outlined),
              onPressed: () {
                _openNavDialog(context, vm);
              }),
          //used for padding
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }

  _openNavDialog(BuildContext context, ReaderViewModel vm) async {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconTextButton(
                      icon: Icons.directions_walk,
                      text: AppLocalizations.of(context)!.goto,
                      onPressed: () => _openGotoDialog(context, vm)),
                  IconTextButton(
                      icon: Icons.local_library,
                      text: AppLocalizations.of(context)!.mat,
                      onPressed: () => _selectParagraphDialog(context, vm)),
                  IconTextButton(
                      icon: Icons.toc,
                      text: AppLocalizations.of(context)!.toc,
                      onPressed: () => _openTocDialog(context, vm)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconTextButton(
                      icon: Icons.book_outlined,
                      text: AppLocalizations.of(context)!.bookmark,
                      onPressed: () {
                        _addBookmark(vm, context);
                      }),
                  IconTextButton(
                      icon: Icons.remove_circle_outline,
                      text: AppLocalizations.of(context)!.font,
                      onPressed: vm.decreaseFontSize),
                  IconTextButton(
                      icon: Icons.add_circle_outline,
                      text: AppLocalizations.of(context)!.font,
                      onPressed: vm.increaseFontSize),
                  IconTextButton(
                      icon: Icons.settings,
                      text: AppLocalizations.of(context)!.settings,
                      onPressed: () => _openSettingPage(context)),
                ],
              ),
            ],
          ),
        ),
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
              // ignore: prefer_const_literals_to_create_immutables
              children: <Widget>[
                // if current book is mula pali , it opens corresponded atthakatha
                // if attha, will open tika
                Text(AppLocalizations.of(context)!.unable_open_page),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.close),
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  AppLocalizations.of(context)!.select_paragraph,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              SizedBox(
                height: 280,
                child: ListView.separated(
                    itemBuilder: (_, i) => ListTile(
                          subtitle: Text(
                              '${paragraphs[i].bookName} - ${MmNumber.get(paragraphs[i].expPageNumber)}'),
                          title: Text(
                              '${AppLocalizations.of(context)!.paragraph_number}: ${MmNumber.get(paragraphs[i].paragraph)}'),
                          onTap: () {
                            _openBook(
                                context,
                                paragraphs[i].expBookID,
                                paragraphs[i].bookName,
                                paragraphs[i].expPageNumber);
                          },
                        ),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: paragraphs.length),
              ),
            ],
          );
        });
  }

  void _openBook(
      BuildContext context, String bookID, String bookName, int pageNumber) {
    Navigator.of(context).pop();
    final book = Book(id: bookID, name: bookName);
    Navigator.pushNamed(context, readerRoute, arguments: {
      'book': book,
      'currentPage': pageNumber,
    });
  }

  void _openTocDialog(BuildContext context, ReaderViewModel vm) async {
    final toc = await showBarModalBottomSheet<Toc>(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        expand: false,
        context: context,
        builder: (context) {
          return TocDialog(bookID: vm.book.id);
        });
    if (toc != null) {
      vm.gotoPageAndScroll(toc.pageNumber.toDouble(), toc.name);
    }
  }

  void _openSettingPage(BuildContext context) async {
    await Navigator.pushNamed(context, settingRoute);
  }

  void _addBookmark(ReaderViewModel vm, BuildContext context) async {
    final note = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleInputDialog(
          hintText: AppLocalizations.of(context)!.enter_note,
          cancelLabel: AppLocalizations.of(context)!.cancel,
          okLabel: AppLocalizations.of(context)!.save,
        );
      },
    );
    //print(note);
    if (note != null) {
      vm.saveToBookmark(note);
    }
  }
}
