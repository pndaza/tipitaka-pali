import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:word_selectable_text/word_selectable_text.dart';

import '../../../../services/prefs.dart';
import '../controller/dictionary_state.dart';
import '../controller/dictionary_controller.dart';

class DictionaryContentView extends StatelessWidget {
  const DictionaryContentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.select<DictionaryViewModel, DictionaryState>(
        (DictionaryViewModel vm) => vm.dictionaryState);

    return state.when(
        initial: () => Container(),
        loading: () => const SizedBox(
            height: 100, child: Center(child: CircularProgressIndicator())),
        data: (content) => SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  content,
                  textStyle: TextStyle(fontSize: Prefs.fontSize.toDouble()),
                  factoryBuilder: () => _MyFactory(
                    onClicked: (word) {
                      print(word);
                      context.read<DictionaryViewModel>().onWordClicked(word);
                    },
                  ),
                  //isSelectable: true,
                  //onSelectionChanged: (selection, cause) {
                  //  print(selection);
                  //},
                ))),
        noData: () => const SizedBox(
              height: 100,
              child: Center(child: Text('Not found')),
            ));
  }
}

typedef WordChanged = void Function(String word);

class _MyFactory extends WidgetFactory {
  /// Controls whether text is rendered with [SelectableText] or [RichText].
  ///
  /// Default: `true`.
  bool get selectableText => true;

  /// The callback when user changes the selection of text.
  ///
  /// See [SelectableText.onSelectionChanged].
  SelectionChangedCallback? get selectableTextOnChanged => null;
  WordChanged? onClicked;
  _MyFactory({this.onClicked});

  @override
  Widget? buildText(BuildMetadata meta, TextStyleHtml tsh, InlineSpan text) {
    if (selectableText &&
        meta.overflow == TextOverflow.clip &&
        text is TextSpan) {
      /*
      return SelectableText.rich(
        text,
        maxLines: meta.maxLines > 0 ? meta.maxLines : null,
        textAlign: tsh.textAlign ?? TextAlign.start,
        textDirection: tsh.textDirection,
        onSelectionChanged: (selection, cause) {
          /*
          final int start = selection.baseOffset;
          final int end = selection.extentOffset;
          debugPrint('baseOffset: $start');
          debugPrint('extendedOffset: $end');
          */
        },
      );
      */
      if (text.text == null) {
        return SelectableText.rich(
          text,
          maxLines: meta.maxLines > 0 ? meta.maxLines : null,
          textAlign: tsh.textAlign ?? TextAlign.start,
        );
      }

      String inlineText = text.text!;
      // inlineText = inlineText.replaceAll('+', ' + '); // add space between +
       // add space before + if not exist
      inlineText = inlineText.replaceAllMapped(RegExp(r'(?<!\s)\+'), (match) => ' +');
       // add space after + if not exist
      inlineText = inlineText.replaceAllMapped(RegExp(r'\+(?!\s)'), (match) => '+ ');
       // add space after . if not exist
      inlineText = inlineText.replaceAllMapped(RegExp(r'\.(?!\s)'), (match) => '. ');

      return WordSelectableText(
        text: inlineText,
        selectable: false,
        highlight: false,
        onWordTapped: (word, index) {
          onClicked?.call(word);
        },
      );
    }

    return super.buildText(meta, tsh, text);
  }
}