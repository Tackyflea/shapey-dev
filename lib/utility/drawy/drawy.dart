// DRAWY START

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

// max distance to check for from center, when trying to click on a point
double MAX_DISTANCE_TO_POINT = 450;
// distance to check for to a near path
double MAX_DISTANCE_TO_PATH = 30;
// min distance in pen mode, after which we declare that we're in drag mode
double PEN_MINIMUM_DRAG_DISTANCE = 10;

// To indicate what side of the bezier is currently selected
enum DrawyBezierSelected { none, A, B }

// to indicate what kind of guide to draw
enum DrawyGuideType { fullSquare, square, circle, TEST }

class Drawy {
  late Canvas canvasToDrawOn;
  late ActiveTool activeTool = ActiveTool.selectTool;

  // POST loading any initial data, we save the history
  // so we have an initial state to revert to
  void load() {
    savePathStates();
  }

  // Generic list of paths to draw for testing
  // TODO: Unify them with any other types of paths into a list of drawyObjects
  List<DrawyPath> drawPaths = [];

  // PEN SETTINGS
  // Pen is a custom live path, that we can swap the definition of
  // depending on what you want to add points to
  DrawyPath? activePath;

  DrawyBezierSelected activeBezier =
      DrawyBezierSelected.none; // for tweaking paths

  List<List<DrawyPath>> drawPathHistory = [];
  List<int?> activePathHistory = [];

  var PEN_DEFAULT_STROKE = Paint()
    ..color = Color.fromARGB(255, 28, 134, 236)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  void setCanvas(Canvas newCtx) {
    canvasToDrawOn = newCtx;
  }

  void line(Offset p1, Offset p2) =>
      canvasToDrawOn.drawLine(p1, p2, PEN_DEFAULT_STROKE);
  void addLine(List<Vector2> positions) {
    // so we can keep drawypoints as an internal class
    // we convert it inside

    List<DrawyPoint> drawyPointList = [];
    for (var pos in positions) {
      drawyPointList.add(DrawyPoint(position: pos));
    }
    var newPath = DrawyPath(pathPoints: drawyPointList);
    newPath.convertPointsToPath();
    drawPaths.add(newPath);
  }

  // Draws a pan path along mouse position points
  void penMode(DrawyInteract interact, Vector2 mousePosition) {
    var startPath = activePath;
    List<DrawyPoint>? activePoints = startPath?.getActivePoints();
    // START
    if (interact == DrawyInteract.start) {
      DrawyPoint newPoint = DrawyPoint(position: mousePosition);
      // If path doesnt exist or the point's invalid OR you're inside of a path trying to add a point
      // : Make a new path
      var pointAtBeggining = false;
      if (startPath == null) {
        // creating a new path, starting from first point
        startPath = DrawyPath(pathPoints: []);
        drawPaths.add(startPath);
        activePath = startPath;
      } else if (startPath.pathPoints.isNotEmpty) {
        // first point is active, starting from first point
        var firstPoint = startPath.pathPoints[0];
        if (firstPoint.isActive()) {
          pointAtBeggining = true;
        }
      }

      startPath.addPoint(newPoint, pointAtBeggining);

      // reconvertPointsToPath path based off new data
      startPath.convertPointsToPath();

      startPath.setActivePoints([newPoint]);
    }
    // if you made 1 single point, you can tweak it
    if (interact == DrawyInteract.move) {
      if (activePoints != null && activePoints.length == 1) {
        // grab how far we moved
        var position = activePoints[0].position;
        var distanceMoved = position.distanceToSquared(mousePosition);
        // early return if you havent moved enough, or active point gets lost
        if (distanceMoved < PEN_MINIMUM_DRAG_DISTANCE) return;
        // Since we're now in drag mode, we're adding a control point to wherever
        // the mouse is at now
        var offsetPosition = (mousePosition - position);
        print(offsetPosition);
        activePoints[0].updateCurves(
          position - offsetPosition,
          position + offsetPosition,
        );
        print(activePath);
        // reconvertPointsToPath path based off new data
        activePath?.convertPointsToPath();
      }
    }

    // clone history at end of interation
    if (interact == DrawyInteract.end && startPath != null) {
      savePathStates();
    }
  }

  // Saves a history of the paths on stage
  // a history of active paths, AND a history of active points
  // TODO: Limit history count to save on memory
  // TODO: Make active point as part of the draw path since they're connected (and you can have multiple)
  // TODO: Make active path part of path, since you could have multiple paths selected
  void savePathStates() {
    // save paths
    drawPathHistory.add(drawPaths.map((path) => path.copy()).toList());
    var tempPath = activePath;
    if (tempPath != null) {
      // save active path
      int activePathIndex = drawPaths.indexOf(tempPath);
      activePathHistory.add(activePathIndex);
    } else {
      activePathHistory.add(null);
    }
  }

  void undoPen() => revertPathStates();
  void undoSelect() => revertPathStates();

  void revertPathStates() {
    if (drawPathHistory.length >= 2) {
      drawPathHistory.removeLast();
      activePathHistory.removeLast();

      // Get the last state
      drawPaths = drawPathHistory.last
          .map((path) => path.copy()..convertPointsToPath())
          .toList();
      var lastPathNumber = activePathHistory.last;

      if (lastPathNumber != null) {
        // revert back to last path
        activePath = drawPaths[lastPathNumber];
      } else {
        // or to nothing if there was none
        activePath = null;
      }
    }
  }

  // try to fetch a nearby pen point
  void selectMode(DrawyInteract interact, Vector2 mousePosition) {
    // Start Drag

    List<DrawyPoint>? activePoints = activePath?.getActivePoints();
    // TODO: Deal with multi select
    DrawyPoint? pickedPoint;
    if (activePoints != null && activePoints.isNotEmpty) {
      pickedPoint = activePoints[0];
    }

    if (interact == DrawyInteract.start) {
      // BEZIER ACTIVE CHECK
      // check if youre trying to edit hte beziers, if they exist
      Vector2? cubicPtA = pickedPoint?.thisPointCubicPointEnd,
          cubicPtB = pickedPoint?.nextPointCubicPointStart;

      if (cubicPtA != null &&
          cubicPtA.distanceToSquared(mousePosition) < MAX_DISTANCE_TO_POINT) {
        activeBezier = DrawyBezierSelected.A;
        return;
      }
      if (cubicPtB != null &&
          cubicPtB.distanceToSquared(mousePosition) < MAX_DISTANCE_TO_POINT) {
        activeBezier = DrawyBezierSelected.B;
        return;
      }

      // try to find a near path
      var (nearPath, nearIndex) = _getClosestPointOnAPath(mousePosition);
      if (nearPath != null) {
        activePath = nearPath;
        pickedPoint = nearPath.pathPoints[nearIndex];
        nearPath.setActivePoints([pickedPoint]);
      } else {
        // reset if we havent found anything
        activePath?.setActivePoints([]);
        activePath = null;
      }

      // couldn't find a point, so lets try to see if it's near a path
      if (nearPath == null) {
        for (DrawyPath drawyPath in drawPaths) {
          var nearPath = _pointNearPath(
            drawyPath.path,
            mousePosition,
            MAX_DISTANCE_TO_PATH,
          );
          if (nearPath) {
            activePath = drawyPath;
            break;
          }
        }
      }
    }
    if (interact == DrawyInteract.move) {
      if (pickedPoint != null) {
        // Drag point
        dragPoint(pickedPoint, mousePosition);
      } else {
        // Drag path
        //TODO Drag path logic
      }
    }

    // End Drag
    if (interact == DrawyInteract.end) {
      activeBezier = DrawyBezierSelected.none;
      savePathStates();
    }
  }

  bool _pointNearPath(Path path, Vector2 point, double tolerance) {
    Offset pointO = Offset(point.x, point.y);
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 1) {
        final pos = metric.getTangentForOffset(d)!.position;
        if ((pos - pointO).distance <= tolerance) return true;
      }
    }
    return false;
  }

  void update() {
    // DRAW

    // draw all paths
    // Todo , swap this with a static list
    for (var path in drawPaths) {
      path.draw(canvasToDrawOn, PEN_DEFAULT_STROKE);

      // don't draw anything else if path isn't selected
      if (activePath == null || path != activePath) {
        continue;
      }
      // GUIDE LAYERS
      // draw guides for all points in ACTIVE path, and a special guide for selected point
      var pointCount = path.pathPoints.length;
      for (int y = 0; y < pointCount; y++) {
        DrawyPoint pt = path.pathPoints[y];

        if (pt.isActive()) {
          drawGuidePoint(DrawyGuideType.fullSquare, pt.position);
          if (pt.thisPointCubicPointEnd != null) {
            drawGuidePoint(DrawyGuideType.circle, pt.thisPointCubicPointEnd);
          }
          if (pt.nextPointCubicPointStart != null) {
            drawGuidePoint(DrawyGuideType.circle, pt.nextPointCubicPointStart);
          }
        } else {
          // normal guides
          drawGuidePoint(DrawyGuideType.square, pt.position);
        }
      }
    }
  }

  void dragPoint(DrawyPoint? point, Vector2 mousePosition) {
    if (point == null) {
      return;
    }
    // Move Drag

    final delta = point.position - mousePosition;
    // BEZIER move mode
    if (activeBezier != DrawyBezierSelected.none) {
      // These are currently mirrors of themselves
      // TODO: Figure out how to split beziers properly so you can individually control them
      Vector2? ctrlA = point.thisPointCubicPointEnd;
      if (activeBezier == DrawyBezierSelected.A && ctrlA != null) {
        point.updateCurves(point.position + delta, point.position - delta);
      }
      if (activeBezier == DrawyBezierSelected.B) {
        point.updateCurves(point.position - delta, point.position + delta);
      }
      activePath?.convertPointsToPath();
      return;
    }

    // POINT move mode
    Vector2? controlA = point.thisPointCubicPointEnd,
        controlB = point.nextPointCubicPointStart;

    Vector2? newBezierA = controlA != null ? controlA - delta : null;
    Vector2? newBezierB = controlB != null ? controlB - delta : null;

    point.position = mousePosition;
    point.updateCurves(newBezierB, newBezierA);

    activePath?.convertPointsToPath();
  }

  // Utility

  // Try to find the closest path to the vector you supply
  // AND the point at which you hit the path

  (DrawyPath? pathToGet, int pathIndex) _getClosestPointOnAPath(
    Vector2 vectorToCheck,
  ) {
    DrawyPath? returnPath;
    int returnIndex = -1;
    var nearestDistance = double.infinity;
    for (DrawyPath pathToCheck in drawPaths) {
      var (nearIndex, distanceReturned) = _getClosestVectorIndexToVector(
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

  (int index, double distance) _getClosestVectorIndexToVector(
    Vector2 vectorToCheck,
    List<DrawyPoint> pointsToCheckAgainst,
  ) {
    int index = -1;
    var distanceToCheckAgainst = MAX_DISTANCE_TO_POINT;
    int amountOfPoints = pointsToCheckAgainst.length;
    for (int i = 0; i < amountOfPoints; i++) {
      var pt = pointsToCheckAgainst[i].position;
      // POSITION CHECK
      var distance = pt.distanceToSquared(vectorToCheck);
      if (distanceToCheckAgainst > distance) {
        distanceToCheckAgainst = distance;
        index = i;
      }
    }
    return (index, distanceToCheckAgainst);
  }

  // GUIDES
  Paint guidePaintSemiFull = Paint()
    ..color = Color.fromRGBO(22, 201, 255, 0.196)
    ..style = PaintingStyle.fill;
  Paint guidePaintFull = Paint()
    ..color = Color.fromRGBO(22, 201, 255, 1)
    ..style = PaintingStyle.fill;

  Paint redPaintFull = Paint()
    ..color = Color.fromRGBO(212, 0, 0, 1)
    ..style = PaintingStyle.fill;

  Paint guidePaintStroke = Paint()
    ..color = Color.fromARGB(255, 28, 134, 236)
    ..strokeWidth = 1
    ..style = PaintingStyle.stroke;

  void drawGuidePoint(DrawyGuideType typeToDraw, Vector2? position) {
    if (position == null) {
      return;
    }
    double size = 9;
    Offset pos = Offset(position.x, position.y);

    if (typeToDraw == DrawyGuideType.square) {
      canvasToDrawOn.drawRect(
        Rect.fromCenter(center: pos, width: size, height: size),
        guidePaintSemiFull,
      );

      canvasToDrawOn.drawRect(
        Rect.fromCenter(center: pos, width: size, height: size),
        guidePaintStroke,
      );
    } else if (typeToDraw == DrawyGuideType.fullSquare) {
      canvasToDrawOn.drawRect(
        Rect.fromCenter(center: pos, width: size, height: size),
        guidePaintFull,
      );
    } else if (typeToDraw == DrawyGuideType.circle) {
      canvasToDrawOn.drawCircle(pos, size / 2, guidePaintSemiFull);
      canvasToDrawOn.drawCircle(pos, size / 2, guidePaintStroke);
    } else if (typeToDraw == DrawyGuideType.TEST) {
      canvasToDrawOn.drawCircle(pos, size / 2, redPaintFull);
      canvasToDrawOn.drawCircle(pos, size / 2, guidePaintStroke);
    }
  }
}

// Generic Point which can be expanded with more data than just position
class DrawyPoint {
  Vector2 position;
  // control points are for MATH for controls

  // Default End Cubic , we use the current path
  Vector2? thisPointCubicPointEnd;
  // the default start Cublic , we use the last point's end cubic
  Vector2? nextPointCubicPointStart;
  // Indicates path is selected
  bool active = false;

  DrawyPoint({required this.position}) {
    updatePoint(position);
  }

  void updatePoint(Vector2 newPosition) {
    position = newPosition;
  }

  void setActive(bool newActive) {
    active = newActive;
  }

  bool isActive() => active;

  void updateCurves(
    Vector2? newCubicPointStart,
    Vector2? newPointCubicPointEnd,
  ) {
    nextPointCubicPointStart = newCubicPointStart;
    thisPointCubicPointEnd = newPointCubicPointEnd;
  }

  DrawyPoint copy() {
    var clonePoint = DrawyPoint(position: Vector2.copy(position));
    clonePoint.updateCurves(
      nextPointCubicPointStart?.clone(),
      thisPointCubicPointEnd?.clone(),
    );
    clonePoint.active = isActive();
    return clonePoint;
  }
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

  void addPoint(DrawyPoint newPoint, bool? atStart) {
    if (atStart == true) {
      pathPoints.insert(0, newPoint);
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
      DrawyPoint? lastPoint;
      if (i > 0) {
        lastPoint = pathPoints[i - 1];
      }
      var thisPointCubicPointEnd = pathPoints[i].thisPointCubicPointEnd;

      if (i == 0) {
        // first point just tap
        path.moveTo(endPosition.x, endPosition.y);
      } else {
        // second point add points
        if (thisPointCubicPointEnd != null) {
          Vector2? preExistingCubicPoint;
          // attempt to use the last point's bezier as a guide
          if (lastPoint != null && lastPoint.nextPointCubicPointStart != null) {
            preExistingCubicPoint = lastPoint.nextPointCubicPointStart;
          }
          // curve into position if we have a curve point
          path.cubicTo(
            preExistingCubicPoint != null
                ? preExistingCubicPoint.x
                : thisPointCubicPointEnd.x,
            preExistingCubicPoint != null
                ? preExistingCubicPoint.y
                : thisPointCubicPointEnd.y,

            thisPointCubicPointEnd.x,
            thisPointCubicPointEnd.y,
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

class DrawyGuide {
  DrawyPoint pathPoint;

  DrawyGuide({required this.pathPoint});

  var path = Path();

  void draw(Canvas canvasToDrawOn, Paint paintToDrawWith) {
    // canvasToDrawOn.drawPath(path, paintToDrawWith);
  }

  void addGuide(DrawyPoint newPoint) {
    // pathPoints.add(newPoint);
  }
}
