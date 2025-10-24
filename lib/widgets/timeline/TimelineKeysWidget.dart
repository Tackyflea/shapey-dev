import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_notifier.dart';

// generic key bg
class KeyVisual extends StatelessWidget {
  final int frameNumber;
  final double fps;
  const KeyVisual({super.key, required this.frameNumber, required this.fps});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final boxBorder = Border.all(
      color: colorScheme.surfaceContainerHighest,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );
    final Color keyColor;
    final bool isWholeSecond = frameNumber.toDouble() % fps == 0;
    //custom color for second
    if (isWholeSecond) {
      keyColor = colorScheme.surfaceContainerHighest;
    } else {
      keyColor = colorScheme.onSecondary;
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: keyColor, border: boxBorder),
    );
  }
}

//  header bg
class KeyVisualHeader extends StatelessWidget {
  final int frameNumber;
  final double fps;
  final double height;
  final double width;
  const KeyVisualHeader({
    super.key,
    required this.width,
    required this.height,
    required this.frameNumber,
    required this.fps,
  });

  @override
  Widget build(BuildContext context) {
    final horisontalMargin = width * 0.3;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final boxBorder = Border.all(
      color: colorScheme.secondaryContainer,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );
    final bool isWholeSecond = frameNumber.toDouble() % fps == 0;
    //custom color for second
    if (isWholeSecond) {
      var textData = (frameNumber.toDouble() / fps).toInt().toString();
      return Column(
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  textData,
                  textAlign: TextAlign.center,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: textTheme.bodySmall?.fontSize,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin: EdgeInsets.fromLTRB(
                horisontalMargin,
                3,
                horisontalMargin,
                0,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                border: boxBorder,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(
          horisontalMargin,
          height * 0.72,
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
}

// creates a whole row of keys
class TimelineRow extends StatelessWidget {
  final bool? isHeading;
  final double size;
  final int frames;
  final double fps;
  const TimelineRow({
    super.key,
    this.isHeading,
    required this.size,
    required this.frames,
    required this.fps,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class TimelineKeys extends ConsumerWidget {
  final bool? isHeading;
  final double width;
  final double height;
  final double headerHeight;
  const TimelineKeys({
    super.key,
    this.isHeading,
    required this.width,
    required this.height,
    required this.headerHeight,
  });

  final double testDuration = 5; //seconds
  final double testFPS = 30; // frames per second

  final double gridObjectWidth = 8;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final value = ref.watch(appNotifier);
    final totalFrames = (testDuration * testFPS).toInt();

    final layerBoxes = Column(
      // generate 5 rows
      children: List.generate(
        5,
        (index) => TimelineRow(
          isHeading: isHeading,
          fps: testFPS,
          size: gridObjectWidth,
          frames: totalFrames,
        ),
      ),
    );

    final keysWidget = Container(
      alignment: Alignment.topLeft,
      width: width,
      height: height - headerHeight,
      color: colorScheme.surfaceContainerHighest,
      child: layerBoxes,
    );

    final headerWidget = Container(
      height: headerHeight,
      width: width,
      color: colorScheme.secondaryContainer,
      child: TimelineRow(
        isHeading: true,
        fps: testFPS,
        size: gridObjectWidth,
        frames: totalFrames,
      ),
    );
    return Positioned(
      right: 0,
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: keysWidget),
          Positioned(
            top: 0,
            left: 0,
            child: Material(elevation: 3, child: headerWidget),
          ),
        ],
      ),
    );
  }
}
