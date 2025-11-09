// HEADING details  , todo: CLEAN
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/widgets/timeline/timeline_actions.dart';
import 'package:shapey/widgets/timeline/timeline_scrubber.dart';

// The FRAMES headline where you indicate what frame you're at
class TimelineKeysHeading extends ConsumerWidget {
  final int frames;
  final int fps;
  final ColorScheme colorScheme;
  const TimelineKeysHeading({
    super.key,
    required this.frames,
    required this.fps,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // to reduce refreshing and since we know for now what the key sizes are gonna be, hard setting sizes
    // In future, we could link these but so that we dont have to constant refresh them
    final double keyWidth = 8;
    final double keyHeight = 25;
    final Size CanvasSize = Size(keyWidth * frames, keyHeight);
    final Map<HeaderKeyStyle, Paint> keyFills = {
      HeaderKeyStyle.secondKey: Paint()..color = colorScheme.primary,
      HeaderKeyStyle.key: Paint()..color = colorScheme.tertiaryFixedDim,
      HeaderKeyStyle.secondKeyHeader: Paint()..color = colorScheme.primary,
      HeaderKeyStyle.bg: Paint()..color = colorScheme.secondaryContainer,
    };
    var fontSize = Theme.of(context).textTheme.bodySmall?.fontSize;

    final headerTextStyle = TextStyle(
      color: colorScheme.primary,
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
    );
    void checkForFrame(double posX) {
      int newKeyRollOver = (posX / keyWidth).toInt();
      if (newKeyRollOver < 0) {
        return;
      }
      action_set_frame(ref, newKeyRollOver);
    }

    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTapDown: (details) => checkForFrame(details.localPosition.dx),
            onPanUpdate: (details) => checkForFrame(details.localPosition.dx),
            onPanEnd: (details) => checkForFrame(details.localPosition.dx),
            child: CustomPaint(
              size: CanvasSize,
              painter: TLKeysHeadingPainter(
                size: CanvasSize,
                keyFills: keyFills,
                textStyle: headerTextStyle,
                frames: frames,
                fps: fps,
              ),
            ),
          ),
          TimelineScrubber(keyWidth: keyWidth),
        ],
      ),
    );
  }
}

class TLKeysHeadingPainter extends CustomPainter {
  final Size size;
  final Map<HeaderKeyStyle, Paint> keyFills;
  final TextStyle textStyle;
  final int frames;
  final int fps;
  TLKeysHeadingPainter({
    required this.size,
    required this.keyFills,
    required this.textStyle,
    required this.frames,
    required this.fps,
  });

  final double keyHeight = 9;
  final double halfKeyHeight = 11;
  final double hMargin = 2.4;
  @override
  void paint(Canvas canvas, Size _) {
    final keyWidth = (size.width / frames.toDouble()) - hMargin * 2;
    // Draw Keys
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      keyFills[HeaderKeyStyle.bg]!,
    );

    for (int i = 0; i < frames; i++) {
      final offsetX = size.width * ((i / frames).toDouble());
      // whole second
      if (i.toDouble() % fps == 0) {
        canvas.drawRect(
          Rect.fromLTWH(
            offsetX + hMargin,
            size.height - halfKeyHeight,
            keyWidth,
            halfKeyHeight,
          ),
          keyFills[HeaderKeyStyle.secondKey]!,
        );
        // second text
        var textData = (i.toDouble() / fps).toInt().toString();
        final textPainter = TextPainter(
          text: TextSpan(text: textData, style: textStyle),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        textPainter.layout();
        final offset = Offset(offsetX, -1.5);
        textPainter.paint(canvas, offset);
      } else {
        // everything else
        canvas.drawRect(
          Rect.fromLTWH(
            offsetX + hMargin,
            size.height - keyHeight,
            keyWidth,
            keyHeight,
          ),
          keyFills[HeaderKeyStyle.key]!,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum HeaderKeyStyle {
  key(1, "key"),
  secondKey(2, "secondKey"),
  secondKeyHeader(3, "secondKeyHeader"),
  bg(4, "bg");

  final int number;
  final String shortName;

  const HeaderKeyStyle(this.number, this.shortName);
}
