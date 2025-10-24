import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

/// Interactive viewer meant for right click only panning
/// [child] The child to pan / drag
/// [minScale] min zoom level
/// [maxScale] max zoom level
/// [scaleFactor] how show to zoom, higher = slower
class TouchViewer extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final double scaleFactor;
  const TouchViewer({
    super.key,
    required this.child,
    this.minScale = 0.01,
    this.maxScale = 8,
    this.scaleFactor = 900,
  });

  @override
  State<TouchViewer> createState() => _TouchViewerSTate();
}

class _TouchViewerSTate extends State<TouchViewer> {
  // For tracking position updates
  final _controller = TransformationController();
  Offset? _lastPosition;

  @override
  Widget build(BuildContext context) {
    Listener touchListener = Listener(
      // panning only allowed for secondary motion
      onPointerDown: (e) => e.buttons == kSecondaryMouseButton
          ? _lastPosition = e.localPosition
          : null,
      onPointerMove: (e) {
        if (e.buttons == kSecondaryMouseButton && _lastPosition != null) {
          final delta = e.localPosition - _lastPosition!;
          _controller.value = _controller.value.clone()
            ..translateByVector3(Vector3(delta.dx, delta.dy, 0));
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

    return touchListener;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
