//  header bg
import 'package:flutter/material.dart';

import 'tl_headline_key_bar.dart';
import 'tl_headline_key_half_bar.dart';

class TLHeadline extends StatelessWidget {
  final int frameNumber;
  final double fps;
  final double height;
  final double width;
  final ColorScheme colorScheme;
  const TLHeadline({
    super.key,
    required this.width,
    required this.height,
    required this.frameNumber,
    required this.fps,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final horisontalMargin = width * 0.3;

    final bool isWholeSecond = frameNumber.toDouble() % fps == 0;
    //custom color for second
    if (isWholeSecond) {
      var textData = (frameNumber.toDouble() / fps).toInt().toString();
      return TLHeadlineKeyBar(
        horisontalMargin: horisontalMargin,
        barText: textData,
      );
    } else {
      return TLHeadlineKeyHalfBar(
        horisontalMargin: horisontalMargin,
        barHeight: height * 0.72,
      );
    }
  }
}
