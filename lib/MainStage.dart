import 'package:flutter/material.dart';
import 'package:shapey/widgets/PropertiesWidget.dart';
import 'package:shapey/sections/TitleBar.dart';
import 'sections/StageWidget.dart';
import 'widgets/ToolsWidget.dart';
import 'widgets/TimelineWidget.dart';
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

    // Setup restrictions
    double tlHeight = 100;
    double tlHeightMin = 50;
    double smaillHeightMin = 640;
    // limit timeline tools height
    if (windowHeight < smaillHeightMin) {
      double responsiveHeight = tlHeight + (windowHeight - smaillHeightMin);
      tlHeight = responsiveHeight;
      if (tlHeight < tlHeightMin) {
        tlHeight = tlHeightMin;
      }
    }
    double stageWidth = windowWidth;
    double mainHeight = windowHeight - tlHeight;

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
                  width: stageWidth,
                  height: mainHeight,
                  alignment: Alignment(0, 0),
                  child: StageWidget(windowSize: windowWidth),
                ),
                Container(
                  height: tlHeight,
                  alignment: Alignment(0, 0),
                  child: TimelineWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
