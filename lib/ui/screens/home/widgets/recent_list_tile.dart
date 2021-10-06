import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/models/book.dart';
import '../../../../business_logic/models/recent.dart';
import '../../../../business_logic/view_models/recent_page_view_model.dart';
import '../../../../routes.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';

class RecentListTile extends StatelessWidget {
  final RecentPageViewModel vm;
  final int index;
  RecentListTile(this.vm, this.index);

  @override
  Widget build(BuildContext context) {
    final recent = vm.recents[index];
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.red,
          onTap: () => vm.delete(index),
        )
      ],
      child: GestureDetector(
        child: ListTile(
          title: Text(PaliScript.getScriptOf(
                language:
                    context.read<ScriptLanguageProvider>().currentLanguage,
                romanText: recent.bookName!)),
          trailing: Container(
            width: 80,
            child: Row(
              children: [
                Text('page  - '),
                Expanded(
                    child: Text(
                  '${recent.pageNumber}',
                  textAlign: TextAlign.end,
                )),
              ],
            ),
          ),
        ),
        onTap: () {
          _openBook(context, recent);
        },
      ),
    );
  }

  _openBook(BuildContext context, Recent recent) {
    Navigator.pushNamed(context, ReaderRoute, arguments: {
      'book': Book(id: recent.bookID, name: recent.bookName!),
      'currentPage': recent.pageNumber
    });
  }
}
