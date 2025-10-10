import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/ShapeCanvas.dart';
import 'package:shapey/utility/RightClickIVWidget.dart';

class StageWidget extends ConsumerStatefulWidget {
  const StageWidget({super.key});

  @override
  ConsumerState<StageWidget> createState() => _StageState();
}

class _StageState extends ConsumerState<StageWidget> {
  // https://github.com/flutter/packages/tree/main/third_party/packages/flutter_svg
  // https://appsgemacht.de/en/insights/svg-vector-graphics-flutter
  // https://stackoverflow.com/questions/57874374/flutter-draw-svg-in-custompaint-canvas
  @override
  Widget build(BuildContext context) {
    // ref.read(scoreChangeNotifProvider.notifier).set(points);
    return RightClickViewer(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        // decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ShapeCanvas(width: 800, height: 500)],
        ),
      ),
    );
  }
}
