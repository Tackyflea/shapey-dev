import 'package:flutter/material.dart';
import 'package:shapey/sections/TitleBar.dart';
import 'sections/StageWidget.dart';
import 'sections/ToolsWidget.dart';
import 'sections/TopWidget.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class MainStage extends StatefulWidget {
  const MainStage({super.key});

  @override
  State<MainStage> createState() => _MainStageState();
}

const borderColor = Color.fromARGB(120, 90, 147, 178);
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

    double titleBarHeight = 30;
    windowHeight -= titleBarHeight;
    // Setup restrictions
    double toolsWidth = 100;
    double tlHeight = 150;
    double tlHeightMin = 100;
    double smaillHeightMin = 400;
    double verySmallWidthMin = 500;
    // limit left side tools width
    if (windowWidth < verySmallWidthMin) {
      toolsWidth = 50;
    }
    // limit timeline tools height
    if (windowHeight < smaillHeightMin) {
      double responsiveHeight = tlHeight + (windowHeight - smaillHeightMin);
      tlHeight = responsiveHeight;
      if (tlHeight < tlHeightMin) {
        tlHeight = tlHeightMin;
      }
    }
    double stageWidth = windowWidth - toolsWidth;
    double mainHeight = windowHeight - tlHeight;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      body: Center(
        //https://pub.dev/documentation/flutter_layout_grid/latest/
        child: WindowBorder(
          color: borderColor,
          width: borderSize,
          child: Container(
            alignment: Alignment(0, 0),
            width: windowWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // header?
                TitleBar(titleBarHeight: titleBarHeight - borderSize),
                Container(
                  height: tlHeight,
                  alignment: Alignment(0, 0),
                  child: TopWidget(),
                ),
                Container(
                  // mainStage?
                  height: mainHeight,
                  alignment: Alignment(0, 0),
                  child: Row(
                    children: [
                      Container(
                        width: toolsWidth,
                        alignment: Alignment(0, 0),
                        // color: Colors.red,
                        child: ToolsWidget(),
                      ),
                      Container(
                        width: stageWidth,
                        alignment: Alignment(0, 0),
                        child: StageWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
