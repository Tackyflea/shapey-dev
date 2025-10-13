// DRAWY START

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

// max distance to check for from center, when trying to click on a point
double MAX_DISTANCE_TO_POINT = 550;
// min distance in pen mode, after which we declare that we're in drag mode
double PEN_MINIMUM_DRAG_DISTANCE = 50;

class Drawy {
  late Canvas canvasToDrawOn;
  late ActiveTool activeTool = ActiveTool.selectTool;

  // Generic list of paths to draw for testing
  // TODO: Unify them with any other types of paths into a list of drawyObjects
  List<DrawyPath> drawPaths = [];

  // PEN SETTINGS
  // Pen is a custom live path, that we can swap the definition of
  // depending on what you want to add points to
  DrawyPath penPath = DrawyPath(pathPoints: []);
  DrawyPath? activePath;
  int activePathSelectedIndex = -1;

  var paint = Paint()
    ..color = Color.fromARGB(255, 28, 134, 236)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  var GUIDE_PEN_PAINT_FILL = Paint()
    ..color = Color.fromRGBO(22, 201, 255, 0.196)
    ..style = PaintingStyle.fill;

  var GUIDE_PEN_PAINT_STROKE = Paint()
    ..color = Color.fromARGB(255, 28, 134, 236)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;
  void setCanvas(Canvas newCtx) {
    canvasToDrawOn = newCtx;
  }

  void setup() {
    // add dynamic pen path to the general path list
    drawPaths.add(penPath);
  }

  void line(Offset p1, Offset p2) => canvasToDrawOn.drawLine(p1, p2, paint);
  void addLine(List<Vector2> positions) {
    // so we can keep drawypoints as an internal class
    // we convert it inside

    List<DrawyPoint> drawyPointList = [];
    for (var pos in positions) {
      drawyPointList.add(DrawyPoint(position: pos));
    }
    var newPath = DrawyPath(pathPoints: drawyPointList);
    newPath.converPointsToPath();
    drawPaths.add(newPath);
  }

  // Draws a pan path along mouse position points
  void penMode(DrawyInteract interact, Vector2 mousePosition) {
    // START
    if (interact == DrawyInteract.START) {
      DrawyPoint newPoint = DrawyPoint(position: mousePosition);
      penPath.addPoint(newPoint);
      // reconverPointsToPath path based off new data
      penPath.converPointsToPath();

      var tempPath = penPath;
      // This might be kind of overkill, since atm we already KNOW it's the path.lenght - 1
      // but maybe we won't in the future
      activePathSelectedIndex = tempPath.getPointAsVectors().indexOf(
        newPoint.position,
      );
      activePath = tempPath;
    }
    if (interact == DrawyInteract.MOVE && activePath != null) {
      var activePoint = activePath?.pathPoints[activePathSelectedIndex];
      // grab how far we moved
      var position = activePoint?.position;
      var distanceMoved = position?.distanceToSquared(mousePosition);

      if (distanceMoved == null || activePoint == null || position == null)
        return;
      if (distanceMoved < PEN_MINIMUM_DRAG_DISTANCE) return;

      // Since we're now in drag mode, we're adding a control point to wherever
      // the mouse is at now
      var offsetPosition = (mousePosition - position);
      activePoint.cubicControlPointA = (position) - offsetPosition;
      activePoint.cubicControlPointB = (position) + offsetPosition;
      // reconverPointsToPath path based off new data
      penPath.converPointsToPath();
    }

    if (interact == DrawyInteract.END) {
      // print('end');
    }
  }

  // try to fetch a nearby pen point
  void selectMode(DrawyInteract interact, Vector2 mousePosition) {
    // Start Drag
    if (interact == DrawyInteract.START) {
      var (nearPath, nearIndex) = getClosestPointOnAPath(mousePosition);
      if (nearPath != null) {
        activePath = nearPath;
        activePathSelectedIndex = nearIndex;
      } else {
        // reset if we havent found anything
        activePath = null;
        activePathSelectedIndex = -1;
      }
    }

    // Move Drag
    if (interact == DrawyInteract.MOVE) {
      bool youHaveAPathSelected = activePath != null;

      if (youHaveAPathSelected) {
        final List<DrawyPoint>? tempPoints = activePath?.pathPoints;

        final currentSelectedPoint = tempPoints?[activePathSelectedIndex];
        if (currentSelectedPoint != null) {
          // Bezier logic on drag, could be overkill
          final delta = currentSelectedPoint.position - mousePosition;
          Vector2? controlA = currentSelectedPoint.cubicControlPointA,
              controlB = currentSelectedPoint.cubicControlPointB;

          Vector2? newBezierA = controlA != null ? controlA - delta : null;
          Vector2? newBezierB = controlB != null ? controlB - delta : null;

          tempPoints?[activePathSelectedIndex] = DrawyPoint(
            position: mousePosition,
            cubicControlPointA: newBezierA,
            cubicControlPointB: newBezierB,
          );
          activePath?.converPointsToPath();
        }
      }
    }

    // End Drag
    if (interact == DrawyInteract.END) {
      // activePath = null;
      // activePathSelectedIndex = -1;
    }
  }

  void update() {
    // DRAW

    // draw all paths
    // Todo , swap this with a static list
    for (var path in drawPaths) {
      path.draw(canvasToDrawOn, paint);
    }

    // GUIDE LAYERS

    // pen paths
    final pathNullChecked = activePath;
    // check we both have a path and the index is IN the path
    if (pathNullChecked != null && activePathSelectedIndex != -1) {
      DrawyPoint selectedPoint =
          pathNullChecked.pathPoints[activePathSelectedIndex];

      // draw guides
      drawGuidePoint(selectedPoint.position);
      // and potential bezier guides. Null checks inside function
      drawGuidePoint(selectedPoint.cubicControlPointA);
      drawGuidePoint(selectedPoint.cubicControlPointB);
    }
  }

  // Utility

  // Try to find the closest path to the vector you supply
  // AND the point at which you hit the path
  (DrawyPath? pathToGet, int pathIndex) getClosestPointOnAPath(
    Vector2 vectorToCheck,
  ) {
    DrawyPath? returnPath;
    int returnIndex = -1;
    var nearestDistance = double.infinity;
    for (DrawyPath pathToCheck in drawPaths) {
      var (nearIndex, distanceReturned) = getClosestVectorIndexToVector(
        vectorToCheck,
        pathToCheck.pathPoints,
      );
      if (nearIndex != -1 && distanceReturned < nearestDistance) {
        nearestDistance = distanceReturned;
        // assign the active path to the closest path to the interaction
        returnPath = pathToCheck;
        returnIndex = nearIndex;
      }
    }
    return (returnPath, returnIndex);
  }

  (int index, double distance) getClosestVectorIndexToVector(
    Vector2 vectorToCheck,
    List<DrawyPoint> pointsToCheckAgainst,
  ) {
    int index = -1;
    var distanceToCheckAgainst = MAX_DISTANCE_TO_POINT;
    int amountOfPoints = pointsToCheckAgainst.length;
    for (int i = 0; i < amountOfPoints; i++) {
      var pt = pointsToCheckAgainst[i].position;
      var distance = pt.distanceToSquared(vectorToCheck);
      if (distanceToCheckAgainst > distance) {
        distanceToCheckAgainst = distance;
        index = i;
      }
    }
    return (index, distanceToCheckAgainst);
  }

  void drawGuidePoint(Vector2? position) {
    if (position == null) {
      return;
    }
    canvasToDrawOn.drawRect(
      Rect.fromCenter(
        center: Offset(position.x, position.y),
        width: 10,
        height: 10,
      ),
      GUIDE_PEN_PAINT_FILL,
    );
    canvasToDrawOn.drawRect(
      Rect.fromCenter(
        center: Offset(position.x, position.y),
        width: 10,
        height: 10,
      ),
      GUIDE_PEN_PAINT_STROKE,
    );
  }
}

// Generic Point which can be expanded with more data than just position
class DrawyPoint {
  Vector2 position;
  Vector2? cubicControlPointA;
  Vector2? cubicControlPointB;

  DrawyPoint({
    required this.position,
    this.cubicControlPointA,
    this.cubicControlPointB,
  });
}

// Generic Path wrapper, allows keeping info in a clean point list instead of relying on
// built in path data
class DrawyPath {
  List<DrawyPoint> pathPoints = [];

  DrawyPath({required this.pathPoints});

  var path = Path();

  void draw(Canvas canvasToDrawOn, Paint paintToDrawWith) {
    canvasToDrawOn.drawPath(path, paintToDrawWith);
  }

  void addPoint(DrawyPoint newPoint) {
    pathPoints.add(newPoint);
  }

  void converPointsToPath() {
    var ptCount = pathPoints.length;
    path.reset();
    for (var i = 0; i < ptCount; i++) {
      var endPosition = pathPoints[i].position;
      var cubicControlPointA = pathPoints[i].cubicControlPointA;
      var cubicControlPointB = pathPoints[i].cubicControlPointB;

      if (i == 0) {
        // first point just tap
        path.moveTo(endPosition.x, endPosition.y);
      } else {
        // second point add points
        if (cubicControlPointA != null && cubicControlPointB != null) {
          // curve into position if we have a curve point
          path.cubicTo(
            cubicControlPointA.x,
            cubicControlPointA.y,

            cubicControlPointA.x,
            cubicControlPointA.y,
            endPosition.x,
            endPosition.y,
          );
        } else {
          // back up to just line
          path.lineTo(endPosition.x, endPosition.y);
        }
      }
      // if (i == ptCount - 1) {
      //   path.close();
      // }
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
