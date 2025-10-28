import 'package:flutter/material.dart';

class TLHeadlineKeyBar extends StatelessWidget {
  final double horisontalMargin;
  final String barText;
  const TLHeadlineKeyBar({
    super.key,
    required this.horisontalMargin,
    required this.barText,
  });

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var fontSize = Theme.of(context).textTheme.bodySmall?.fontSize;

    final boxBorder = Border.all(
      color: colorScheme.secondaryContainer,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              barText,
              textAlign: TextAlign.center,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
              left: horisontalMargin,
              top: 3,
              right: horisontalMargin,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              border: boxBorder,
            ),
          ),
        ),
      ],
    );
  }
}
