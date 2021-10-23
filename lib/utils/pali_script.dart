import 'package:tipitaka_pali/utils/roman_to_sinhala.dart';

import './mm_pali.dart';

class PaliScript {
  // pali word not inside html tag
  static final _regexPaliWord =
      RegExp(r'[0-9a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ\.]+(?![^<>]*>)');
  PaliScript._();
  static String getScriptOf(
      {required String language,
      required String romanText,
      bool isHtmlText = false}) {
    if (romanText.isEmpty) return romanText;

    if (language == 'မြန်မာ') {
      if (!isHtmlText) {
        return MmPali.fromRoman(romanText);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord, (match) => MmPali.fromRoman(match.group(0)!));
      }
    }

    if (language == 'සිංහල') {
      if (!isHtmlText) {
        return toSin(romanText);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord, (match) => toSin(match.group(0)!));
      }
    }

        if (language == 'देवनागरी') {
      if (!isHtmlText) {
        return toDeva(romanText);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord, (match) => toDeva(match.group(0)!));
      }
    }

    return romanText;
  }

  static String getRomanScriptFrom(
      {required String language, required String text}) {
    if (language == 'မြန်မာ') {
      return MmPali.toRoman(text);
    }
    if (language == 'සිංහල') {
      return fromSin(text);
    }

    return text;
  }
}
