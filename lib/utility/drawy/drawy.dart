import 'package:flutter/material.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'drawy_path.dart';
import 'drawy_point.dart';

// DRAWY START
// max distance to check for from center, when trying to click on a point
double MAX_DISTANCE_TO_POINT = 450;
// distance to check for to a near path
double MAX_DISTANCE_TO_PATH = 30;
// min distance in pen mode, after which we declare that we're in drag mode
double PEN_MINIMUM_DRAG_DISTANCE = 10;
// Min distance at which we mark the path as a closed path
double MIN_DISTANCE_TO_CLOSE = 20;
// the min distance after which we can recognise the point has curves
double MIN_DISTANCE_TO_START_CURVE = 10;

// To indicate what side of the bezier is currently selected
enum DrawyBezierSelected { none, A, B }

// to indicate what kind of guide to draw
enum DrawyGuideType { fullSquare, square, circle, testType }

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

  bool goingInReverse = false;
  // Draws a pan path along mouse position points
  List<DrawyPath> penMode(DrawyInteract interact, Vector2 mousePosition) {
    var startPath = activePath;
    DrawyPoint startPoint;
    List<DrawyPoint>? activePoints = startPath?.getActivePoints();
    // START
    if (interact == DrawyInteract.start) {
      startPoint = DrawyPoint(position: mousePosition);
      // If path doesnt exist or the point's invalid OR you're inside of a path trying to add a point
      // : Make a new path
      if (startPath == null) {
        // creating a new path, starting from first point
        startPath = DrawyPath(pathPoints: []);
        drawPaths.add(startPath);
        activePath = startPath;
      } else if (startPath.pathPoints.length > 1) {
        // first point is active, starting from first point
        var firstPoint = startPath.pathPoints[0];
        if (firstPoint.isActive()) {
          goingInReverse = true;
        }
      }

      startPath.addPoint(startPoint, goingInReverse);

      startPath.setActivePoints([startPoint]);
      // give point curves regardless
      startPath.updatePoint(
        startPoint,
        null,
        newCurve: (mousePosition, mousePosition),
      );
    }
    // if you made 1 single point, you can tweak it
    if (interact == DrawyInteract.move) {
      if (activePoints != null && activePoints.length == 1) {
        startPoint = activePoints[0];
        // grab how far we moved
        var position = startPoint.getPosition();
        // var distanceMoved = position.distanceToSquared(mousePosition);
        // early return if you havent moved enough, or active point gets lost
        // if (distanceMoved < PEN_MINIMUM_DRAG_DISTANCE) return;

        // Since we're now in drag mode, we're adding a control point to wherever
        // the mouse is at now
        var offsetPosition = (mousePosition - position);
        // going backwards, flip curves
        if (goingInReverse) {
          offsetPosition = -offsetPosition;
        }

        startPath?.updatePoint(
          startPoint,
          null,
          newCurve: (position + offsetPosition, position - offsetPosition),
        );
      }
    }

    // clone history at end of interation
    if (interact == DrawyInteract.end && startPath != null) {
      checkAndClosePath(goingInReverse);
      goingInReverse = false;
      savePathStates();
    }

    return drawPaths;
  }

  // close off shape if the point is to close to end of the shape
  void checkAndClosePath(bool inReverse) {
    final path = activePath;
    if (path == null || path.isClosed() || path.getPoints().length <= 2) return;

    final points = path.getActivePoints();
    if (points.isEmpty) return;

    final start = points.first;
    final i = path.getPoints().indexOf(start);
    final atStart = i == 0;
    final atEnd = i == path.getPoints().length - 1;
    if (!atStart && !atEnd) return;

    final otherEnd = atStart ? path.pathPoints.last : path.pathPoints.first;

    final distance = start.getPosition().distanceToSquared(
      otherEnd.getPosition(),
    );
    if (distance < MIN_DISTANCE_TO_CLOSE) {
      debugPrint("closeIt");
      // Note: Commeting out for now, until we figure out how to make individual curves
      // Now when we close the curves overlap each other
      // path.close();
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
      final pt = pickedPoint;
      final a = pt?.thisPointCubicPointEnd;
      final b = pt?.nextPointCubicPointStart;

      bool isValid(Vector2? p) => p != null && pt != null;
      bool isNearMouse(Vector2 p) =>
          p.distanceToSquared(mousePosition) < MAX_DISTANCE_TO_POINT;
      bool isFarFromPoint(Vector2 p) =>
          pt!.getPosition().distanceToSquared(p) > MIN_DISTANCE_TO_START_CURVE;

      if (isValid(a) && isNearMouse(a!) && isFarFromPoint(a)) {
        activeBezier = DrawyBezierSelected.A;
        return;
      }

      if (isValid(b) && isNearMouse(b!) && isFarFromPoint(b)) {
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
    if (interact == DrawyInteract.move && activePath != null) {
      if (pickedPoint != null) {
        // Drag point
        dragPoint(activePath!, pickedPoint, mousePosition);
        // clean up curves at the end, make them lines if they dont need to be curves
        // pickedPoint?.cleanCurves();
        // activePath?.convertPointsToPath();
      } else {
        // Drag path
        //TODO Drag path logic
      }
    }

    // End Drag
    if (interact == DrawyInteract.end) {
      activeBezier = DrawyBezierSelected.none;
      checkAndClosePath(goingInReverse);
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
    var pathCount = drawPaths.length;
    for (int i = 0; i < pathCount; i++) {
      var path = drawPaths[i];
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
          final cubicEnd = pt.thisPointCubicPointEnd;
          final cubicStart = pt.nextPointCubicPointStart;

          drawGuidePoint(DrawyGuideType.fullSquare, pt.getPosition());

          for (final p in [cubicEnd, cubicStart]) {
            if (p != null &&
                pt.getPosition().distanceToSquared(p) >
                    MIN_DISTANCE_TO_START_CURVE) {
              drawGuidePoint(DrawyGuideType.circle, p);
            }
          }
        } else {
          drawGuidePoint(DrawyGuideType.square, pt.getPosition());
        }

        // TEMP v Delete when not needed
        String pos = Offset(pt.getPosition().x, pt.getPosition().y).toString();
        var csV = pt.nextPointCubicPointStart;
        var ceV = pt.thisPointCubicPointEnd;
        String cs = "";
        String ce = "";
        if (csV != null) {
          cs = Offset(csV.x, csV.y).toString();
        }
        if (ceV != null) {
          ce = Offset(ceV.x, ceV.y).toString();
        }
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'ID: $y\n Pos: $pos\ncurveStart: $cs\ncurveEnd $ce',
            style: TextStyle(color: Colors.black, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvasToDrawOn,
          Offset(pt.getPosition().x, pt.getPosition().y),
        );
      }
    }
  }

  void dragPoint(
    DrawyPath pathToCheck,
    DrawyPoint? point,
    Vector2 mousePosition,
  ) {
    if (point == null) {
      return;
    }
    // Move Drag

    final delta = point.getPosition() - mousePosition;
    // BEZIER move mode
    if (activeBezier != DrawyBezierSelected.none) {
      // These are currently mirrors of themselves
      // TODO: Figure out how to split beziers properly so you can individually control them
      Vector2? ctrlA = point.thisPointCubicPointEnd;
      if (activeBezier == DrawyBezierSelected.A && ctrlA != null) {
        pathToCheck.updatePoint(
          point,
          null,
          newCurve: (point.getPosition() + delta, point.getPosition() - delta),
        );
      }
      if (activeBezier == DrawyBezierSelected.B) {
        pathToCheck.updatePoint(
          point,
          null,
          newCurve: (point.getPosition() - delta, point.getPosition() + delta),
        );
      }
      return;
    }

    // POINT move mode
    Vector2? controlA = point.thisPointCubicPointEnd,
        controlB = point.nextPointCubicPointStart;

    Vector2? newBezierA = controlA != null ? controlA - delta : null;
    Vector2? newBezierB = controlB != null ? controlB - delta : null;

    pathToCheck.updatePoint(
      point,
      mousePosition,
      newCurve: (newBezierB, newBezierA),
    );
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
      var pt = pointsToCheckAgainst[i].getPosition();
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
    } else if (typeToDraw == DrawyGuideType.testType) {
      canvasToDrawOn.drawCircle(pos, size / 2, redPaintFull);
      canvasToDrawOn.drawCircle(pos, size / 2, guidePaintStroke);
    }
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
