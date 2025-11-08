// creates a whole row of keys
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_commands.dart';
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
  List<int> HighlightedKeys = List.empty(growable: true);

  late final Paint activeLayerTintFill;
  late final Map<KeyStyle, Paint> keyFills;
  late final Map<KeyStyle, Paint> keyStrokes;

  // indicates right click is active
  bool secondaryActionActive = false;
  bool dragDownStarted = false;
  late final double keyWidth = 8;
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

  void updateKeysHighlighted(Offset fromPosition, bool isShiftDown) {
    var posX = fromPosition.dx;
    int newKeyRollOver = (posX / keyWidth).toInt();

    if (newKeyRollOver == -1) {
      return;
    }

    // on active key change we can refresh the canvas
    setState(() {
      if (HighlightedKeys.isNotEmpty) {
        if (isShiftDown == false && HighlightedKeys.length == 2) {
          // you're moving around after clicking once, you can preview new spot to click
          HighlightedKeys.removeAt(0);
        }
      }
      HighlightedKeys.add(newKeyRollOver);
    });
  }

  void panEnd(bool isShiftDown) {
    dragDownStarted = false;
  }

  Future<void> rightClickAction(TapUpDetails event) async {
    secondaryActionActive = true;
    // Right Click action
    // clear duplicates
    Set<int> toSet = HighlightedKeys.toSet();
    HighlightedKeys = toSet.toList();

    // so we know if we should allow adding keyframes
    bool allFramesHaveKeyFrames = true;
    bool anyOfTheFramesHaveKeyframe = false;
    for (int index in HighlightedKeys) {
      var notKeyframed = widget.layer.frameData.keyFrames?[index] == null;
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
        ref
            .read(appNotifier.select((s) => s.appCommandHistory))
            .executeCommand(
              AddKeyFramesCommand(
                ref.read(fileNotifier.notifier),
                widget.layer,
                HighlightedKeys,
              ),
            );
      });
      HighlightedKeys.clear();
    } else if (selectedValue == "remove") {
      setState(() {
        ref
            .read(appNotifier.select((s) => s.appCommandHistory))
            .executeCommand(
              RemoveKeyFramesCommand(
                ref.read(fileNotifier.notifier),
                widget.layer,
                HighlightedKeys,
              ),
            );
      });
      HighlightedKeys.clear();
    }
    secondaryActionActive = false;
  }

  @override
  Widget build(BuildContext _) {
    final appNotifierInstance = ref.read(appNotifier.notifier);
    final isShiftDown = appNotifierInstance.isShiftDown;
    // to reduce refreshing and since we know for now what the key sizes are gonna be, hard setting sizes
    // In future, we could link these but so that we dont have to constant refresh them
    final double keyWidth = 8;
    final double keyHeight = 25;
    final double timelineWidth = keyWidth * widget.frames;
    final Size CanvasSize = Size(timelineWidth, keyHeight);

    // returning fixed size so we can have different canvas widths per timeline
    var timelineLayerDetails = MouseRegion(
      onHover: (event) {
        // only clear the selection if we only have a single key selection
        if (HighlightedKeys.isNotEmpty) {
          HighlightedKeys.removeLast();
        }

        updateKeysHighlighted(event.localPosition, isShiftDown);
      },
      onExit: (event) {
        // don't cancel highlighting if you're currently rightclicking
        if (secondaryActionActive == true) {
          return;
        }
        setState(() {
          // HighlightedKeys.clear();
          // _highlightedKey = -1;
          if (isShiftDown == false) {
            HighlightedKeys.clear();
          }
        });
      },
      child: GestureDetector(
        onTap: () => action_highlightLayer(ref, widget.layer),
        onTapDown: (details) {
          // clear previous highlights
          // multiSelectionActive = false;
          if (isShiftDown == false && HighlightedKeys.length > 1) {
            HighlightedKeys.clear();
          }
          updateKeysHighlighted(details.localPosition, isShiftDown);
        },
        onPanUpdate: (details) {
          if (dragDownStarted == false &&
              isShiftDown == false &&
              HighlightedKeys.isNotEmpty) {
            HighlightedKeys.clear();
          }
          updateKeysHighlighted(details.localPosition, isShiftDown);
          dragDownStarted = true;
        },
        onPanEnd: (_) => panEnd(isShiftDown),
        onPanCancel: () => panEnd(isShiftDown),
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
            HighlightedKeys,
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
  final List<int> secondaryHighlightedKeys;
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
      final bool hasKeyframe = layer.frameData.keyFrames?[i] != null;
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
