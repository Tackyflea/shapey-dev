// HEADING details  , todo: CLEAN
import 'package:flutter/material.dart';
import 'tl_headline_key_bar.dart';
import 'tl_headline_key_half_bar.dart';

// The FRAMES headline where you indicate what frame you're at
class TimelineHeadline extends StatelessWidget {
  final int frames;
  final int fps;
  final ColorScheme colorScheme;
  const TimelineHeadline({
    super.key,
    required this.frames,
    required this.fps,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext _) {
    // to reduce refreshing and since we know for now what the key sizes are gonna be, hard setting sizes
    // In future, we could link these but so that we dont have to constant refresh them
    final double keyWidth = 8;
    final double keyHeight = 25;
    final double halfKeyHeight = 18;
    final double horisontalMargin = 2.4;
    final child = Container(
      color: colorScheme.secondaryContainer,
      height: keyHeight,
      child: ListView.builder(
        prototypeItem: SizedBox(width: keyWidth),
        scrollDirection: Axis.horizontal,
        itemCount: frames, // for performance
        addAutomaticKeepAlives: true,
        cacheExtent: keyWidth * 20,
        addRepaintBoundaries: false,
        itemBuilder: (context, frameNumber) {
          final bool isWholeSecond = frameNumber.toDouble() % fps == 0;
          if (isWholeSecond) {
            var textData = (frameNumber.toDouble() / fps).toInt().toString();
            return TLHeadlineKeyBar(
              horisontalMargin: horisontalMargin,
              barText: textData,
            );
          } else {
            return TLHeadlineKeyHalfBar(
              horisontalMargin: horisontalMargin,
              barHeight: halfKeyHeight,
            );
          }
        },
      ),
    );
    return Expanded(child: child);
  }
}
