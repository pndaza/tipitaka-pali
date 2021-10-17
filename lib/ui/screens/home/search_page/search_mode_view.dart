import 'package:flutter/material.dart';

import 'search_page.dart';

class SearchModeView extends StatefulWidget {
  const SearchModeView({Key? key, required this.mode, required this.onChanged})
      : super(key: key);
  final QueryMode mode;
  final Function(QueryMode) onChanged;

  @override
  State<SearchModeView> createState() => _SearchModeViewState();
}

class _SearchModeViewState extends State<SearchModeView> {
  late QueryMode currentQueryMode;

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
              title: const Text('Exact'),
              value: QueryMode.exact,
              groupValue: currentQueryMode,
              onChanged: (value) {
                _onChanged(value);
              }),
          RadioListTile<QueryMode>(
              title: const Text('Prefix'),
              value: QueryMode.prefix,
              groupValue: currentQueryMode,
              onChanged: (value) {
                _onChanged(value);
              }),
          RadioListTile<QueryMode>(
              title: const Text('Distance'),
              value: QueryMode.distance,
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
      widget.onChanged(mode);
      setState(() {
        currentQueryMode = mode;
      });
    }
  }
}