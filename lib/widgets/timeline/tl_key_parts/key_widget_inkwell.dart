import 'package:flutter/material.dart';

import 'key_box_default.dart';
import 'key_box_keyed.dart';

class KeyWidgetInkwell extends StatelessWidget {
  final GestureTapDownCallback? rightClickAction;
  final ValueChanged<bool>? HoverAction;
  final bool isHovered;
  final bool isWholeSecond;
  final bool isKeyed;
  const KeyWidgetInkwell({
    super.key,
    required this.rightClickAction,
    required this.HoverAction,
    required this.isWholeSecond,
    required this.isHovered,
    required this.isKeyed,
  });

  @override
  Widget build(BuildContext context) {
    final StatelessWidget boxToShow;
    if (!isKeyed) {
      boxToShow = KeyBoxDefault(
        isWholeSecond: isWholeSecond,
        isHovered: isHovered,
      );
    } else {
      boxToShow = KeyBoxKeyed(
        isWholeSecond: isWholeSecond,
        isHovered: isHovered,
      );
    }

    return InkWell(
      onSecondaryTapDown: rightClickAction,
      onHover: HoverAction,
      child: boxToShow,
    );
  }
}
