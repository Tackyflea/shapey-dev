// DRAWY START

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class Drawy {
  late Canvas canvasToDrawOn;
  List<DrawyPath> DrawPaths = [];
  DrawyPath PenPath = DrawyPath(pathPoints: []);
  var paint = Paint()
    ..color = Colors.teal
    ..strokeWidth = 15
    ..style = PaintingStyle.stroke;
  void setCanvas(Canvas newCtx) {
    canvasToDrawOn = newCtx;
  }

  void line(Offset p1, Offset p2) => canvasToDrawOn.drawLine(p1, p2, paint);
  void addLine(List<Vector2> points) {
    var newPath = DrawyPath(pathPoints: points);
    newPath.converPointsToPath();
    DrawPaths.add(newPath);
  }

  void penMode(Vector2 mousePosition) {
    PenPath.addPoint(mousePosition.clone());
    // reconverPointsToPath path based off new data
    PenPath.converPointsToPath();
  }

  void update() {
    // generic paths
    var paths = DrawPaths;
    for (var path in paths) {
      path.draw(canvasToDrawOn, paint);
    }

    // pen paths
    PenPath.draw(canvasToDrawOn, paint);
  }
}

class DrawyPath {
  List<Vector2> pathPoints = [];

  DrawyPath({required this.pathPoints});

  var path = Path();

  void draw(Canvas canvasToDrawOn, Paint paintToDrawWith) {
    canvasToDrawOn.drawPath(path, paintToDrawWith);
  }

  void addPoint(Vector2 newPoint) {
    pathPoints.add(newPoint);
  }

  void converPointsToPath() {
    var ptCount = pathPoints.length;
    for (var i = 0; i < ptCount; i++) {
      var pt = pathPoints[i];
      if (i == 0) {
        path.moveTo(pt.x, pt.y);
      } else {
        path.lineTo(pt.x, pt.y);
      }
      // if (i == ptCount - 1) {
      //   path.close();
      // }
    }
  }

  List<Vector2> getPoints() => pathPoints;
}
