import 'dart:ui';
import 'package:vector_math/vector_math.dart';

import 'drawy_point.dart';

// Generic Path wrapper, allows keeping info in a clean point list instead of relying on
// built in path data
class DrawyPath {
  // the VISUAL path
  var path = Path();

  // The REAL point data
  List<DrawyPoint> pathPoints = [];

  // indicates to draw path closed or not
  var closed = false;

  DrawyPath({required this.pathPoints});

  void draw(Canvas canvasToDrawOn, Paint paintToDrawWith) {
    canvasToDrawOn.drawPath(path, paintToDrawWith);
  }

  void addPoint(DrawyPoint newPoint, bool? atStart) {
    if (atStart == true) {
      pathPoints.insert(0, newPoint);
      // this is important so once you start drawing, your 0 point isn't at the end
      // so you can start making beziers from start
      // pathPoints = pathPoints.reversed.toList();
    } else {
      pathPoints.add(newPoint);
    }
  }

  // update individual point data on path
  void updatePoint(
    DrawyPoint pointToUpdate,
    Vector2? newP, {
    (Vector2?, Vector2?)? newCurve,
  }) {
    if (newP != null) {
      pointToUpdate.updatePosition(newP);
    }
    if (newCurve != null) {
      pointToUpdate.updateCurves(newCurve.$1, newCurve.$2);
    }

    convertPointsToPath();
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
    var pathCopy = DrawyPath(
      pathPoints: pathPoints.map((point) => point.copy()).toList(),
    );
    pathCopy.closed = closed;

    return pathCopy;
  }

  void convertPointsToPath() {
    var ptCount = pathPoints.length;
    path.reset();

    for (var i = 0; i < ptCount; i++) {
      var endPosition = pathPoints[i].getPosition();
      var isFirstPoint = i == 0;
      var thisPointCubicPointEnd = pathPoints[i].thisPointCubicPointEnd;

      if (isFirstPoint) {
        // First point - just move to position
        path.moveTo(endPosition.x, endPosition.y);
        continue;
      }

      var lastPoint = pathPoints[i - 1];
      // TODO: DONT TO THIS this function is for visual updates only
      // NOT to actually change point data, this could break history
      // if (i == ptCount - 1 && isClosed()) {
      //   // you're on the last point, check if its a closed one
      //   print("i'm on last point, AND its closed");
      //   // snap it to the first point of the closed shape
      //   pathPoints[i].updatePosition(pathPoints[0].getPosition());
      // }
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
      list.add(pt.getPosition());
    }
    return list;
  }

  // mark path as closed and make the last point be where first point is
  void close() {
    closed = true;
    // pathPoints[pathPoints.length - 1].getPosition() = pathPoints[0].getPosition();
  }

  bool isClosed() => closed;
}
