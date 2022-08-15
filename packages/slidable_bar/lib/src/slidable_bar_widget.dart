import 'package:flutter/material.dart';

import 'side.dart';
import 'slidable_bar_controller.dart';

class SlidableBar extends StatefulWidget {
  /// [child] is the widget under the bar
  final Widget child;

  /// [side] is enum that detect where you want to position the bar
  final Side side;

  /// [duration] the animation duration
  final Duration duration;

  /// [onChange] will be called each time bar state change
  final ValueChanged<int>? onChange;

  /// [barChildren] are the widgets inside the bar
  // final List<Widget> barChildren;
  final Widget barContent;

  /// [backgroundColor] is the color of the bar
  final Color? backgroundColor;

  /// [frontColor] is the color of the default clicker
  final Color? frontColor;

  /// [curve] is the animation curve
  final Curve curve;

  /// [size] is the height of the bar when side is [Side.top], [Side.bottom]
  /// and it is the width of the bar when side is [Side.right], [Side.left]
  final double size;

  /// [clicker] is the custom clicker
  final Widget? clicker;

  /// [barRadius] is the radius of the bar
  final BorderRadius? barRadius;

  /// [clickerPosition] is the vertical position of the clicker when side is [Side.top], [Side.bottom]
  /// and it is the horizontal position of the clicker when side is [Side.right], [Side.left]
  final double clickerPosition;

  /// [clickerSize] is the size for the default clicker
  final double clickerSize;

  /// [slidableController] to control the bar state
  final SlidableBarController? slidableController;

  const SlidableBar(
      {Key? key,
      required this.child,
      // required this.barChildren,
      required this.barContent,
      required this.size,
      this.frontColor,
      this.clicker,
      this.onChange,
      this.side = Side.right,
      this.duration = const Duration(milliseconds: 300),
      this.backgroundColor,
      this.clickerPosition = 0.0,
      this.clickerSize = 55,
      this.curve = Curves.linear,
      this.slidableController,
      this.barRadius})
      : super(key: key);

  @override
  _SlidableSideBarState createState() => _SlidableSideBarState();
}

class _SlidableSideBarState extends State<SlidableBar> {
  late SlidableBarController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.slidableController ?? SlidableBarController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: controller.statusStream,
        initialData: controller.initialStatus,
        builder: (context, snapshot) {
          final isOpened = snapshot.data!;
          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(child: widget.child),
              if (widget.clicker == null)
                AnimatedPositioned(
                  right: [Side.bottom, Side.top].contains(widget.side)
                      ? 0
                      : widget.side == Side.right
                          ? isOpened
                              ? widget.size - (widget.clickerSize * 0.54)
                              : -(widget.clickerSize * 0.54)
                          : null,
                  left: [Side.bottom, Side.top].contains(widget.side)
                      ? 0
                      : widget.side == Side.left
                          ? isOpened
                              ? widget.size - (widget.clickerSize * 0.54)
                              : -(widget.clickerSize * 0.54)
                          : null,
                  bottom: [Side.right, Side.left].contains(widget.side)
                      ? 0
                      : widget.side == Side.bottom
                          ? isOpened
                              ? widget.size - (widget.clickerSize * 0.54)
                              : -(widget.clickerSize * 0.54)
                          : null,
                  top: [Side.right, Side.left].contains(widget.side)
                      ? 0
                      : widget.side == Side.top
                          ? isOpened
                              ? widget.size - (widget.clickerSize * 0.54)
                              : -(widget.clickerSize * 0.54)
                          : null,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: Align(
                    alignment: Alignment(
                        widget.clickerPosition, widget.clickerPosition),
                    child: RotationTransition(
                      turns: AlwaysStoppedAnimation((widget.side == Side.right
                              ? 315
                              : widget.side == Side.left
                                  ? 135
                                  : widget.side == Side.bottom
                                      ? 45
                                      : 225) /
                          360),
                      child: InkWell(
                        onTap: () => controller.reverseStatus(),
                        child: Container(
                          width: widget.clickerSize,
                          height: widget.clickerSize,
                          decoration: BoxDecoration(
                              color: widget.backgroundColor ??
                                  Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(7)),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    spreadRadius: 1,
                                    blurRadius: 5),
                              ]),
                          alignment: Alignment.topLeft,
                          child: Container(
                            width: widget.clickerSize * 0.23,
                            height: widget.clickerSize * 0.23,
                            margin: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                                color: widget.frontColor ??
                                    Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              AnimatedPositioned(
                  right: widget.side == Side.right
                      ? isOpened
                          ? 0
                          : -widget.size
                      : widget.side == Side.left
                          ? null
                          : 0,
                  top: widget.side == Side.top
                      ? isOpened
                          ? 0
                          : -widget.size
                      : widget.side == Side.bottom
                          ? null
                          : 0,
                  bottom: widget.side == Side.bottom
                      ? isOpened
                          ? 0
                          : -widget.size
                      : widget.side == Side.top
                          ? null
                          : 0,
                  left: widget.side == Side.left
                      ? isOpened
                          ? 0
                          : -widget.size
                      : widget.side == Side.right
                          ? null
                          : 0,
                  duration: widget.duration,
                  curve: widget.curve,
                  child: _SideBarContent(
                      // children: widget.barChildren,
                      barContent: widget.barContent,
                      isOpen: isOpened,
                      width: widget.size,
                      onChange: widget.onChange,
                      controller: controller,
                      clicker: widget.clicker,
                      backgroundColor: widget.backgroundColor,
                      clickerPosition: widget.clickerPosition,
                      side: widget.side,
                      barRadius: widget.barRadius)),
            ],
          );
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _SideBarContent extends StatelessWidget {
  // final List<Widget> children;
  final Widget barContent;
  final Color? backgroundColor;
  final bool isOpen;
  final double width;
  final Widget? clicker;
  final ValueChanged<int>? onChange;
  final SlidableBarController controller;
  final double clickerPosition;
  final Side side;
  final BorderRadius? barRadius;

  const _SideBarContent({
    Key? key,
    // required this.children,
    required this.barContent,
    required this.isOpen,
    required this.width,
    required this.controller,
    required this.backgroundColor,
    required this.onChange,
    required this.clicker,
    required this.clickerPosition,
    required this.side,
    required this.barRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: [Side.left, Side.right].contains(side) ? width : null,
      height: [Side.left, Side.right].contains(side) ? null : width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 5),
        ],
        color: backgroundColor ?? Theme.of(context).colorScheme.onBackground,
        borderRadius: barRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: barContent,
      // child: ListView.builder(
      //   itemCount: children.length,
      //   scrollDirection: [Side.right, Side.left].contains(side)
      //       ? Axis.vertical
      //       : Axis.horizontal,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       onTap: () {
      //         controller.hide();
      //         onChange?.call(index);
      //       },
      //       child: children[index],
      //     );
      //   },
      // ),
    );
    final customClicker = Align(
        alignment: Alignment(clickerPosition, clickerPosition),
        child: GestureDetector(
            onTap: () => controller.reverseStatus(), child: clicker));
    if ([Side.left, Side.right].contains(side)) {
      return Row(
        children: [
          if (clicker != null && side == Side.right) customClicker,
          body,
          if (clicker != null && side == Side.left) customClicker
        ],
      );
    } else {
      return Column(
        children: [
          if (clicker != null && side == Side.bottom) customClicker,
          body,
          if (clicker != null && side == Side.top) customClicker
        ],
      );
    }
  }
}
