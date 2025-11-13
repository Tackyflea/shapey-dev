import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/shape_canvas.dart';
import 'package:shapey/sections/titlebar_widget.dart';
import 'package:shapey/utility/stage_intents.dart';
import 'package:shapey/utility/touch_viewer_widget.dart';
import 'package:shapey/widgets/active_tool_display_widget.dart';
import 'package:shapey/widgets/properties_widget.dart';
import 'package:shapey/timeline.dart';
import 'package:shapey/widgets/tools_widget.dart';

class StageWidget extends ConsumerStatefulWidget {
  const StageWidget({super.key});
  @override
  ConsumerState<StageWidget> createState() => _StageWidgetState();
}

class _StageWidgetState extends ConsumerState<StageWidget> {
  // https://github.com/flutter/packages/tree/main/third_party/packages/flutter_svg
  // https://appsgemacht.de/en/insights/svg-vector-graphics-flutter
  // https://stackoverflow.com/questions/57874374/flutter-draw-svg-in-custompaint-canvas
  @override
  void initState() {
    // INITIAL STAGE SETUP
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(appNotifier.notifier)
          .appCommandHistory
          .executeCommand(
            // sets up layer 0
            AddInitialLayerCommand(
              ref.read(fileNotifier.notifier),
              ref.read(appNotifier.notifier),
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Normal layout
    double sidePanelsY = 40;
    double titleBarSize = 25;
    final List<FileLayer> layers = ref.watch(
      fileNotifier.select((s) => s.layers),
    );
    int currentFrame = ref.watch(appNotifier.select((s) => s.activeFrame));

    List<Widget> layersGroup = [];
    var stageSize = Size(800, 500);
    // generate canvases for each layer data
    for (var layer in layers) {
      layersGroup.add(
        Align(
          alignment: Alignment.center,
          child: ShapeCanvas(
            renderSize: stageSize,
            layerData: layer,
            currentFrame: currentFrame,
          ),
        ),
      );
    }
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
              child: SizedBox.fromSize(
                size: stageSize,
                child: Stack(children: layersGroup),
              ),
            ),
          ),
        ),
      ),
    );

    var titleBarDisplay = Positioned(
      // text info
      left: 0.0,
      right: 0,
      child: LayoutBuilder(
        builder: (context, c) {
          return SizedBox(
            width: c.maxWidth - 4,
            child: const TitleBar(titleBarHeight: 25),
          );
        },
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
      right: 0,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: SizedBox(
          height: 200,
          child: TimelineWidget(timelineHeight: 200),
        ),
      ),
    );

    final Map<Type, Action<Intent>> actionsMap = {
      UndoIntent: UndoAction(ref),
      ToolPenIntent: ToolPenAction(ref),
      ToolSelectIntent: ToolSelectAction(ref),
    };
    // Undo and redo should trigger stage level actions
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyZ, control: true): UndoIntent(),
        SingleActivator(LogicalKeyboardKey.keyP): ToolPenIntent(),
        SingleActivator(LogicalKeyboardKey.keyA): ToolSelectIntent(),
      },
      child: Actions(
        actions: actionsMap,
        child: FocusScope(
          autofocus: true,
          onKeyEvent: (node, event) {
            // Shift listerner
            if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
                event.logicalKey == LogicalKeyboardKey.shiftRight) {
              if (event is KeyDownEvent) {
                ref.read(appNotifier.notifier).setShiftDown(true);
              } else if (event is KeyUpEvent) {
                ref.read(appNotifier.notifier).setShiftDown(false);
              }
            }
            if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
                event.logicalKey == LogicalKeyboardKey.controlRight) {
              if (event is KeyDownEvent) {
                ref.read(appNotifier.notifier).setCtrlDown(true);
              } else if (event is KeyUpEvent) {
                ref.read(appNotifier.notifier).setCtrlDown(false);
              }
            }
            return KeyEventResult.ignored;
          },
          child: Stack(
            children: [
              mainViewer,
              ActiveToolDisplay(titleBarSize: titleBarSize),
              ToolsDisplay,
              PropertiesDisplay,
              titleBarDisplay,
              TimelineDisplay,
            ],
          ),
        ),
      ),
    );
  }
}
