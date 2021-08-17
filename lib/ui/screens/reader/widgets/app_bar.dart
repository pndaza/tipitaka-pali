import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/business_logic/view_models/reader_view_model.dart';
import 'package:tipitaka_pali/ui/dialogs/simple_input_dialog.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReaderAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    myLogger.i('Building Appbar');
    return AppBar(
      title: Text('${vm.book.name}'),
      actions: [
        IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: vm.increaseFontSize),
        IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: vm.decreaseFontSize),
        IconButton(
            icon: Icon(Icons.book_outlined),
            onPressed: () {
              _addBookmark(vm, context);
            }),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);

  void _addBookmark(ReaderViewModel vm, BuildContext context) async {
    final note = await showDialog<String>(
      context: context,
      builder: (context) {
        return ThemeConsumer(
          child: SimpleInputDialog(
            hintText: 'မှတ်လိုသောစာသား ထည့်ပါ',
            cancelLabel: 'မမှတ်တော့ဘူး',
            okLabel: 'မှတ်မယ်',
          ),
        );
      },
    );
    print(note);
    if (note != null) {
      vm.saveToBookmark(note);
    }
  }
}
