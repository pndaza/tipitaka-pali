import 'package:flutter/material.dart';

import '../../../../utils/pali_tools.dart';
import '../../../../utils/script_detector.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) onSubmitted;
  final void Function(String) onTextChanged;
  final String hint;
  const SearchBar(
      {Key? key, required this.onSubmitted,
      required this.onTextChanged,
      this.hint = 'search'}) : super(key: key);

  @override
  _SearchBarState createState() =>
      _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState();

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
        _showClearButton = controller.text.isNotEmpty;
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
              onSubmitted: (text) => widget.onSubmitted(text),
              onChanged: (text) {
                final scriptLanguage = ScriptDetector.getLanguage(text);
                if (scriptLanguage == 'Roman') text = _toUni(text);
                widget.onTextChanged(text);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  // suffix: keyBoardButton(),
                  suffixIcon: clearButton(),
                  hintStyle: const TextStyle(color: Colors.grey),
                  hintText: widget.hint,
                  fillColor: Colors.white70),
            ),
          ),
          const SizedBox(
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
      icon: const Icon(
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
      icon: const Icon(
        Icons.keyboard,
        color: Colors.grey,
      ),
    );
  }

  String _toUni(String input) {
    input = PaliTools.velthuisToUni(velthiusInput: input);

    controller.text = input;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length));

    return input;
  }
}
