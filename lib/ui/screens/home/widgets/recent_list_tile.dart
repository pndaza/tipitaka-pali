import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/models/recent.dart';
import 'package:tipitaka_pali/business_logic/view_models/recent_page_view_model.dart';

import '../../../../routes.dart';

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
          title: Text(recent.bookName!),
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
