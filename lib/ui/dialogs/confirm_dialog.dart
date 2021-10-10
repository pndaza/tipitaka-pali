import 'package:flutter/material.dart';

enum OkCancelAction { ok, cancel }

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelLabel;
  final String okLabel;

  const ConfirmDialog(
      {Key? key,
      required this.title,
      required this.message,
      required this.cancelLabel,
      required this.okLabel})
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
              _buildTitle(title, context),
              _buildMessage(message),
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

  Widget _buildTitle(String? title, BuildContext context) {
    return Center(
      child: title == null
          ? Container(
              height: 8.0,
            )
          : Text(title, style: Theme.of(context).textTheme.button),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
        child: Text(
      message,
      textAlign: TextAlign.center,
    ));
  }

  Widget _buildActions(
      {required String cancellabel,
      required String okLabel,
      required BuildContext context}) {
    final buttonStyle = ButtonStyle(
        foregroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor));
    return Row(
      children: [
        Expanded(
            child: TextButton(
          child: Text(cancelLabel),
          style: buttonStyle,
          // textTheme: ButtonTextTheme.accent,
          onPressed: () => Navigator.of(context).pop(OkCancelAction.cancel),
        )),
        Expanded(
            child: TextButton(
          child: Text(okLabel),
          style: buttonStyle,
          onPressed: () => Navigator.of(context).pop(OkCancelAction.ok),
        )),
      ],
    );
  }
}
