import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'sections/stage_widget.dart';
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
    MediaQueryData mediaQuery = MediaQuery.of(context);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Normal layout
    Size windowSize = mediaQuery.size;
    var padding = mediaQuery.padding;
    double windowHeight =
        windowSize.height - padding.top - padding.bottom - (borderSize * 4);
    double windowWidth =
        windowSize.width - padding.left - padding.right - (borderSize * 4);
    return Scaffold(
      backgroundColor: colorScheme.surfaceDim,
      body: Center(
        child: WindowBorder(
          color: colorScheme.surfaceContainerLow,
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
                  child: StageWidget(
                    windowWidth: windowWidth,
                    windowHeight: windowHeight,
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
