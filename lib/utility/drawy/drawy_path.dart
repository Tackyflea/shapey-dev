import 'dart:ui';
import 'package:vector_math/vector_math.dart';

import 'drawy_point.dart';

// Generic Path wrapper, allows keeping info in a clean point list instead of relying on
// built in path data
class DrawyPath {
  List<DrawyPoint> pathPoints = [];

  DrawyPath({required this.pathPoints});

  var path = Path();

  void draw(Canvas canvasToDrawOn, Paint paintToDrawWith) {
    canvasToDrawOn.drawPath(path, paintToDrawWith);
  }

  void addPoint(DrawyPoint newPoint, bool? atStart) {
    if (atStart == true) {
      pathPoints.insert(0, newPoint);
      // this is important so once you start drawing, your 0 point isn't at the end
      // so you can start making beziers from start
      pathPoints = pathPoints.reversed.toList();
    } else {
      pathPoints.add(newPoint);
    }
  }

  void setActivePoint(DrawyPoint? newPoint, bool isActive) {
    if (newPoint == null) {
      return;
    }
    int pointIndex = pathPoints.indexOf(newPoint);
    if (pointIndex == -1) {
      // point isn't in the list
      return;
    }
    pathPoints[pointIndex].setActive(isActive);
  }

  // set a group of points on or off, disaling the rest
  void setActivePoints(List<DrawyPoint?> points) {
    for (DrawyPoint currentPoint in pathPoints) {
      setActivePoint(currentPoint, points.contains(currentPoint));
    }
  }

  List<DrawyPoint> getActivePoints() {
    List<DrawyPoint> outPoints = [];
    for (DrawyPoint currentPoint in pathPoints) {
      if (currentPoint.isActive()) {
        outPoints.add(currentPoint);
      }
    }
    return outPoints;
  }

  DrawyPath copy() {
    return DrawyPath(
      pathPoints: pathPoints.map((point) => point.copy()).toList(),
    );
  }

  void convertPointsToPath() {
    var ptCount = pathPoints.length;
    path.reset();

    for (var i = 0; i < ptCount; i++) {
      var endPosition = pathPoints[i].position;
      var isFirstPoint = i == 0;
      var thisPointCubicPointEnd = pathPoints[i].thisPointCubicPointEnd;

      if (isFirstPoint) {
        // First point - just move to position
        path.moveTo(endPosition.x, endPosition.y);
        continue;
      }

      var lastPoint = pathPoints[i - 1];
      if (thisPointCubicPointEnd != null) {
        // Draw cubic bezier curve
        var previousCubicPoint = lastPoint.nextPointCubicPointStart;
        var startControlPoint = thisPointCubicPointEnd;

        if (previousCubicPoint != null) {
          startControlPoint = previousCubicPoint;
        }

        path.cubicTo(
          startControlPoint.x,
          startControlPoint.y,
          thisPointCubicPointEnd.x,
          thisPointCubicPointEnd.y,
          endPosition.x,
          endPosition.y,
        );
      } else {
        // Draw straight line
        path.lineTo(endPosition.x, endPosition.y);
      }
    }
  }

  List<DrawyPoint> getPoints() => pathPoints;
  List<Vector2> getPointAsVectors() {
    List<Vector2> list = [];
    for (var pt in pathPoints) {
      list.add(pt.position);
    }
    return list;
  }
}
