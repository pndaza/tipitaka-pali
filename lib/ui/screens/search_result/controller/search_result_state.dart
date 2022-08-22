import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../business_logic/models/search_result.dart';

part 'search_result_state.freezed.dart';

@freezed
class SearchResultState with _$SearchResultState {
  const factory SearchResultState.loading() = _Loading;
  const factory SearchResultState.loaded(List<SearchResult> results, int bookCount) = _Loaded;
  const factory SearchResultState.noData() = _NoData;
}
