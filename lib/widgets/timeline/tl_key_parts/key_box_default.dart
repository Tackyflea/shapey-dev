import 'package:flutter/material.dart';

class KeyBoxDefault extends StatelessWidget {
  final bool isWholeSecond;
  final bool isHovered;
  const KeyBoxDefault({
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
      color = isWholeSecond ? theme.surfaceContainerHighest : theme.onSecondary;

      borderBox = Border.all(
        color: theme.surfaceContainerHighest,
        width: 1.0,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignCenter,
      );
    } else {
      color = theme.inversePrimary;

      borderBox = Border.all(
        color: theme.primary,
        width: 1.0,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignCenter,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(color: color, border: borderBox),
    );
  }
}
