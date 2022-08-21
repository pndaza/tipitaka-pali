
import 'package:freezed_annotation/freezed_annotation.dart';

part "dictionary_state.freezed.dart";
@freezed
class  DictionaryState with _$DictionaryState {
const factory DictionaryState.initial() = _Initial;
const factory DictionaryState.loading() = _Loading;
const factory DictionaryState.data(String content) = _Loaded;
const factory DictionaryState.noData() = _NoData;
}