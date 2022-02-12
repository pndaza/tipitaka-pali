import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tipitaka_pali/ui/screens/home/search_page/easy_number_input.dart';

import 'search_page.dart';

class SearchModeView extends StatefulWidget {
  const SearchModeView(
      {Key? key,
      required this.mode,
      required this.wordDistance,
      required this.onModeChanged,
      required this.onDistanceChanged})
      : super(key: key);
  final QueryMode mode;
  final int wordDistance;
  final Function(QueryMode) onModeChanged;
  final Function(int) onDistanceChanged;

  @override
  State<SearchModeView> createState() => _SearchModeViewState();
}

class _SearchModeViewState extends State<SearchModeView> {
  late QueryMode currentQueryMode;
  late int wordDistance;

  @override
  void initState() {
    super.initState();
    currentQueryMode = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.primary.withAlpha(220),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<QueryMode>(
              title: Text(AppLocalizations.of(context)!.exact),
              value: QueryMode.exact,
              groupValue: currentQueryMode,
              onChanged: (value) {
                _onChanged(value);
              }),
          RadioListTile<QueryMode>(
              title: Text(AppLocalizations.of(context)!.prefix),
              value: QueryMode.prefix,
              groupValue: currentQueryMode,
              onChanged: (value) {
                _onChanged(value);
              }),
          Row(
            children: [
              Expanded(
                child: RadioListTile<QueryMode>(
                  title: Text(AppLocalizations.of(context)!.distance),
                  value: QueryMode.distance,
                  groupValue: currentQueryMode,
                  onChanged: (value) {
                    _onChanged(value);
                  },
                ),
              ),
              EasyNumberInput(
                  initial: widget.wordDistance,
                  onChanged: (value) {
                    widget.onDistanceChanged(value);
                  }),
              // right margin
              const SizedBox(width: 16)
            ],
          ),
          RadioListTile<QueryMode>(
              title: Text(AppLocalizations.of(context)!.anywhere),
              value: QueryMode.anywhere,
              groupValue: currentQueryMode,
              onChanged: (value) {
                _onChanged(value);
              }),
        ],
      ),
    );
  }

  void _onChanged(QueryMode? mode) {
    if (mode != null) {
      widget.onModeChanged(mode);
      setState(() {
        currentQueryMode = mode;
      });
    }
  }
}
