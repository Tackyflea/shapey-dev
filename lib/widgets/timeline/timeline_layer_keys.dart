// creates a whole row of keys
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/enums/e_active_tool.dart';

// creates a row for every timeline element including keys and headings (but not layers)
class TimelineLayerKeys extends StatefulWidget {
  final int frames;
  final FileLayer layer; // vertical layer number
  final int fps;
  final ColorScheme colorScheme;
  const TimelineLayerKeys({
    super.key,
    required this.frames,
    required this.layer,
    required this.fps,
    required this.colorScheme,
  });

  @override
  State<TimelineLayerKeys> createState() => _TimelineLayerKeysState();
}

class _TimelineLayerKeysState extends State<TimelineLayerKeys> {
  Offset? _tapPosition;
  int _highlightedKey = 0;

  late final Map<KeyStyle, Paint> keyFills;
  late final Map<KeyStyle, Paint> keyStrokes;

  late final double keyWidth = 8;
  @override
  void initState() {
    super.initState();
    // Pre fill and stroke the keys so there's less build process in rendering them
    keyFills = {
      KeyStyle.normal: Paint()..color = widget.colorScheme.onSecondary,
      KeyStyle.normalWholeSecond: Paint()
        ..color = widget.colorScheme.surfaceContainerHighest,
      KeyStyle.highlight: Paint()..color = widget.colorScheme.inversePrimary,
      KeyStyle.keyed: Paint()..color = widget.colorScheme.tertiaryFixed,
      KeyStyle.keyedHighlight: Paint()
        ..color = widget.colorScheme.tertiaryFixedDim,
    };

    keyStrokes = {
      KeyStyle.normal: Paint()
        ..color = widget.colorScheme.surfaceContainerHighest
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
      KeyStyle.normalWholeSecond: Paint()
        ..color = widget.colorScheme.surfaceContainerHighest
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
      KeyStyle.highlight: Paint()
        ..color = widget.colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
      KeyStyle.keyed: Paint()
        ..color = widget.colorScheme.tertiary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
      KeyStyle.keyedHighlight: Paint()
        ..color = widget.colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    };
  }

  @override
  Widget build(BuildContext _) {
    // to reduce refreshing and since we know for now what the key sizes are gonna be, hard setting sizes
    // In future, we could link these but so that we dont have to constant refresh them
    final double keyWidth = 8;
    final double keyHeight = 25;
    final double timelineWidth = keyWidth * widget.frames;
    final Size CanvasSize = Size(timelineWidth, keyHeight);

    // returning fixed size so we can have different canvas widths per timeline
    var timelineLayerDetails = MouseRegion(
      onHover: (event) {
        var posX = event.localPosition.dx;
        int newKeyRollOver = (posX / keyWidth).toInt();
        // on active key change we can refresh the canvas
        if (_highlightedKey != newKeyRollOver) {
          setState(() {
            _highlightedKey = newKeyRollOver;
          });
        }
      },
      onExit: (event) {
        setState(() {
          // _highlightedKey = -1;
        });
      },
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            _tapPosition = details.localPosition;
          });
        },
        onSecondaryTapUp: (details) async {
          // Right Click action
          var isKeyFramed =
              widget.layer.frameData.keyFrames?[_highlightedKey] != null;

          var rightClickMenu = <ContextMenuEntry>[
            MenuItem(
              label: 'Add Keyframe',
              icon: Icons.add,
              enabled: !isKeyFramed,
              value: "add",
            ),
            MenuItem(
              label: 'Remove Keyframe',
              icon: Icons.remove,
              enabled: isKeyFramed,
              value: "remove",
            ),
          ];

          final selectedValue = await ContextMenu(
            entries: rightClickMenu,
            position: details.globalPosition,
            padding: const EdgeInsets.all(8.0),
          ).show(context);

          if (selectedValue == "add") {
            setState(() {
              widget.layer.addKeyFrame(_highlightedKey);
            });
          } else if (selectedValue == "remove") {
            setState(() {
              widget.layer.removeKeyFrame(_highlightedKey);
            });
          }
        },
        child: CustomPaint(
          size: CanvasSize,
          painter: TLLayerPainter(
            CanvasSize,
            widget.layer,
            _tapPosition,
            keyFills,
            keyStrokes,
            widget.fps,
            keyWidth,
            _highlightedKey,
          ),
        ),
      ),
    );

    return timelineLayerDetails;
  }
}

class TLLayerPainter extends CustomPainter {
  // so we can have custom canvas sizes
  final Size size;
  final FileLayer layer;
  final Offset? tapPosition;
  final Map<KeyStyle, Paint> keyFills;
  final Map<KeyStyle, Paint> keyStrokes;
  final int fps;
  final double keyWidth;
  final int highlightedKey;
  TLLayerPainter(
    this.size,
    this.layer,
    this.tapPosition,
    this.keyFills,
    this.keyStrokes,
    this.fps,
    this.keyWidth,
    this.highlightedKey,
  );

  @override
  void paint(Canvas canvas, Size _) {
    final keyCount = layer.frameCount();
    final Size keySize = Size(keyWidth, size.height);

    // Draw Keys
    for (int i = 0; i < keyCount; i++) {
      final bool isWholeSecond = i % fps == 0;
      final bool hasKeyframe = layer.frameData.keyFrames?[i] != null;
      final bool isHighlighted = highlightedKey == i;
      KeyStyle style = KeyStyle.normal;
      // regular styles
      if (isWholeSecond) style = KeyStyle.normalWholeSecond;
      if (isHighlighted) style = KeyStyle.highlight;
      // keyed
      if (hasKeyframe) style = KeyStyle.keyed;
      if (hasKeyframe && isHighlighted) style = KeyStyle.keyedHighlight;

      canvas.drawKey(
        Offset(i * keyWidth, 0) & keySize,
        style,
        keyFills,
        keyStrokes,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension DrawKey on Canvas {
  void drawKey(
    Rect rect,
    KeyStyle style,
    Map<KeyStyle, Paint> fills,
    Map<KeyStyle, Paint> strokes,
  ) {
    drawRect(rect, fills[style]!);
    double strokeWidth = 1;
    Rect rect2 = Rect.fromLTWH(
      rect.left + strokeWidth / 2,
      rect.top + strokeWidth / 2,
      rect.width - strokeWidth,
      rect.height - strokeWidth,
    );
    drawRect(rect2, strokes[style]!);
  }
}
