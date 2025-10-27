// Optimized generic key bg

import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';

import 'key_widget_inkwell.dart';

class TLKey extends StatefulWidget {
  final int frameNumber;
  final double fps;
  final bool isWholeSecond;

  const TLKey({
    super.key,
    required this.frameNumber,
    required this.fps,
    required this.isWholeSecond,
  });

  @override
  State<TLKey> createState() => _TLKeyState();
}

const double borderSize = 1;

class _TLKeyState extends State<TLKey> {
  bool keyed = false;
  KeyframeInteract keyInteraction = KeyframeInteract.none;
  Future<void> rightClickAction(TapDownDetails e) async {
    setState(() => keyInteraction = KeyframeInteract.menuOpen);

    final selectedValue = await ContextMenu(
      entries: _buildContextMenu(),
      position: e.globalPosition,
      padding: const EdgeInsets.all(8.0),
    ).show(context);

    if (selectedValue == null) {
      setState(() => keyInteraction = KeyframeInteract.none);
      return;
    }

    if (selectedValue == "add") {
      setState(() {
        keyed = true;
        keyInteraction = KeyframeInteract.none;
      });
    } else if (selectedValue == "remove") {
      setState(() {
        keyed = false;
        keyInteraction = KeyframeInteract.none;
      });
    }
  }

  List<ContextMenuEntry> _buildContextMenu() {
    return <ContextMenuEntry>[
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
  }

  void _onHover(bool value) {
    if (value) {
      if (keyInteraction != KeyframeInteract.over) {
        setState(() => keyInteraction = KeyframeInteract.over);
      }
    } else {
      if (keyInteraction == KeyframeInteract.over) {
        setState(() => keyInteraction = KeyframeInteract.none);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyWidgetInkwell(
      rightClickAction: rightClickAction,
      HoverAction: _onHover,
      isHovered:
          keyInteraction == KeyframeInteract.over ||
          keyInteraction == KeyframeInteract.menuOpen,
      isKeyed: keyed,
      isWholeSecond: widget.isWholeSecond,
    );
  }
}
