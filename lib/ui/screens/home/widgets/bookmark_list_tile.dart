import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/models/bookmark.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';

class BookmarkListTile extends StatelessWidget {
  // final BookmarkPageViewModel bookmarkViewmodel;
  // final int index;

  const BookmarkListTile(
      {Key? key, required this.bookmark, this.onTap, this.onDelete})
      : super(key: key);
  final Bookmark bookmark;
  final Function(Bookmark bookmark)? onDelete;
  final Function(Bookmark bookmark)? onTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            if (onDelete != null) onDelete!(bookmark);
          },
        )
      ],
      child: ListTile(
        onTap: () {
          if (onTap != null) onTap!(bookmark);
        },
        title: Text(bookmark.note),
        subtitle: Text(PaliScript.getScriptOf(
            language: context.read<ScriptLanguageProvider>().currentLanguage,
            romanText: bookmark.bookName!)),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              Text('page - '),
              Expanded(
                  child: Text(
                '${bookmark.pageNumber}',
                textAlign: TextAlign.end,
              )),
            ],
          ),
        ),
      ),
    );
  }

}
