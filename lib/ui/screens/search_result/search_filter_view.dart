import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './search_filter_provider.dart';

class SearchFilterView extends StatelessWidget {
  SearchFilterView({
    Key? key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final notifier = context.watch<SearchFilterController>();
    final closeButton = Positioned(
        top: -18,
        child: GestureDetector(
          onTap: ()=> Navigator.pop(context),
          child: ClipOval(
            child: Container(
              width: 56,
              height: 56,
              color: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ));

    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            // height: 200,
            // color: Colors.brown,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(height: 22),
                _buildMainCategoryFilter(notifier),
                _buildSubCategoryFilters(notifier),
              ],
            ),
          ),
          closeButton,
        ]);
  }

  Widget _buildMainCategoryFilter(SearchFilterController notifier) {
    print('building main filter');
    final _mainCategoryFilters = notifier.mainCategoryFilters;
    final _selectedMainCategoryFilters = notifier.selectedMainCategoryFilters;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Wrap(
            children: _mainCategoryFilters.entries
                .map((e) => FilterChip(
                    label: Text(e.value),
                    selectedColor: Colors.lightBlueAccent,
                    selected: _selectedMainCategoryFilters.contains(e.key),
                    onSelected: (isSelected) {
                      notifier.onMainFilterChange(e.key, isSelected);
                    }))
                .toList()),
      ),
    );
  }

  Widget _buildSubCategoryFilters(SearchFilterController notifier) {
    final _subCategoryFilters = notifier.subCategoryFilters;
    final _selectedSubCategoryFilters = notifier.selectedSubCategoryFilters;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Wrap(
            children: _subCategoryFilters.entries
                .map((e) => FilterChip(
                    label: Text(e.value),
                    selectedColor: Colors.lightBlueAccent,
                    selected: _selectedSubCategoryFilters.contains(e.key),
                    onSelected: (isSelected) {
                      notifier.onSubFilterChange(e.key, isSelected);
                    }))
                .toList()),
      ),
    );
  }
}
