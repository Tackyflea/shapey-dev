import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class ShapeCanvas extends StatefulWidget {
  const ShapeCanvas({super.key, this.width = 100, this.height = 100});

  final double width;
  final double height;

  @override
  ShapeCanvasState createState() => ShapeCanvasState();
}

class ShapeCanvasState extends State<ShapeCanvas> {
  final ValueNotifier<bool> _repaintNotifier = ValueNotifier(false);

  late String stretchStarSvg;
  late String squareStarSvg;
  Vector2 MousePosition = Vector2(0, 0);

  PictureInfo? pictureInfo;

  @override
  void initState() {
    squareStarSvg =
        '''<svg xmlns="http://www.w3.org/2000/svg" width="45" height="45" viewBox="0 0 45 45" fill="none">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M22.5 0C21.3776 3.60735 20.3172 6.72669 19.1024 9.40257C15.428 16.3639 9.85267 19.5015 0 22.5C12.7146 27.9655 18.1156 32.4888 22.5 45C26.8844 32.4888 32.2854 27.9655 45 22.5C35.1473 19.5015 29.572 16.3639 25.8976 9.40257C24.6828 6.72669 23.6224 3.60735 22.5 0Z" fill="white"/>
</svg>''';
    vg.loadPicture(SvgStringLoader(squareStarSvg), null).then((value) {
      setState(() {
        pictureInfo = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _repaintNotifier.dispose();
    super.dispose();
  }

  void updateStage(dynamic details) {
    MousePosition.x = details.localPosition.dx;
    MousePosition.y = details.localPosition.dy;
    _repaintNotifier.value = !_repaintNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        updateStage(details);
      },
      onPanUpdate: (details) => {updateStage(details)},
      child: CustomPaint(
        size: Size(widget.width, widget.height),
        painter: _ShapeCanvasPainter(
          _repaintNotifier,
          pictureInfo,
          MousePosition,
        ),
      ),
    );
  }
}

class Drawy {
  final Canvas ctx;
  var paint = Paint()
    ..color = Colors.teal
    ..strokeWidth = 15;
  Drawy(this.ctx);

  void line(Offset p1, Offset p2) => ctx.drawLine(p1, p2, paint);
}

class _ShapeCanvasPainter extends CustomPainter {
  final PictureInfo? pictureInfo;
  Vector2 mousePosition = Vector2(0, 0);
  _ShapeCanvasPainter(Listenable repaint, this.pictureInfo, this.mousePosition)
    : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final drawy = Drawy(canvas);
    if (pictureInfo != null) {
      drawy.ctx.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.blue,
      );
      drawy.ctx.save();
      // el.ctx.scale(scale, scale);
      drawy.ctx.drawPicture(pictureInfo!.picture);
      drawy.line(Offset(133, 55), Offset(mousePosition.x, mousePosition.y));
      drawy.ctx.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
