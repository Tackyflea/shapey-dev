import 'package:flutter/material.dart';

class KeyBoxKeyed extends StatelessWidget {
  final bool isWholeSecond;
  final bool isHovered;

  const KeyBoxKeyed({
    super.key,
    required this.isWholeSecond,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    late final Color color;
    late final Border borderBox;

    if (!isHovered) {
      color = theme.tertiaryFixed;

      borderBox = Border.all(
        color: theme.tertiary,
        width: 1.0,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignInside,
      );
    } else {
      color = theme.tertiaryFixedDim;
      borderBox = Border.all(
        color: theme.primary,
        width: 2.0,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignCenter,
      );
    }
    return DecoratedBox(
      decoration: BoxDecoration(color: color, border: borderBox),
    );
  }
}
