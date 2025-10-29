import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'key_box_default.dart';
import 'key_box_keyed.dart';

class KeyWidget extends StatelessWidget {
  final GestureTapUpCallback? rightClickAction;
  final PointerHoverEventListener? HoverAction;
  final PointerExitEventListener? HoverEndAction;
  final bool isHovered;
  final bool isWholeSecond;
  final bool isKeyed;
  const KeyWidget({
    super.key,
    required this.rightClickAction,
    required this.HoverAction,
    required this.HoverEndAction,
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

    return GestureDetector(
      onSecondaryTapUp: rightClickAction,
      child: MouseRegion(
        onHover: HoverAction,
        onExit: HoverEndAction,
        child: boxToShow,
      ),
    );
  }
}
