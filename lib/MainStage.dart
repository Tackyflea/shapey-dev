import 'package:flutter/material.dart';
import 'sections/StageWidget.dart';
import 'sections/ToolsWidget.dart';
import 'sections/TopWidget.dart';

class MainStage extends StatefulWidget {
  const MainStage({super.key});

  @override
  State<MainStage> createState() => _MainStageState();
}

class _MainStageState extends State<MainStage> {
  @override
  Widget build(BuildContext context) {
    // Utility grab window size
    Size windowSize = MediaQuery.of(context).size;
    var padding = MediaQuery.of(context).padding;
    double windowHeight = windowSize.height - padding.top - padding.bottom;
    double windowWidth = windowSize.width - padding.left - padding.right;

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
        child: Container(
          alignment: Alignment(0, 0),
          width: windowWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // header?
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
    );
  }
}
