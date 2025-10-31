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
    final theme = Theme.of(context).colorScheme;

    final color = isHovered
        ? theme.inversePrimary
        : (isWholeSecond ? theme.surfaceContainerHighest : theme.onSecondary);
    final borderColor = isHovered
        ? theme.primary
        : theme.surfaceContainerHighest;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 1.0),
      ),
    );
  }
}
