import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

enum GotoType { page, paragraph }

class GotoDialogResult {
  final int number;
  final GotoType type;
  GotoDialogResult(this.number, this.type);
}

class GotoDialog extends StatefulWidget {
  final int firstPage;
  final int lastPage;
  final int firstParagraph;
  final int lastParagraph;
  final double radius;

  GotoDialog(
      { Key? key,
      required this.firstPage,
      required this.lastPage,
      required this.firstParagraph,
      required this.lastParagraph,
      this.radius = 16.0})
      : super(key: key);

  @override
  _GotoDialogState createState() => _GotoDialogState(
      firstPage: firstPage,
      lastPage: lastPage,
      firstParagraph: firstParagraph,
      lastParagraph: lastParagraph,
      radius: radius);
}

class _GotoDialogState extends State<GotoDialog> {
  final int firstPage;
  final int lastPage;
  final int firstParagraph;
  final int lastParagraph;
  final double radius;
  TextEditingController controller = TextEditingController();
  GotoType selectedType = GotoType.page;
  int? selectedTypeIndex;
  String? hintText;
  bool isValid = false;

  _GotoDialogState(
      {required this.firstPage,
      required this.lastPage,
      required this.firstParagraph,
      required this.lastParagraph,
      required this.radius});

  @override
  void initState() {
    super.initState();
    hintText = 'page ($firstPage-$lastPage)';
    selectedTypeIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Dialog(
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.circular(widget.radius)),
          elevation: 10.0,
          child: dialogContent(),
        ),
      ),
    );
  }

  Widget dialogContent() {
    return Container(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildTitle(),
          Divider(),
          _buildInputType(context),
          _buildInputField(),
          _buildActions(context)
        ],
      ),
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        'Goto',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );
  }

  ToggleSwitch _buildInputType(BuildContext context) {
    return ToggleSwitch(
      totalSwitches: 2,
      labels: ['page', 'paragraph'],
      initialLabelIndex: selectedTypeIndex!,
      onToggle: (index) {
        setState(() {
          selectedTypeIndex = index;
          if (index == 0) {
            selectedType = GotoType.page;
            hintText = 'page ($firstPage-$lastPage)';
          } else {
            selectedType = GotoType.paragraph;
            hintText = 'paragraph ($firstParagraph-$lastParagraph)';
          }
        });
      },
      // activeBgColor: Theme.of(context).accentColor,
      minWidth: 100.0,
    );
  }

  Padding _buildInputField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: hintText),
        onChanged: _validate,
        keyboardType: TextInputType.number,
        autofocus: true,
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.spaceEvenly,
      buttonTextTheme: ButtonTextTheme.accent,
      buttonMinWidth: 120.0,
      children: [
        TextButton(
          child: Text(
            'Cancel',
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
            child: Text(
              'Go',
            ),
            onPressed: !isValid
                ? null
                : () {
                    final result = GotoDialogResult(
                        int.parse(controller.text), selectedType);
                    Navigator.pop(context, result);
                  }),
      ],
    );
  }

  void _validate(String input) {
    setState(() {
      if (input.isEmpty) {
        isValid = false;
      } else {
        final inputNumber = int.parse(input);
        switch (selectedType) {
          case GotoType.page:
            isValid = _isPageNumberValid(inputNumber);
            break;
          case GotoType.paragraph:
            isValid = _isParagraphNumberValid(inputNumber);
            break;
        }
      }
    });
  }

  bool _isPageNumberValid(int pageNumber) {
    return firstPage <= pageNumber && pageNumber <= lastPage;
  }

  bool _isParagraphNumberValid(int paragraphNumber) {
    return firstParagraph <= paragraphNumber &&
        paragraphNumber <= lastParagraph;
  }
}
