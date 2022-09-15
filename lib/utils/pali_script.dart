import 'package:tipitaka_pali/utils/roman_to_sinhala.dart';

import './mm_pali.dart';
import './pali_script_converter.dart';

class PaliScript {
  // pali word not inside html tag
  static final _regexPaliWord =
      RegExp(r'[0-9a-zA-ZāīūṅñṭḍṇḷṃĀĪŪṄÑṬḌHṆḶṂ\.]+(?![^<>]*>)');
  PaliScript._();
  static String getScriptOf({
    required Script script,
    required String romanText,
    bool isHtmlText = false,
  }) {
    if (romanText.isEmpty) return romanText;

    if (script == Script.myanmar) {
      if (!isHtmlText) {
        return MmPali.fromRoman(romanText);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord, (match) => MmPali.fromRoman(match.group(0)!));
      }
    } else if (script == Script.devanagari) {
      if (!isHtmlText) {
        return toDeva(romanText);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord, (match) => toDeva(match.group(0)!));
      }
    } else if (script == Script.sinhala) {
      if (!isHtmlText) {
        return TextProcessor.convertFrom(romanText, Script.roman);
      } else {
        return romanText.replaceAllMapped(
            _regexPaliWord,
            (match) =>
                TextProcessor.convertFrom(match.group(0)!, Script.roman));
      }
    } else {
      // janaka's converter is based on sinhala
      // cannot convert from roman to other lanuguage directly
      // so convert to sinhal fist and then convert to other
      if (!isHtmlText) {
        final sinhala = TextProcessor.convertFrom(romanText, Script.roman);
        return TextProcessor.convert(sinhala, script);
      } else {
        return romanText.replaceAllMapped(_regexPaliWord, (match) {
          final sinhala =
              TextProcessor.convertFrom(match.group(0)!, Script.roman);
          return TextProcessor.convert(sinhala, script);
        });
      }
    }
  }

  static String getRomanScriptFrom(
      {required Script script, required String text}) {
    if (script == Script.myanmar) {
      return MmPali.toRoman(text);
    } else if (script == Script.sinhala) {
      return TextProcessor.convert(text, Script.roman);
    } else {
      // janaka's converter is based on sinhala
      // cannot convert from other lanuguage to roman directly
      // so convert to sinhal fist and then convert to roman
      final sinhala = TextProcessor.convertFrom(text, script);
      return TextProcessor.convert(sinhala, Script.roman);
    }
  }
}
