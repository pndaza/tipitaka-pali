import 'package:flutter/material.dart';

enum OkCancelAction { OK, CANCEL }

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String cancelLabel;
  final String okLabel;

  const ConfirmDialog(
      {Key key, this.title, this.message, this.cancelLabel, this.okLabel})
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

  Widget _buildTitle(String title, BuildContext context) {
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
      {String cancellabel, String okLabel, BuildContext context}) {
    return Row(
      children: [
        Expanded(
            child: FlatButton(
          child: Text(cancelLabel),
          textTheme: ButtonTextTheme.accent,
          onPressed: () => Navigator.of(context).pop(OkCancelAction.CANCEL),
        )),
        Expanded(
            child: FlatButton(
          child: Text(okLabel),
          textTheme: ButtonTextTheme.accent,
          onPressed: () => Navigator.of(context).pop(OkCancelAction.OK),
        )),
      ],
    );
  }
}
