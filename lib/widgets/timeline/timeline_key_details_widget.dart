// creates a whole row of keys
import 'package:flutter/material.dart';
import 'package:shapey/widgets/timeline/tl_key_parts/tl_key.dart';

// creates a row for every timeline element including keys and headings (but not layers)
class TimelineKeyDetails extends StatelessWidget {
  final int frames;
  final int layer; // vertical layer number
  final int fps;
  final bool useExpanded;
  final ColorScheme colorScheme;
  const TimelineKeyDetails({
    super.key,
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
    // print('TimelineKeyDetails refresh'); // TODO: 9 REFRESHES ON LOAD??
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
        itemBuilder: (context, cellIndex) {
          final bool isWholeSecond = cellIndex % fps == 0;

          // normal keys
          return TLKey(
            key: ValueKey<int>((layer << 20) + cellIndex),
            frameNumber: cellIndex,
            fps: fps,
            isWholeSecond: isWholeSecond,
          );
        },
      ),
    );
    return useExpanded ? Expanded(child: child) : child;
  }
}
