// DRAWY START

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class Drawy {
  late Canvas canvasToDrawOn;
  List<DrawyPath> drawPaths = [];
  DrawyPath penPath = DrawyPath(pathPoints: []);
  var paint = Paint()
    ..color = Color.fromARGB(255, 28, 134, 236)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  void setCanvas(Canvas newCtx) {
    canvasToDrawOn = newCtx;
  }

  void line(Offset p1, Offset p2) => canvasToDrawOn.drawLine(p1, p2, paint);
  void addLine(List<Vector2> points) {
    var newPath = DrawyPath(pathPoints: points);
    newPath.converPointsToPath();
    drawPaths.add(newPath);
  }

  void penMode(Vector2 mousePosition) {
    penPath.addPoint(mousePosition.clone());
    // reconverPointsToPath path based off new data
    penPath.converPointsToPath();
  }

  void update() {
    // generic paths
    var paths = drawPaths;
    for (var path in paths) {
      path.draw(canvasToDrawOn, paint);
    }

    // pen paths
    penPath.draw(canvasToDrawOn, paint);
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
