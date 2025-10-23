import 'package:flutter/material.dart';
import 'sections/StageWidget.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class MainStage extends StatefulWidget {
  const MainStage({super.key});

  @override
  State<MainStage> createState() => _MainStageState();
}

double borderSize = 1;

class _MainStageState extends State<MainStage> {
  @override
  Widget build(BuildContext context) {
    // Utility grab window size
    Size windowSize = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    double windowHeight =
        windowSize.height - padding.top - padding.bottom - (borderSize * 4);
    double windowWidth =
        windowSize.width - padding.left - padding.right - (borderSize * 4);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      body: Center(
        //https://pub.dev/documentation/flutter_layout_grid/latest/
        child: WindowBorder(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          width: borderSize,
          child: Container(
            alignment: Alignment(0, 0),
            width: windowWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: windowWidth,
                  height: windowHeight,
                  alignment: Alignment(0, 0),
                  child: StageWidget(windowSize: windowWidth),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
