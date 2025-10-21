import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/ShapeCanvas.dart';
import 'package:shapey/sections/TitleBar.dart';
import 'package:shapey/utility/TouchViewer.dart';
import 'package:shapey/app_state/app_notifier.dart';
import 'package:shapey/widgets/PropertiesWidget.dart';
import 'package:shapey/widgets/ToolsWidget.dart';

class StageWidget extends ConsumerWidget {
  final double windowSize;
  const StageWidget({super.key, required this.windowSize});
  // https://github.com/flutter/packages/tree/main/third_party/packages/flutter_svg
  // https://appsgemacht.de/en/insights/svg-vector-graphics-flutter
  // https://stackoverflow.com/questions/57874374/flutter-draw-svg-in-custompaint-canvas
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var toolData = ref.watch(appNotifier);
    double sidePanelsY = 40;
    double titleBarSize = 25;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    TouchViewer mainViewer = TouchViewer(
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

    var titleBarDisplay = Positioned(
      // text info
      left: 0.0,
      top: 0,
      child: Container(
        width: windowSize,
        alignment: Alignment(0, 0),
        // color: Colors.red,
        child: TitleBar(titleBarHeight: 25),
      ),
    );

    //  Tools overlay
    var ToolsDisplay = Positioned(
      // text info
      left: 20.0,
      bottom: sidePanelsY,
      child: Container(
        width: 50,
        alignment: Alignment(0, 0),
        // color: Colors.red,
        child: ToolsWidget(),
      ),
    );
    //  Tools overlay
    var PropertiesDisplay = Positioned(
      // text info
      right: 20.0,
      bottom: sidePanelsY,
      child: Container(
        width: 200,
        alignment: Alignment(0, 0),
        // color: Colors.red,
        child: PropertiesWidget(),
      ),
    );
    // the info box on whats selected
    var infoDisplay = Positioned(
      // text info
      right: 20.0,
      top: titleBarSize + 5.0,
      child: IgnorePointer(
        ignoring: true,
        child: Text(
          textAlign: TextAlign.right,
          toolData.activeTool.shortName,

          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.outline,
            fontSize: textTheme.titleLarge?.fontSize,
          ),
        ),
      ),
    );
    // ref.read(scoreChangeNotifProvider.notifier).set(points);

    return Stack(
      children: [
        mainViewer,
        infoDisplay,
        ToolsDisplay,
        PropertiesDisplay,
        titleBarDisplay,
      ],
    );
  }
}
