// import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:side_sheet/side_sheet.dart';
// import 'package:side_sheet/side_sheet.dart';
import 'package:tipitaka_pali/ui/screens/home/opened_books_provider.dart';
import 'package:tipitaka_pali/utils/platform_info.dart';
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

class ControlBar extends StatelessWidget {
  const ControlBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    myLogger.i('building control bar');
    return Material(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            UpperRow(),
            // SizedBox(height: 8),
            LowerRow(),
          ],
        ),
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
          child: PlatformInfo.isDesktop
              ? Row(
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
                )
              : Column(
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
                            onPressed: () =>
                                _selectParagraphDialog(context, vm)),
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
                              '${paragraphs[i].bookName} - ${paragraphs[i].expPageNumber}'),
                          title: Text(
                              '${AppLocalizations.of(context)!.paragraph_number}: ${paragraphs[i].paragraph}'),
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

    if (PlatformInfo.isDesktop) {
      final openedBookController = context.read<OpenedBooksProvider>();
      openedBookController.add(book: book, currentPage: pageNumber);
    }

    Navigator.pushNamed(context, readerRoute, arguments: {
      'book': book,
      'currentPage': pageNumber,
    });
  }

  void _openTocDialog(BuildContext context, ReaderViewModel vm) async {
    // closing navigation bar
    Navigator.pop(context);

    if (PlatformInfo.isDesktop) {
      final toc = await showDialog<Toc>(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Align(
            alignment: Alignment.centerRight,
            child: SizedBox(width: 400, child: TocDialog(bookID: vm.book.id)),
          );
        },
      );

      if (toc != null) {
        vm.gotoPageAndScroll(toc.pageNumber.toDouble(), toc.name);
      }

      return;
    }

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

class UpperRow extends StatelessWidget {
  const UpperRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () => _openGotoDialog(context),
            icon: const Icon(Icons.directions_walk_outlined)),
        const Expanded(child: MySlider()),
        IconButton(
            onPressed: () => _openTocDialog(context),
            icon: const Icon(Icons.list_outlined)),
      ],
    );
  }

  void _openGotoDialog(BuildContext context) async {
    final vm = context.read<ReaderViewModel>();
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

  void _openTocDialog(BuildContext context) async {
    final vm = context.read<ReaderViewModel>();

    if (PlatformInfo.isDesktop) {
      const sideSheetWidth = 400.0;
      final toc = await showGeneralDialog<Toc>(
        context: context,
        barrierLabel: 'TOC',
        barrierDismissible: true,
        transitionDuration: const Duration(milliseconds: 800),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(1, 0), end: const Offset(0, 0))
                .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutSine),
            ),
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Container(
                width: MediaQuery.of(context).size.width > 600
                    ? sideSheetWidth
                    : double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(32),
                    )),
                child: TocDialog(bookID: vm.book.id),
              ),
            ),
          );
        },
      );

      if (toc != null) {
        vm.gotoPageAndScroll(toc.pageNumber.toDouble(), toc.name);
      }
    } else {
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
  }
}

class LowerRow extends StatelessWidget {
  const LowerRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IconButton(
              onPressed: () => _onMATButtomClicked(context),
              icon: const Icon(Icons.local_library_outlined)),
          IconButton(
              onPressed: () => _onIncreaseButtonClicked(context),
              icon: const Icon(Icons.add_circle_outline)),
          IconButton(
              onPressed: () => _onDecreaseButtonClicked(context),
              icon: const Icon(Icons.remove_circle_outline)),
          IconButton(
              onPressed: () => _addBookmark(context),
              icon: const Icon(Icons.bookmark_add_outlined)),
          if (!PlatformInfo.isDesktop)
            IconButton(
                onPressed: () => _openSettingPage(context),
                icon: const Icon(Icons.settings_outlined)),
        ],
      ),
    );
  }

  void _openSettingPage(BuildContext context) async {
    if (PlatformInfo.isDesktop) {
    } else {
      await Navigator.pushNamed(context, settingRoute);
    }
  }

  void _addBookmark(BuildContext context) async {
    final vm = context.read<ReaderViewModel>();
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

  void _onIncreaseButtonClicked(BuildContext context) {
    context.read<ReaderViewModel>().increaseFontSize();
  }

  void _onDecreaseButtonClicked(BuildContext context) {
    context.read<ReaderViewModel>().decreaseFontSize();
  }

  void _onMATButtomClicked(BuildContext context) async {
    final vm = context.read<ReaderViewModel>();
    final paragraphs = await vm.getParagraphs();
    if (paragraphs.isEmpty) {
      _showNoExplanationDialog(context);
      return;
    }
    final result = await _showParagraphSelectDialog(context, paragraphs);
    if (result != null) {
      final bookId = result['book_id'] as String;
      final bookName = result['book_name'] as String;
      final pageNumber = result['page_number'] as int;

      final book = Book(id: bookId, name: bookName);

      if (PlatformInfo.isDesktop) {
        final openedBookController = context.read<OpenedBooksProvider>();
        openedBookController.add(book: book, currentPage: pageNumber);
      } else {
        Navigator.pushNamed(context, readerRoute, arguments: {
          'book': book,
          'currentPage': pageNumber,
        });
      }
    }
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

  Future<Map<String, dynamic>?> _showParagraphSelectDialog(
      BuildContext context, List<ParagraphMapping> paragraphs) {
    return showModalBottomSheet<Map<String, dynamic>>(
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
                              '${paragraphs[i].bookName} - ${paragraphs[i].expPageNumber}'),
                          title: Text(
                              '${AppLocalizations.of(context)!.paragraph_number}: ${paragraphs[i].paragraph}'),
                          onTap: () {
                            Navigator.pop(context, {
                              'book_id': paragraphs[i].expBookID,
                              'book_name': paragraphs[i].bookName,
                              'page_number': paragraphs[i].expPageNumber,
                            });

                            // _openBook(
                            //     context,
                            //     paragraphs[i].expBookID,
                            //     paragraphs[i].bookName,
                            //     paragraphs[i].expPageNumber);
                          },
                        ),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: paragraphs.length),
              ),
            ],
          );
        });
  }
}
