import 'package:flutter/material.dart';

class SimpleInputDialog extends StatelessWidget {
  final String hintText;
  final String cancelLabel;
  final String okLabel;
  final TextEditingController _controller = TextEditingController();

  SimpleInputDialog(
      {Key key, this.hintText, this.cancelLabel, this.okLabel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          side: BorderSide.none, borderRadius: BorderRadius.circular(16.0)),
      elevation: 10.0,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16.0),
        child: Wrap(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTextField(hintText),
              Container(
                height: 16.0,
              ),
              _buildActions(
                  cancellabel: cancelLabel, okLabel: okLabel, context: context)
            ],
          ),
        ]),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), gapPadding: 0.0),
        ),
        maxLines: null,
        maxLength: 50,
        // autofocus: true,
    );
  }

  Widget _buildActions(
      {String cancellabel, String okLabel, BuildContext context}) {
    return Row(
      children: [
        Expanded(
            child: FlatButton(
          child: Text(cancelLabel),
              textTheme: ButtonTextTheme.accent,
          onPressed: () => Navigator.of(context).pop(),
        )),
        Expanded(
            child: FlatButton(
          child: Text(okLabel),
          textTheme: ButtonTextTheme.accent,
          onPressed: () => Navigator.of(context).pop(_controller.text),
        )),
      ],
    );
  }
}
