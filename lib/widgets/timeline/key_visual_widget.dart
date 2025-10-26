// generic key bg
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';

class KeyVisual extends StatefulWidget {
  final int frameNumber;
  final double fps;
  final ColorScheme colorScheme;
  const KeyVisual({
    super.key,
    required this.frameNumber,
    required this.fps,
    required this.colorScheme,
  });

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

    Color outputColor;
    Border outputBorder = Border.all(
      color: widget.colorScheme.surfaceContainerHighest,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    Border boxBorderKeyed = Border.all(
      color: widget.colorScheme.tertiary,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignInside,
    );
    Border boxBorderRollOvered = Border.all(
      color: widget.colorScheme.primary,
      width: 1.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    Border boxBorderRollOverKeyed = Border.all(
      color: widget.colorScheme.primary,
      width: 2.0,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    );

    Color defaultColor;
    final bool isWholeSecond = widget.frameNumber.toDouble() % widget.fps == 0;
    //custom color for second
    if (isWholeSecond) {
      defaultColor = widget.colorScheme.surfaceContainerHighest;
    } else {
      defaultColor = widget.colorScheme.onSecondary;
    }
    outputColor = defaultColor;
    // default keyframed color
    if (keyed) {
      outputColor = widget.colorScheme.tertiaryFixed;
      outputBorder = boxBorderKeyed;
    }
    // roll over colors
    if (keyInteraction == KeyframeInteract.over ||
        keyInteraction == KeyframeInteract.menuOpen) {
      // if its already keyed
      if (keyed) {
        outputColor = widget.colorScheme.tertiaryFixed.withAlpha(130);
        outputBorder = boxBorderRollOverKeyed;
      } else {
        // default rollover
        outputColor = widget.colorScheme.inversePrimary;
        outputBorder = boxBorderRollOvered;
      }
    }
    return InkWell(
      onSecondaryTapDown: (e) async {
        // immediately mark menu is open
        setState(() => (keyInteraction = KeyframeInteract.menuOpen));
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
