/*

import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

class MasterDetailContainer extends StatefulWidget {
  const MasterDetailContainer({
    Key? key,
    required this.master,
    required this.detail,
    this.isDesktop = true,
    this.masterWidth = 300,
  }) : super(key: key);

  final Widget master;
  final Widget detail;
  final bool isDesktop;
  final double masterWidth;

  @override
  State<MasterDetailContainer> createState() => _MasterDetailContainerState();
}

class _MasterDetailContainerState extends State<MasterDetailContainer>
    with TickerProviderStateMixin {
  late final MultiSplitViewController multiSplitViewController;

  @override
  void initState() {
    super.initState();

    multiSplitViewController = MultiSplitViewController(areas: [
      Area(
        size: widget.masterWidth,
        minimalSize: widget.masterWidth,
      )
    ]);
  }

  @override
  void dispose() {
    multiSplitViewController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MasterDetailContainer oldWidget) {
    if (oldWidget.masterWidth != widget.masterWidth) {
      multiSplitViewController.areas = [
        Area(
          size: widget.masterWidth,
          minimalSize: widget.masterWidth,
        )
      ];
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDesktop) {
      return widget.master;
    } else {
      return MultiSplitViewTheme(
        child: MultiSplitView(
            controller: multiSplitViewController,
            children: [
              widget.master,
              widget.detail,
            ],
            resizable: true,
            dividerBuilder:
                (axis, index, resizable, dragging, highlighted, themeData) {
              return Container(
                color: dragging ? Colors.grey[300] : Colors.grey[100],
                width: 16,
                child: Icon(
                  Icons.drag_indicator,
                  color: highlighted ? Colors.grey[600] : Colors.grey[400],
                  size: 16,
                ),
              );
            }),
        data: MultiSplitViewThemeData(dividerThickness: 16),
      );
    }
  }
}
*/