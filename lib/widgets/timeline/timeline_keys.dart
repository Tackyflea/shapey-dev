// creates a whole row of keys
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/widgets/timeline/timeline_actions.dart';

// creates a row for every timeline element including keys and headings (but not layers)
class TimelineLayerKeys extends ConsumerStatefulWidget {
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
  ConsumerState<TimelineLayerKeys> createState() => _TimelineLayerKeysState();
}

class _TimelineLayerKeysState extends ConsumerState<TimelineLayerKeys> {
  // additional potential keys on hover down
  Set<int> HighlightedKeys = {};

  late final Paint activeLayerTintFill;
  late final Map<KeyStyle, Paint> keyFills;
  late final Map<KeyStyle, Paint> keyStrokes;

  // indicates right click is active
  bool secondaryActionActive = false;
  bool dragDownStarted = false;
  late final double keyWidth = 8;
  late int firstKeySelected = -1;
  late int firstKeySelectedWithShift = -1;

  void addRangeOfKeys(int a, int b) {
    final start = a < b ? a : b;
    final end = a > b ? a : b;
    for (int i = start; i <= end; i++) {
      HighlightedKeys.add(i);
    }
  }

  Set<int> getRangeOfKeys(int a, int b) {
    final start = a < b ? a : b;
    final end = a > b ? a : b;
    Set<int> newRangeOfKeys = {};
    for (int i = start; i <= end; i++) {
      newRangeOfKeys.add(i);
    }
    return newRangeOfKeys;
  }

  void panEnd() {
    dragDownStarted = false;
    firstKeySelected = -1;
  }

  @override
  void initState() {
    super.initState();
    // tint color
    activeLayerTintFill = Paint()
      ..color = widget.colorScheme.inversePrimary.withAlpha(64);
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

  int updateKeysHighlighted(
    Offset fromPosition,
    bool isShiftDown,
    bool isCtrlDown,
  ) {
    var posX = fromPosition.dx;
    int newKeyRollOver = (posX / keyWidth).toInt();

    if (newKeyRollOver == -1) {
      return newKeyRollOver;
    }

    // on active key change we can refresh the canvas
    setState(() {
      if (firstKeySelected == -1) {
        firstKeySelected = newKeyRollOver;
      }
      if (firstKeySelectedWithShift == -1) {
        firstKeySelectedWithShift = newKeyRollOver;
      }
      if (isCtrlDown == true) {
        addRangeOfKeys(firstKeySelected, newKeyRollOver);
      } else {
        Set<int> newKeys;
        if (isShiftDown == true) {
          newKeys = getRangeOfKeys(firstKeySelectedWithShift, newKeyRollOver);
        } else {
          newKeys = getRangeOfKeys(firstKeySelected, newKeyRollOver);
        }
        HighlightedKeys = newKeys;
      }
    });

    return newKeyRollOver;
  }

  Future<void> rightClickAction(TapUpDetails event) async {
    secondaryActionActive = true;
    // Right Click action
    // clear duplicates

    // so we know if we should allow adding keyframes
    bool allFramesHaveKeyFrames = true;
    bool anyOfTheFramesHaveKeyframe = false;
    for (int index in HighlightedKeys) {
      var notKeyframed = widget.layer.frameData.keyFrames[index] == null;
      if (notKeyframed) {
        allFramesHaveKeyFrames = false;
      } else {
        anyOfTheFramesHaveKeyframe = true;
      }
    }

    var rightClickMenu = <ContextMenuEntry>[
      MenuItem(
        label: 'Add Keyframe',
        icon: Icons.add,
        enabled: !allFramesHaveKeyFrames,
        value: "add",
      ),
      MenuItem(
        label: 'Remove Keyframe',
        icon: Icons.remove,
        enabled: anyOfTheFramesHaveKeyframe,
        value: "remove",
      ),
    ];

    final selectedValue = await ContextMenu(
      entries: rightClickMenu,
      position: event.globalPosition,
      padding: const EdgeInsets.all(8.0),
    ).show(context);

    if (selectedValue == "add") {
      setState(() {
        secondaryActionActive = false;
        // print("pressed the add button");
        action_add_keyframes(ref, widget.layer, HighlightedKeys.toSet());
      });
      HighlightedKeys.clear();
    } else if (selectedValue == "remove") {
      setState(() {
        action_remove_keyframes(ref, widget.layer, HighlightedKeys.toSet());
      });
      HighlightedKeys.clear();
    }
    secondaryActionActive = false;
  }

  @override
  Widget build(BuildContext _) {
    final appNotifierInstance = ref.read(appNotifier.notifier);
    final isShiftDown = appNotifierInstance.isShiftDown;
    final isCtrlDown = appNotifierInstance.isCtrlDown;
    ref.listen(appNotifier.select((s) => s.isShiftDown), (prev, next) {
      if (next == false) {
        // reset on shift up
        firstKeySelectedWithShift = -1;
      }
    });

    // to reduce refreshing and since we know for now what the key sizes are gonna be, hard setting sizes
    // In future, we could link these but so that we dont have to constant refresh them
    final double keyWidth = 8;
    final double keyHeight = 25;
    final double timelineWidth = keyWidth * widget.frames;
    final Size CanvasSize = Size(timelineWidth, keyHeight);

    // returning fixed size so we can have different canvas widths per timeline
    var timelineLayerDetails = MouseRegion(
      onHover: (event) {},
      onEnter: (event) {},
      onExit: (event) {},
      child: GestureDetector(
        onTap: () => action_highlightLayer(ref, widget.layer),
        onTapDown: (details) {
          // on init tap down, always mark first key as whatevers on tap down
          updateKeysHighlighted(details.localPosition, isShiftDown, isCtrlDown);
        },
        onPanUpdate: (details) {
          if (dragDownStarted == false &&
              isCtrlDown == false &&
              HighlightedKeys.isNotEmpty) {
            HighlightedKeys.clear();
          }
          updateKeysHighlighted(details.localPosition, isShiftDown, isCtrlDown);
          dragDownStarted = true;
        },
        onPanEnd: (_) => panEnd(),
        onPanCancel: () => panEnd(),
        onSecondaryTapUp: (details) => rightClickAction(details),
        child: CustomPaint(
          size: CanvasSize,
          painter: TLLayerPainter(
            CanvasSize,
            widget.layer,
            keyFills,
            keyStrokes,
            activeLayerTintFill,
            widget.fps,
            keyWidth,
            HighlightedKeys.toSet(),
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
  final Map<KeyStyle, Paint> keyFills;
  final Map<KeyStyle, Paint> keyStrokes;
  final Paint activeLayerTintFill;
  final int fps;
  final double keyWidth;
  final Set<int> secondaryHighlightedKeys;
  TLLayerPainter(
    this.size,
    this.layer,
    this.keyFills,
    this.keyStrokes,
    this.activeLayerTintFill,
    this.fps,
    this.keyWidth,
    this.secondaryHighlightedKeys,
  );

  @override
  void paint(Canvas canvas, Size _) {
    final keyCount = layer.frameCount();
    final isLayerActive = layer.isMultiSelectActive();
    final Size keySize = Size(keyWidth, size.height);

    // Draw Keys
    for (int i = 0; i < keyCount; i++) {
      final bool isWholeSecond = i % fps == 0;
      final bool hasKeyframe = layer.frameData.keyFrames[i] != null;
      // final bool isHighlighted = highlightedKey == i;
      final bool isHighlighted = secondaryHighlightedKeys.contains(i);

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
    // dim not active layers
    if (isLayerActive == false) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        activeLayerTintFill,
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

/// The keyframes on the right side of the timeline IE ||||||| x rows
class TimelineKeysList extends ConsumerWidget {
  final ScrollController tlLayerViewScrollbar;
  final double layerHeight;
  const TimelineKeysList({
    super.key,
    required this.layerHeight,
    required this.tlLayerViewScrollbar,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<FileLayer> layers = ref.watch(
      fileNotifier.select((s) => s.layers),
    );
    final double duration = ref.watch(
      fileNotifier.select((s) => s.timelineDuration),
    );
    final int fps = ref.watch(fileNotifier.select((s) => s.fps));

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final int totalFrames = (duration * fps).toInt();

    final ListView layerKeysList = ListView.builder(
      scrollDirection: Axis.vertical,
      prototypeItem: SizedBox(height: layerHeight),
      itemCount: layers.length, // for performance
      controller: tlLayerViewScrollbar,
      cacheExtent: 1000,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, layerIndex) {
        final cs = colorScheme;
        final frames = totalFrames;
        return TimelineLayerKeys(
          key: ValueKey(layers[layerIndex].guid()),
          layer: layers[layerIndex],
          colorScheme: cs,
          fps: fps,
          frames: frames,
        );
      },
    );

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(
        context,
      ).copyWith(scrollbars: false, overscroll: false),
      child: RawScrollbar(
        controller: tlLayerViewScrollbar,
        trackVisibility: true,
        interactive: true,
        thickness: 10,
        thumbVisibility: true,
        thumbColor: colorScheme.onSecondary,
        fadeDuration: Duration(milliseconds: 200),
        trackRadius: Radius.circular(33),
        trackColor: colorScheme.onPrimaryFixed,
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
        minThumbLength: 12,
        shape: StadiumBorder(),
        child: layerKeysList,
      ),
    );
  }
}
