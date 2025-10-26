// creates a whole row of keys
import 'package:flutter/material.dart';
import 'package:shapey/widgets/timeline/key_visual_widget.dart';
import 'package:shapey/widgets/timeline/timeline_keys_widget.dart';

// creates a row for every timeline element including keys and headings (but not layers)
class TimelineKeyDetails extends StatelessWidget {
  final bool? isHeading;
  final double size;
  final int frames;
  final double fps;
  const TimelineKeyDetails({
    super.key,
    this.isHeading,
    required this.size,
    required this.frames,
    required this.fps,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: SizedBox(
          height: 25,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                frames,
                (index) => SizedBox(
                  width: size,
                  height: 25,
                  child: isHeading == null
                      ? KeyVisual(frameNumber: index, fps: fps)
                      : KeyVisualHeader(
                          frameNumber: index,
                          fps: fps,
                          width: size,
                          height: 25,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
