import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/toc_list_item.dart';
import 'package:tipitaka_pali/business_logic/view_models/toc_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TocDialog extends StatelessWidget {
  final String bookID;

  const TocDialog({Key? key, required this.bookID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            Text(
              AppLocalizations.of(context)!.table_of_contents,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context, null),
                  ),
                ))
          ]),
          const Divider(),
          FutureBuilder<List<TocListItem>>(
              future: TocViewModel(bookID).fetchTocListItems(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listItems = snapshot.data!;
                  return Expanded(
                    child: ListView.separated(
                      itemCount: listItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            // final pageNumber = listItems[index].getPageNumber();
                            Navigator.pop(context, listItems[index].toc);
                          },
                          child: ListTile(
                            title: listItems[index].build(context),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(
                            height: 1, indent: 16.0, endIndent: 16.0);
                      },
                    ),
                  );
                } else {
                  return const SizedBox(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
