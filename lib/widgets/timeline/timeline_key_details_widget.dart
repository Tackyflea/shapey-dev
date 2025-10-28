// creates a whole row of keys
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shapey/widgets/timeline/tl_key_parts/tl_key.dart';

import 'tl_headline_parts/tl_headline.dart';

// creates a row for every timeline element including keys and headings (but not layers)
class TimelineKeyDetails extends StatelessWidget {
  final bool? isHeading;
  final int frames;
  final int layer; // vertical layer number
  final double fps;
  final bool useExpanded;
  final ColorScheme colorScheme;
  const TimelineKeyDetails({
    super.key,
    this.isHeading,
    required this.frames,
    required this.layer,
    required this.fps,
    required this.colorScheme,
    this.useExpanded = false,
  });

  @override
  Widget build(BuildContext _) {
    // to reduce refreshing and since we know for now what the key sizes are gonna be, hard setting sizes
    // In future, we could link these but so that we dont have to constant refresh them
    final double keyWidth = 8;
    final double keyHeight = 25;

    final child = Container(
      color: colorScheme.secondaryContainer,
      height: keyHeight,
      child: ListView.builder(
        prototypeItem: SizedBox(width: keyWidth, height: keyHeight),
        scrollDirection: Axis.horizontal,
        itemCount: frames, // for performance
        addAutomaticKeepAlives: true,
        cacheExtent: keyWidth * 20,
        addRepaintBoundaries: false,
        itemBuilder: (context, cellIndex) {
          final bool isWholeSecond = cellIndex % fps == 0;

          if (isHeading == null) {
            // normal keys
            return TLKey(
              key: ValueKey<int>((layer << 20) + cellIndex),
              frameNumber: cellIndex,
              fps: fps,
              isWholeSecond: isWholeSecond,
            );
          }
          // headline keys
          return TLHeadline(
            key: ValueKey<int>((layer << 20) + cellIndex),
            colorScheme: colorScheme,
            frameNumber: cellIndex,
            fps: fps,
            width: keyWidth,
            height: keyHeight,
          );
        },
      ),
    );
    return useExpanded ? Expanded(child: child) : child;
  }
}
