import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final void Function(String) onSubmitted;
  final void Function(String) onTextChanged;
  final String hint;
  SearchBar({required this.onSubmitted, required this.onTextChanged, this.hint = 'ရှာလိုရာ စကားလုံး ရိုက်ပါ'});

  @override
  _SearchBarState createState() => _SearchBarState(onSubmitted, onTextChanged, hint);
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState(this.onSummited, this.onTextChanged, this.hint);

  final void Function(String) onSummited;
  final void Function(String) onTextChanged;
  final String hint;
  bool _showClearButton = false;

  Color borderColor = Colors.grey;
  Color textColor = Colors.grey[350] as  Color;
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
              onChanged: (text) => onTextChanged(text),
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
      onPressed: () {
      },
      icon: Icon(
        Icons.keyboard,
        color: Colors.grey,
      ),
    );
  }
}
