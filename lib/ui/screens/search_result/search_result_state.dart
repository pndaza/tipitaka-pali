import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result_state.freezed.dart';

@freezed
class SearchResultState with _$SearchResultState {
  const factory SearchResultState.loading() = _Loading;
  const factory SearchResultState.loaded(List<Index> results, int bookCount) = _Loaded;
  const factory SearchResultState.noData() = _NoData;
}
