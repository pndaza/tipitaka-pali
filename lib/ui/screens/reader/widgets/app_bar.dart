import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app.dart';
import '../../../../business_logic/view_models/reader_view_model.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';

class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReaderAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    myLogger.i('Building Appbar');
    return AppBar(
      title: Text(PaliScript.getScriptOf(
          language: context.read<ScriptLanguageProvider>().currentLanguage,
          romanText: vm.book.name)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
