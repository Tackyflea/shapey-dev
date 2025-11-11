import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/utility/drawy/drawy_path.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:shapey/utility/drawy/drawy.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

// Todo: Implement this maybe https://github.com/Deatsilence/flutter-design-patterns?tab=readme-ov-file#momento
// For undo history
// SHAPE CANVAS
class ShapeCanvas extends ConsumerStatefulWidget {
  final String layerID;
  final int activeFrame;
  final Data? currentLayerFrameData;
  const ShapeCanvas({
    super.key,
    this.width = 100,
    this.height = 100,
    required this.layerID,
    required this.activeFrame,
    required this.currentLayerFrameData,
  });

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
  List<DrawyPath>? layerPaths;
  // late String? activeLayer;
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
    // drawy.addLine([Vector2(20, 40), Vector2(449, 111), Vector2(249, 111)]);
    // drawy.addLine([Vector2(120, 40), Vector2(33, 111), Vector2(22, 900)]);
    // try to grab the initial frame's data
    print(
      'grabbing frame data for ${widget.layerID} at frame ${widget.activeFrame}',
    );
    final FileNotifier fileModel = ref.read(fileNotifier.notifier);
    // FileLayer? layerData = fileModel.getFileLayer(widget.layerID);
    // Data? data = layerData?.frameData.keyFrames?[widget.activeFrame];

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

  // try to fetch any draw paths on the frame , if they exist
  void updatePaths() {
    // final FileNotifier fileModel = ref.read(fileNotifier.notifier);
    // FileLayer? layerData = fileModel.getFileLayer(widget.layerID);
    // layerPaths = layerData?.frameData.keyFrames?[widget.activeFrame]?.drawPaths;
    // print(layerPaths?[0].pathPoints.length);
  }

  @override
  Widget build(BuildContext context) {
    final ActiveTool activeTool = ref.watch(
      appNotifier.select((s) => s.activeTool),
    );

    final AppCommandInvoker appCommandHistory = ref.watch(
      appNotifier.select((s) => s.appCommandHistory),
    );

    final FileNotifier fileModel = ref.read(fileNotifier.notifier);
    // ref.listen(fileNotifier.select((s) => s.layers), (prev, next) {
    //   setState(() {
    //     print('layers changed, refreshing');
    //     updatePaths();
    //     _repaintNotifier.value = !_repaintNotifier.value;
    //   });
    // });
    print("CURRENT FRAME DATA:");
    print(widget.currentLayerFrameData);
    // updatePaths();
    List<DrawyPath>? drawpaths = widget.currentLayerFrameData?.drawPaths;

    // drawy.updatePaths(drawpaths);
    // activeLayer = ref.watch(appNotifier.select((s) => s.activeLayer));

    //This is ^ Only around since you're not directly listening to shape changes YET
    //so like this is good final activeTool = ref.watch(appNotifier.select((s) => s.activeTool));

    // tell drawy what mode we're on for performance
    drawy.activeTool = activeTool;
    var penMode = activeTool == ActiveTool.penTool;
    var selectMode = activeTool == ActiveTool.selectTool;

    //RESIZED SHAPE CANVAS
    var sizedPaintWidget = CustomPaint(
      size: Size(widget.width, widget.height),
      painter: _ShapeCanvasPainter(_repaintNotifier, drawy, pictureInfo),
    );

    void action_mouse_up_or_cancel() {
      // if (activeLayer == null) return print("no active layer");
      if (selectMode) {
        appCommandHistory.executeCommand(
          DrawySelectCommand(drawy, DrawyInteract.end, MousePosition),
        );
      }
      if (penMode) {
        final fileModel = ref.read(fileNotifier.notifier);
        appCommandHistory.executeCommand(
          DrawyPenCommand(drawy, DrawyInteract.end, MousePosition),
        );
      }
      _repaintNotifier.value = !_repaintNotifier.value;
    }

    // TAP GESTURES
    var gestureDetectorWidget = GestureDetector(
      onPanDown: (details) {
        // if (activeLayer == null) return print("no active layer");
        updateStage(details);

        if (penMode) {
          drawy.penMode(DrawyInteract.start, MousePosition);
        }

        if (selectMode) drawy.selectMode(DrawyInteract.start, MousePosition);

        _repaintNotifier.value = !_repaintNotifier.value;
      },
      onPanUpdate: (details) {
        // if (activeLayer == null) return print("no active layer");
        updateStage(details);
        if (selectMode) drawy.selectMode(DrawyInteract.move, MousePosition);
        if (penMode) drawy.penMode(DrawyInteract.move, MousePosition);
        _repaintNotifier.value = !_repaintNotifier.value;
      },
      onPanEnd: (details) => action_mouse_up_or_cancel(),

      onPanCancel: () => action_mouse_up_or_cancel(),
      child: sizedPaintWidget,
    );

    return gestureDetectorWidget;
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
    print("PAINT");
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
