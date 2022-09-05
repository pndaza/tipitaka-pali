import 'package:flutter/material.dart';

class TabCountIcon extends StatelessWidget {
  const TabCountIcon({
    required this.count,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.circle,
      onTap: onPressed,
      child: SizedBox(
        width: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 18,
              decoration: BoxDecoration(
                border: Border.all(
                    color: IconTheme.of(context).color ?? Colors.white,
                    width: 2),
                borderRadius: const BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.5),
                child: Center(
                  child: Opacity(
                    opacity: count == 0 ? 0 : 1,
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
