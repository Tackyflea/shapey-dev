import 'package:flutter/material.dart';
import 'package:shapey/shape_canvas.dart';
import 'package:shapey/sections/titlebar_widget.dart';
import 'package:shapey/utility/touch_viewer_widget.dart';
import 'package:shapey/widgets/active_tool_display_widget.dart';
import 'package:shapey/widgets/properties_widget.dart';
import 'package:shapey/timeline.dart';
import 'package:shapey/widgets/tools_widget.dart';

class StageWidget extends StatefulWidget {
  final double windowWidth;
  final double windowHeight;

  const StageWidget({
    super.key,
    required this.windowWidth,
    required this.windowHeight,
  });
  @override
  State<StageWidget> createState() => _StageWidgetState();
}

class _StageWidgetState extends State<StageWidget> {
  // https://github.com/flutter/packages/tree/main/third_party/packages/flutter_svg
  // https://appsgemacht.de/en/insights/svg-vector-graphics-flutter
  // https://stackoverflow.com/questions/57874374/flutter-draw-svg-in-custompaint-canvas

  @override
  Widget build(BuildContext _) {
    double sidePanelsY = 40;
    double titleBarSize = 25;

    TouchViewer mainViewer = TouchViewer(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Align(
          alignment: Alignment(0, -0.86),
          child: Transform.scale(
            scale: 0.85,
            child: Material(
              elevation: 2,
              child: ShapeCanvas(width: 800, height: 500),
            ),
          ),
        ),
      ),
    );

    var titleBarDisplay = Positioned(
      // text info
      left: 0.0,
      top: 0,
      child: Container(
        width: widget.windowWidth,
        alignment: Alignment(0, 0),
        // color: Colors.red,
        child: TitleBar(titleBarHeight: 25),
      ),
    );

    //  Tools overlay
    var ToolsDisplay = Positioned(
      // text info
      left: 20.0,
      top: 0,
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
      top: 0,
      bottom: sidePanelsY,
      child: Container(
        width: 200,
        alignment: Alignment(0, 0),
        // color: Colors.red,
        child: PropertiesWidget(),
      ),
    );
    var TimelineDisplay = Positioned(
      // text info
      bottom: 0,
      left: 0,
      child: Container(
        width: widget.windowWidth,
        height: 200,
        alignment: Alignment(1, 0),
        child: TimelineWidget(timelineHeight: 200),
      ),
    );
    // ref.read(scoreChangeNotifProvider.notifier).set(points);

    return Stack(
      children: [
        mainViewer,
        ActiveToolDisplay(titleBarSize: titleBarSize),
        ToolsDisplay,
        PropertiesDisplay,
        titleBarDisplay,
        TimelineDisplay,
      ],
    );
  }
}
