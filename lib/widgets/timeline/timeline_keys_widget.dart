import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:shapey/widgets/timeline/layer_name_widget.dart';
import 'package:shapey/widgets/timeline/timeline_keys_context_menu.dart';

// generic key bg
class KeyVisual extends StatefulWidget {
  final int frameNumber;
  final double fps;
  const KeyVisual({super.key, required this.frameNumber, required this.fps});

  @override
  State<KeyVisual> createState() => _KeyVisualState();
}

double borderSize = 1;

class _KeyVisualState extends State<KeyVisual> {
  // passable back to the file setting .. somehow
  bool keyed = false;

  // to indicate current interation if any over keyframe
  KeyframeInteract keyInteraction = KeyframeInteract.none;
  @override
  Widget build(BuildContext context) {
    // the right click menu. It's made here so it gets context on what to enable
    final rc_menu_keyframe = <ContextMenuEntry>[
      MenuItem(
        label: 'Add Keyframe',
        icon: Icons.add,
        enabled: !keyed,
        value: "add",
      ),
      MenuItem(
        label: 'Remove Keyframe',
        icon: Icons.remove,
        enabled: keyed,
        value: "remove",
      ),
    ];

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    Color outputColor;
    Border outputBorder = Border.all(
      color: colorScheme.surfaceContainerHighest,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    Border boxBorderKeyed = Border.all(
      color: colorScheme.tertiary,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignInside,
    );
    Border boxBorderRollOvered = Border.all(
      color: colorScheme.primary,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    Border boxBorderRollOverKeyed = Border.all(
      color: colorScheme.primary,
      width: 2.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    Color defaultColor;
    final bool isWholeSecond = widget.frameNumber.toDouble() % widget.fps == 0;
    //custom color for second
    if (isWholeSecond) {
      defaultColor = colorScheme.surfaceContainerHighest;
    } else {
      defaultColor = colorScheme.onSecondary;
    }
    outputColor = defaultColor;
    // default keyframed color
    if (keyed) {
      outputColor = colorScheme.tertiaryFixed;
      outputBorder = boxBorderKeyed;
    }
    // roll over colors
    if (keyInteraction == KeyframeInteract.over ||
        keyInteraction == KeyframeInteract.menuOpen) {
      // if its already keyed
      if (keyed) {
        outputColor = colorScheme.tertiaryFixed.withAlpha(130);
        outputBorder = boxBorderRollOverKeyed;
      } else {
        // default rollover
        outputColor = colorScheme.inversePrimary;
        outputBorder = boxBorderRollOvered;
      }
    }
    return InkWell(
      onSecondaryTapDown: (e) async {
        // immediately mark menu is open
        setState(() => (keyInteraction = KeyframeInteract.menuOpen));
        // right click
        final menu = ContextMenu(
          entries: rc_menu_keyframe,
          position: e.globalPosition,
          padding: const EdgeInsets.all(8.0),
        );

        //WAIT until user picks something
        final selectedValue = await ContextMenu(
          entries: rc_menu_keyframe,
          position: e.globalPosition,
          padding: const EdgeInsets.all(8.0),
        ).show(context);

        // cancel operation if the whole thing gets dropped.
        if (selectedValue == null) {
          setState(() => (keyInteraction = KeyframeInteract.none));
        }

        // act on decision , if any
        if (selectedValue == "add") {
          setState(() {
            keyed = true;
            keyInteraction = KeyframeInteract.none;
          });
        }
        if (selectedValue == "remove") {
          setState(() {
            keyed = false;
            keyInteraction = KeyframeInteract.none;
          });
        }
      },
      onHover: (value) {
        // print('roll over $value');
        if (value) {
          // roll over
          setState(() => keyInteraction = KeyframeInteract.over);
        } else {
          // roll out
          if (keyInteraction != KeyframeInteract.menuOpen) {
            setState(() => (keyInteraction = KeyframeInteract.none));
          }
        }
      },

      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: outputColor, border: outputBorder),
      ),
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

  final double gridObjectWidth = 8;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fileData = ref.read(fileNotifier.notifier);
    final double tlDuration = fileData.timelineDuration; //second
    final double tlFPS = fileData.fps; // frames per seconsd

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final totalFrames = (tlDuration * tlFPS).toInt();

    final layerBoxes = Column(
      // generate 5 rows
      children: List.generate(
        5,
        (index) => TimelineRow(
          isHeading: isHeading,
          fps: tlFPS,
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
        fps: tlFPS,
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
