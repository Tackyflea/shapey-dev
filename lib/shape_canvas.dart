import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:shapey/utility/drawy/drawy.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

// Todo: Implement this maybe https://github.com/Deatsilence/flutter-design-patterns?tab=readme-ov-file#momento
// For undo history
// SHAPE CANVAS
class ShapeCanvas extends ConsumerStatefulWidget {
  const ShapeCanvas({super.key, this.width = 100, this.height = 100});

  final double width;
  final double height;

  @override
  ShapeCanvasState createState() => ShapeCanvasState();
}

class ShapeCanvasState extends ConsumerState<ShapeCanvas> {
  final ValueNotifier<bool> _repaintNotifier = ValueNotifier(false);
  late final Drawy drawy;
  Vector2 MousePosition = Vector2(0, 0);

  @override
  void initState() {
    print("setup drawy");
    drawy = Drawy();
    drawy.load();

    super.initState();
  }

  @override
  void dispose() {
    _repaintNotifier.dispose();
    super.dispose();
  }

  // pan start, pan move
  void action_pan_move(DrawyInteract interactType, ActiveTool tool, dynamic e) {
    MousePosition = Vector2(e.localPosition.dx, e.localPosition.dy);

    var penMode = tool == ActiveTool.penTool;
    var selectMode = tool == ActiveTool.selectTool;

    if (penMode) drawy.penMode(interactType, MousePosition);
    if (selectMode) drawy.selectMode(interactType, MousePosition);

    _repaintNotifier.value = !_repaintNotifier.value;
  }

  // pan end
  void action_pan_end(ActiveTool activeTool) {
    final AppCommandInvoker appCommandHistory = ref.read(
      appNotifier.select((s) => s.appCommandHistory),
    );

    if (activeTool == ActiveTool.selectTool) {
      appCommandHistory.executeCommand(
        DrawySelectCommand(drawy, DrawyInteract.end, MousePosition),
      );
    }
    if (activeTool == ActiveTool.penTool) {
      final fileModel = ref.read(fileNotifier.notifier);
      appCommandHistory.executeCommand(
        DrawyPenCommand(
          drawy,
          fileModel,
          DrawyInteract.end,
          MousePosition,
          null,
          null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ActiveTool activeTool = ref.watch(
      appNotifier.select((s) => s.activeTool),
    );

    ref.watch(appNotifier.select((s) => s.appCommandHistory));
    //Reloads the stage on state change
    ref.listen(appNotifier.select((s) => s.stateChange), (prev, next) {
      setState(() {
        _repaintNotifier.value = !_repaintNotifier.value;
      });
    });
    //This is ^ Only around since you're not directly listening to shape changes YET
    //so like this is good final activeTool = ref.watch(appNotifier.select((s) => s.activeTool));
    // TODO: Once we link shapes tolayers, ref.listen teh shapes, and kill .stateChange

    //RESIZED SHAPE CANVAS
    var sizedPaintWidget = CustomPaint(
      size: Size(widget.width, widget.height),
      painter: _ShapeCanvasPainter(_repaintNotifier, drawy),
    );

    // TAP GESTURES
    var gestureDetectorWidget = GestureDetector(
      onPanDown: (details) =>
          action_pan_move(DrawyInteract.start, activeTool, details),
      onPanUpdate: (details) =>
          action_pan_move(DrawyInteract.move, activeTool, details),
      onPanEnd: (details) => action_pan_end(activeTool),
      onPanCancel: () => action_pan_end(activeTool),
      child: sizedPaintWidget,
    );

    return gestureDetectorWidget;
  }
}

class _ShapeCanvasPainter extends CustomPainter {
  final Drawy drawy;

  //unneeded later
  final Paint boxPaint = Paint()
    ..color = Colors
        .blue // Set the desired color (e.g., blue)
    ..style = PaintingStyle.fill; // Fill the rectangle

  _ShapeCanvasPainter(Listenable repaint, this.drawy) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    drawy.setCanvas(canvas);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white,
    );
    canvas.save();
    // el.ctx.scale(scale, scale);
    canvas.drawRect(Rect.fromLTWH(0, 0, 20, 20), boxPaint);
    // drawy.line(Offset(133, 55), Offset(mousePosition.x, mousePosition.y));
    drawy.update();
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
