import 'package:flutter/material.dart';

class TLHeadlineKeyHalfBar extends StatelessWidget {
  final double horisontalMargin;
  final double barHeight;
  const TLHeadlineKeyHalfBar({
    super.key,
    required this.horisontalMargin,
    required this.barHeight,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    final boxBorder = Border.all(
      color: colorScheme.secondaryContainer,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    return Container(
      margin: EdgeInsets.fromLTRB(
        horisontalMargin,
        barHeight,
        horisontalMargin,
        0,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryFixedDim,
        border: boxBorder,
      ),
    );
  }
}
