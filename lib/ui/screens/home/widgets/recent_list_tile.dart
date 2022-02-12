import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/models/recent.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentListTile extends StatelessWidget {
  const RecentListTile(
      {Key? key, required this.recent, this.onTap, this.onDelete})
      : super(key: key);
  final Recent recent;
  final Function(Recent recent)? onDelete;
  final Function(Recent recent)? onTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              //label: 'Archive',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) {
                if (onDelete != null) onDelete!(recent);
              },
            ),
          ],
        ),
        child: Builder(
            builder: (context) => ListTile(
                  onLongPress: () {
                    openSlidable(context);
                  },
                  onTap: () {
                    if (onTap != null) onTap!(recent);
                  },
                  title: Text(PaliScript.getScriptOf(
                      script: context
                          .read<ScriptLanguageProvider>()
                          .currentScript,
                      romanText: recent.bookName!)),
                  trailing: SizedBox(
                    width: 105,
                    child: Row(
                      children: [
                        Text('${AppLocalizations.of(context)!.page} -'),
                        Expanded(
                            child: Text(
                                PaliScript.getScriptOf(
                                    script: context
                                        .read<ScriptLanguageProvider>()
                                        .currentScript,
                                    romanText: recent.pageNumber.toString()),
                                textAlign: TextAlign.end)),
                      ],
                    ),
                  ),
                )));
  }

  void openSlidable(BuildContext context) {
    final controller = Slidable.of(context)!;
    final isClosed = controller.actionPaneType.value == ActionPaneType.none;
    if (isClosed) {
      controller.openEndActionPane();
    }
  }
}
