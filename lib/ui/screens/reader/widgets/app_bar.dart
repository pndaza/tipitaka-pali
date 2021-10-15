import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/business_logic/view_models/reader_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ReaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReaderAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ReaderViewModel>(context, listen: false);
    myLogger.i('Building Appbar');
    return AppBar(
      title: Text(vm.book.name),
      actions: [
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);


}
