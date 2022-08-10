import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class MasterDetailContainer extends StatelessWidget {
  const MasterDetailContainer({
    Key? key,
    required this.master,
    required this.detail,
    this.isDesktop = true,
  }) : super(key: key);

  final Widget master;
  final Widget detail;
  final bool isDesktop;
  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return master;
    } else {
      return MultiSplitView(
        children: [
          master,
          detail
        ],
        initialAreas: [Area(weight: 0.25)],
      );
    }
  }
}
