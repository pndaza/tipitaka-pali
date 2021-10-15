import 'package:flutter/material.dart';
import 'colored_text.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final GestureTapCallback? onPressed;

  const IconTextButton(
      {Key? key, required this.icon, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 10),
          ColoredText(text),
        ],
      ),
    );
  }
}
