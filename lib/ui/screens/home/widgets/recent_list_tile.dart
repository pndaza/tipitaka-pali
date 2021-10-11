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
    // final recent = vm.recents[index];
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            if (onDelete != null) onDelete!(recent);
          },
        )
      ],
      child: ListTile(
        onTap: () {
          if (onTap != null) onTap!(recent);
        },
        title: Text(PaliScript.getScriptOf(
            language: context.read<ScriptLanguageProvider>().currentLanguage,
            romanText: recent.bookName!)),
        trailing: SizedBox(
          width: 105,
          child: Row(
            children: [
              Text('${AppLocalizations.of(context)!.page} -'),
              Expanded(
                  child:
                      Text('${recent.pageNumber}', textAlign: TextAlign.end)),
            ],
          ),
        ),
      ),
    );
  }
}
