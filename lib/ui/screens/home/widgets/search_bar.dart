import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) onSubmitted;
  final void Function(String) onTextChanged;
  final String hint;
  SearchBar(
      {required this.onSubmitted,
      required this.onTextChanged,
      this.hint = 'search'});

  @override
  _SearchBarState createState() =>
      _SearchBarState(onSubmitted, onTextChanged, hint);
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState(this.onSummited, this.onTextChanged, this.hint);

  final void Function(String) onSummited;
  final void Function(String) onTextChanged;
  final String hint;
  bool _showClearButton = false;

  Color borderColor = Colors.grey;
  Color textColor = Colors.grey[350] as Color;
  TextDecoration textDecoration = TextDecoration.lineThrough;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        _showClearButton = controller.text.length > 0;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(color: Colors.grey),
      ),
      height: 56.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (text) => onSummited(text),
              onChanged: (text) => onTextChanged(toUni(text)),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  // suffix: keyBoardButton(),
                  suffixIcon: clearButton(),
                  hintStyle: new TextStyle(color: Colors.grey),
                  hintText: hint,
                  fillColor: Colors.white70),
            ),
          ),
          SizedBox(
            width: 4.0,
          )
        ],
      ),
    );
  }

  Widget? clearButton() {
    if (!_showClearButton) {
      return null;
    }
    return IconButton(
      onPressed: () {
        controller.clear();
      },
      icon: Icon(
        Icons.clear,
        color: Colors.grey,
      ),
    );
  }

  Widget? keyBoardButton() {
    if (!_showClearButton) {
      return null;
    }
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Icons.keyboard,
        color: Colors.grey,
      ),
    );
  }

  String toUni(String input) {
    if (input == '') return input;

    var nigahita = 'ṃ';
    var capitalNigahita = 'Ṃ';

    input = input
        .replaceAll('aa', 'ā')
        .replaceAll('ii', 'ī')
        .replaceAll('uu', 'ū')
        .replaceAll('\.t', 'ṭ')
        .replaceAll('\.d', 'ḍ')
        .replaceAll('\"nk', 'ṅk')
        .replaceAll('\"ng', 'ṅg')
        .replaceAll('\.n', 'ṇ')
        .replaceAll('\.m', nigahita)
        .replaceAll('\u1E41', nigahita)
        .replaceAll('\~n', 'ñ')
        .replaceAll('\.l', 'ḷ')
        .replaceAll('AA', 'Ā')
        .replaceAll('II', 'Ī')
        .replaceAll('UU', 'Ū')
        .replaceAll('\.T', 'Ṭ')
        .replaceAll('\.D', 'Ḍ')
        .replaceAll('\"N', 'Ṅ')
        .replaceAll('\.N', 'Ṇ')
        .replaceAll('\.M', capitalNigahita)
        .replaceAll('\~N', 'Ñ')
        .replaceAll('\.L', 'Ḷ')
        .replaceAll('\.ll', 'ḹ')
        .replaceAll('\.r', 'ṛ')
        .replaceAll('\.rr', 'ṝ')
        .replaceAll('\.s', 'ṣ')
        .replaceAll('"s', 'ś')
        .replaceAll('\.h', 'ḥ');

    controller.text = input;
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));


    return input;
  }
}
