import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:keymap/keymap.dart';
import 'package:shapey/app_state/app_notifier.dart';
import 'package:shapey/app_state/drawyCommands.dart';
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
  final drawy = Drawy();
  late String stretchStarSvg;
  late String squareStarSvg;
  Vector2 MousePosition = Vector2(0, 0);

  PictureInfo? pictureInfo;

  @override
  void initState() {
    squareStarSvg =
        '''<svg xmlns="http://www.w3.org/2000/svg" width="45" height="45" viewBox="0 0 45 45" fill="#ff00ff">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M22.5 0C21.3776 3.60735 20.3172 6.72669 19.1024 9.40257C15.428 16.3639 9.85267 19.5015 0 22.5C12.7146 27.9655 18.1156 32.4888 22.5 45C26.8844 32.4888 32.2854 27.9655 45 22.5C35.1473 19.5015 29.572 16.3639 25.8976 9.40257C24.6828 6.72669 23.6224 3.60735 22.5 0Z" fill="white"/>
</svg>''';
    vg.loadPicture(SvgStringLoader(squareStarSvg), null).then((value) {
      setState(() {
        pictureInfo = value;
      });
    });

    // test draws
    drawy.addLine([Vector2(20, 40), Vector2(449, 111), Vector2(249, 111)]);
    drawy.addLine([Vector2(120, 40), Vector2(33, 111), Vector2(22, 900)]);
    drawy.load();

    super.initState();
  }

  @override
  void dispose() {
    _repaintNotifier.dispose();
    super.dispose();
  }

  void updateStage(dynamic details) {
    MousePosition = Vector2(details.localPosition.dx, details.localPosition.dy);
  }

  @override
  Widget build(BuildContext context) {
    var appData = ref.watch(appNotifier);
    // tell drawy what mode we're on for performance
    drawy.activeTool = appData.activeTool;
    var penMode = appData.activeTool == ActiveTool.penTool;
    var selectMode = appData.activeTool == ActiveTool.selectTool;

    //RESIZED SHAPE CANVAS
    var sizedPaintWidget = CustomPaint(
      size: Size(widget.width, widget.height),
      painter: _ShapeCanvasPainter(_repaintNotifier, drawy, pictureInfo),
    );

    // TAP GESTURES
    var gestureDetectorWidget = GestureDetector(
      onPanDown: (details) {
        updateStage(details);

        if (penMode) drawy.penMode(DrawyInteract.start, MousePosition);

        if (selectMode) drawy.selectMode(DrawyInteract.start, MousePosition);

        _repaintNotifier.value = !_repaintNotifier.value;
      },
      onPanUpdate: (details) {
        updateStage(details);
        if (selectMode) drawy.selectMode(DrawyInteract.move, MousePosition);
        if (penMode) drawy.penMode(DrawyInteract.move, MousePosition);
        _repaintNotifier.value = !_repaintNotifier.value;
      },
      onPanEnd: (details) {
        if (selectMode) {
          appData.appCommandHistory.executeCommand(
            DrawySelectCommand(drawy, DrawyInteract.end, MousePosition),
          );
        }
        if (penMode) {
          appData.appCommandHistory.executeCommand(
            DrawyPenCommand(drawy, DrawyInteract.end, MousePosition),
          );
        }
        _repaintNotifier.value = !_repaintNotifier.value;
      },

      onPanCancel: () {
        if (selectMode) {
          appData.appCommandHistory.executeCommand(
            DrawySelectCommand(drawy, DrawyInteract.end, MousePosition),
          );
        }
        if (penMode) {
          // print("EXEC CANCEL");
          appData.appCommandHistory.executeCommand(
            DrawyPenCommand(drawy, DrawyInteract.end, MousePosition),
          );
        }
        // _repaintNotifier.value = !_repaintNotifier.value;
      },
      child: sizedPaintWidget,
    );
    return KeyboardWidget(
      // Undo / Redo
      bindings: [
        KeyAction(
          LogicalKeyboardKey.keyP,
          'Pen Tool',
          () => ref.read(appNotifier.notifier).updateTool(ActiveTool.penTool),
        ),
        KeyAction(
          LogicalKeyboardKey.keyA,
          'Select Tool',
          () =>
              ref.read(appNotifier.notifier).updateTool(ActiveTool.selectTool),
        ),
        KeyAction(LogicalKeyboardKey.keyZ, 'Undo', () {
          appData.appCommandHistory.undo();

          _repaintNotifier.value = !_repaintNotifier.value;
        }, isControlPressed: true),
      ],
      child: gestureDetectorWidget,
    );
  }
}

class _ShapeCanvasPainter extends CustomPainter {
  final PictureInfo? pictureInfo;
  final Drawy drawy;

  //unneeded later
  final Paint boxPaint = Paint()
    ..color = Colors
        .blue // Set the desired color (e.g., blue)
    ..style = PaintingStyle.fill; // Fill the rectangle

  _ShapeCanvasPainter(Listenable repaint, this.drawy, this.pictureInfo)
    : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    if (pictureInfo != null) {
      drawy.setCanvas(canvas);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white,
      );
      canvas.save();
      // el.ctx.scale(scale, scale);
      canvas.drawRect(Rect.fromLTWH(0, 0, 20, 20), boxPaint);
      canvas.drawPicture(pictureInfo!.picture);
      // drawy.line(Offset(133, 55), Offset(mousePosition.x, mousePosition.y));
      drawy.update();
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
