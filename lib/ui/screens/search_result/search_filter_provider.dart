import 'package:flutter/material.dart';

class SearchFilterController extends ChangeNotifier {
  final Map<String, String> _mainCategoryFilters = const {
    'mula': 'Mūla',
    'attha': 'Aṭṭhakathā',
    'tika': 'Ṭīka',
    'annya': 'Annya'
  };
  final Map<String, String> _subCategoryFilters = const {
    '_vi': 'Vinaya',
    '_di': 'Dīgha',
    '_ma': 'Majjhima',
    '_sa': 'Saṃyutta',
    '_an': 'Aṅguttara',
    '_ku': 'Khuddaka',
    '_bi': 'Abhidhamma'
  };
  Map<String, String> get mainCategoryFilters => _mainCategoryFilters;
  Map<String, String> get subCategoryFilters => _subCategoryFilters;

  late final _selectedMainCategoryFilters;
  late final _selectedSubCategoryFilters;

  List<String> get selectedMainCategoryFilters => _selectedMainCategoryFilters;
  List<String> get selectedSubCategoryFilters => _selectedSubCategoryFilters;

  SearchFilterController(){
    _selectedMainCategoryFilters = mainCategoryFilters.keys.toList();
    _selectedSubCategoryFilters = subCategoryFilters.keys.toList();
  }

  void onMainFilterChange(String filterID, bool isSelected) {
    if (isSelected) {
      _selectedMainCategoryFilters.add(filterID);
    } else {
      _selectedMainCategoryFilters.remove(filterID);
    }
    notifyListeners();
  }
  void onSubFilterChange(String filterID, bool isSelected) {
    if (isSelected) {
      _selectedSubCategoryFilters.add(filterID);
    } else {
      _selectedSubCategoryFilters.remove(filterID);
    }
    notifyListeners();
  }
}
