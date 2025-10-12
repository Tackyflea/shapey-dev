import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Interactive viewer meant for right click only panning
/// [child] The child to pan / drag
/// [minScale] min zoom level
/// [maxScale] max zoom level
/// [scaleFactor] how show to zoom, higher = slower
class RightClickViewer extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final double scaleFactor;
  const RightClickViewer({
    super.key,
    required this.child,
    this.minScale = 0.01,
    this.maxScale = 8,
    this.scaleFactor = 900,
  });

  @override
  State<RightClickViewer> createState() => _RightClickViewerState();
}

class _RightClickViewerState extends State<RightClickViewer> {
  // For tracking position updates
  final _controller = TransformationController();
  Offset? _lastPosition;

  @override
  Widget build(BuildContext context) {
    return Listener(
      // panning only allowed for secondary motion
      onPointerDown: (e) => e.buttons == kSecondaryMouseButton
          ? _lastPosition = e.localPosition
          : null,
      onPointerMove: (e) {
        if (e.buttons == kSecondaryMouseButton && _lastPosition != null) {
          final delta = e.localPosition - _lastPosition!;
          _controller.value = _controller.value.clone()
            ..translate(delta.dx, delta.dy);
          _lastPosition = e.localPosition;
        }
      },
      onPointerUp: (_) => _lastPosition = null,
      child: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        scaleFactor: widget.scaleFactor,
        clipBehavior: Clip.hardEdge,
        transformationController: _controller,
        panEnabled: false,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
