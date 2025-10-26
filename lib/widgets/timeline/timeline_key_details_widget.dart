// creates a whole row of keys
import 'package:flutter/material.dart';
import 'package:shapey/widgets/timeline/key_visual_widget.dart';
import 'package:shapey/widgets/timeline/timeline_keys_widget.dart';

// creates a row for every timeline element including keys and headings (but not layers)
class TimelineKeyDetails extends StatelessWidget {
  final bool? isHeading;
  final double keyWidth;
  final double keyHeight;
  final int frames;
  final double fps;
  final bool useExpanded;
  final ColorScheme colorScheme;
  const TimelineKeyDetails({
    super.key,
    this.isHeading,
    required this.keyWidth,
    required this.keyHeight,
    required this.frames,
    required this.fps,
    required this.colorScheme,
    this.useExpanded = false,
  });

  @override
  Widget build(BuildContext _) {
    final child = Container(
      color: colorScheme.secondaryContainer,
      height: keyHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: frames, // for performance
        itemExtent: keyWidth,
        itemBuilder: (context, index) => SizedBox(
          width: keyWidth,
          height: keyHeight,
          child: isHeading == null
              ? KeyVisual(
                  key: ValueKey(index),
                  colorScheme: colorScheme,
                  frameNumber: index,
                  fps: fps,
                )
              : KeyVisualHeader(
                  key: ValueKey(index),
                  colorScheme: colorScheme,
                  frameNumber: index,
                  fps: fps,
                  width: keyWidth,
                  height: keyHeight,
                ),
        ),
      ),
    );
    return useExpanded ? Expanded(child: child) : child;
  }
}
