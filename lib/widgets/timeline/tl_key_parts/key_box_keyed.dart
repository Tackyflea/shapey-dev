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
    final theme = Theme.of(context).colorScheme;

    final color = isHovered ? theme.tertiaryFixedDim : theme.tertiaryFixed;
    final borderColor = isHovered ? theme.primary : theme.tertiary;
    final borderWidth = isHovered ? 2.0 : 1.0;
    final strokeAlign = isHovered
        ? BorderSide.strokeAlignCenter
        : BorderSide.strokeAlignInside;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
          strokeAlign: strokeAlign,
        ),
      ),
    );
  }
}
