import 'package:flutter/material.dart';

class EasyNumberInput extends StatefulWidget {
  const EasyNumberInput(
      {Key? key, required this.initial, required this.onChanged})
      : super(key: key);
  final int initial;
  final Function(int) onChanged;

  @override
  State<EasyNumberInput> createState() => _EasyNumberInputState();
}

class _EasyNumberInputState extends State<EasyNumberInput> {
  late int value;
  @override
  void initState() {
    value = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              widget.onChanged(--value);
            });
          },
          icon: const Icon(Icons.remove),
        ),
        Text(value.toString()),
        IconButton(
          onPressed: () {
            setState(() {
              widget.onChanged(++value);
            });
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
