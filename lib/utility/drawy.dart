// DRAWY START

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/enums/e_interact_type.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

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
  void penMode(Vector2 mousePosition) {
    DrawyPoint newPoint = DrawyPoint(position: mousePosition);
    penPath.addPoint(newPoint);
    // reconverPointsToPath path based off new data
    penPath.converPointsToPath();
  }

  // try to fetch a nearby pen point
  void selectMode(InteractType interact, Vector2 mousePosition) {
    // Start Drag
    if (interact == InteractType.START) {
      var (nearPath, nearIndex) = getClosestPointOnAPath(mousePosition);
      if (nearPath != null) {
        activePath = nearPath;
        activePathSelectedIndex = nearIndex;
      }
    }

    // Move Drag
    if (interact == InteractType.MOVE) {
      bool youHaveAPathSelected =
          activePath != null && activePathSelectedIndex != -1;

      if (youHaveAPathSelected) {
        activePath!.pathPoints[activePathSelectedIndex] = DrawyPoint(
          position: mousePosition,
        );
        activePath!.converPointsToPath();
      }
    }

    // End Drag
    if (interact == InteractType.END) {
      activePath = null;
      activePathSelectedIndex = -1;
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
    // draw some guides in select mode
    if (activeTool == ActiveTool.selectTool) {
      final pathNullChecked = activePath;
      // check we both have a path and the index is IN the path
      if (pathNullChecked != null && activePathSelectedIndex != -1) {
        drawGuidePoint(pathNullChecked.pathPoints[activePathSelectedIndex]);
      }
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
    // arbitrary for now , max distance to check against
    double closestDistance = 550;
    int index = -1;
    int amountOfPoints = pointsToCheckAgainst.length;
    for (int i = 0; i < amountOfPoints; i++) {
      var pt = pointsToCheckAgainst[i].position;
      if (pt == null) {
        continue;
      }
      var distance = pt.distanceToSquared(vectorToCheck);
      if (closestDistance > distance) {
        closestDistance = distance;
        index = i;
      }
    }
    return (index, closestDistance);
  }

  void drawGuidePoint(DrawyPoint point) {
    canvasToDrawOn.drawRect(
      Rect.fromCenter(
        center: Offset(point.position.x, point.position.y),
        width: 10,
        height: 10,
      ),
      GUIDE_PEN_PAINT_FILL,
    );
    canvasToDrawOn.drawRect(
      Rect.fromCenter(
        center: Offset(point.position.x, point.position.y),
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
  final Vector2? bezierControlPoint;

  DrawyPoint({required this.position, this.bezierControlPoint});
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
      var pt = pathPoints[i].position;

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

  List<DrawyPoint> getPoints() => pathPoints;
}
