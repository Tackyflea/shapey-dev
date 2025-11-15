import 'package:flutter/material.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/utility/drawy/components/drawy_point.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'drawy_path.dart';

// DRAWY START
// max distance to check for from center, when trying to click on a point
double MAX_DISTANCE_TO_POINT = 9999;
// distance to check for to a near path
double MAX_DISTANCE_TO_PATH = 30;
// min distance in pen mode, after which we declare that we're in drag mode
double PEN_MINIMUM_DRAG_DISTANCE = 10;
// Min distance at which we mark the path as a closed path
double MIN_DISTANCE_TO_CLOSE = 20;
// the min distance after which we can recognise the point has curves
double MIN_DISTANCE_TO_START_CURVE = 50;

// To indicate what side of the bezier is currently selected
enum DrawyBezierSelected { none, A, B }

// to indicate what kind of guide to draw
enum DrawyGuideType { fullSquare, square, circle, testType }

class Drawy {
  void load(Data? frameData) {
    if (frameData == null) {
      drawPaths = [];
      return;
    }
    drawPaths = frameData.drawPaths.map((p) => p.copy()).toList();
  }

  // local REFERENCE of the active layer draw paths. Gets auto updated on refresh / draw/ update
  List<DrawyPath> drawPaths = [];

  // PEN SETTINGS
  // Pen is a custom live path
  // for temporary use while selecting
  List<DrawyPath> selectPathsToManipulate = [];
  DrawyBezierSelected activeBezier =
      DrawyBezierSelected.none; // for tweaking paths

  var PEN_DEFAULT_STROKE = Paint()
    ..color = Color.fromARGB(255, 28, 134, 236)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;
  void line(Canvas canvasToDrawOn, Offset p1, Offset p2) =>
      canvasToDrawOn.drawLine(p1, p2, PEN_DEFAULT_STROKE);

  bool goingInReverse = false;
  // Draws a pan path along mouse position points
  List<DrawyPath> penMode(DrawyInteract interact, Vector2 mousePosition) {
    DrawyPath? startPath;

    // look for first path you can find with an active tag
    for (var path in drawPaths) {
      if (path.isActive == true) {
        startPath = path;
        break;
      }
    }
    DrawyPoint startPoint;
    List<DrawyPoint>? activePoints = startPath?.getActivePoints();
    // START
    if (interact == DrawyInteract.start) {
      startPoint = DrawyPoint.withDefaults(position: mousePosition);
      // If path doesnt exist or the point's invalid OR you're inside of a path trying to add a point
      // : Make a new path
      if (startPath == null) {
        // creating a new path, starting from first point
        startPath = DrawyPath(pathPoints: [], isActive: true);
        drawPaths.add(startPath);
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
      checkAndClosePath(startPath, goingInReverse);
      goingInReverse = false;
    }

    return drawPaths;
  }

  // close off shape if the point is to close to end of the shape
  void checkAndClosePath(DrawyPath? path, bool inReverse) {
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

  List<DrawyPath> selectMode(DrawyInteract interact, Vector2 mousePosition) {
    // START
    // Try to fetch the nearest point
    if (interact == DrawyInteract.start) {
      DrawyPath? startPath;
      DrawyPoint? nearPointWithCurves;
      for (var drawyPath in drawPaths) {
        // first check if near an active path
        bool isNearPoint = _pointNearPath(
          drawyPath.path,
          mousePosition,
          PEN_MINIMUM_DRAG_DISTANCE,
        );
        // then if we're near active curves
        nearPointWithCurves = _curvedPointNearPath(
          drawyPath,
          mousePosition,
          MIN_DISTANCE_TO_START_CURVE,
        );
        if (isNearPoint || nearPointWithCurves != null) {
          startPath = drawyPath;
          startPath.isActive = true;
        }
      }
      if (startPath == null) {
        print("No start path made");
        for (var element in drawPaths) {
          element.isActive = false;
        }
        selectPathsToManipulate.clear();
        return drawPaths;
      } else {
        print("start path found");

        // TODO: In future when we want mutlti part selection , clear this for loop
        for (var drawyPath in drawPaths) {
          if (drawyPath != startPath) {
            drawyPath.isActive = false;
          }
        }
      }
      // regular mode get nearest point
      if (activeBezier == DrawyBezierSelected.none) {
        var (nearIndex, distanceReturned) = _getClosestVectorIndexToVector(
          mousePosition,
          startPath.pathPoints,
        );
        if (nearIndex != -1) {
          startPath.setActivePoint(
            startPath.pathPoints[nearIndex],
            true,
            hideOthers: true,
          );
        }
      } else {
        //curve point we already know the point
        startPath.setActivePoint(nearPointWithCurves, true, hideOthers: true);
      }

      selectPathsToManipulate.add(startPath);
    }
    if (interact == DrawyInteract.move) {
      if (selectPathsToManipulate.isNotEmpty &&
          selectPathsToManipulate.length == 1) {
        DrawyPath movePath = selectPathsToManipulate[0];
        var activePoints = movePath.getActivePoints();
        DrawyPoint movePoint = activePoints[0];
        var position = movePoint.getPosition();
        var offsetPosition = (mousePosition - position);
        // going backwards, flip curves
        if (goingInReverse) {
          offsetPosition = -offsetPosition;
        }

        dragPoint(movePath, movePoint, mousePosition);
      }
    }

    // clone history at end of interation
    if (interact == DrawyInteract.end && selectPathsToManipulate.isNotEmpty) {
      goingInReverse = false;
      selectPathsToManipulate.clear();
      activeBezier = DrawyBezierSelected.none;
    }

    return drawPaths;
  }

  // TODO, Use compute metrics in select mode somehow so we can better select path
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

  DrawyPoint? _curvedPointNearPath(
    DrawyPath path,
    Vector2 point,
    double tolerance,
  ) {
    var activePoints = path.getActivePoints();
    for (DrawyPoint pt in activePoints) {
      var startCurve = pt.thisPointCubicPointEnd;
      var endCurve = pt.nextPointCubicPointStart;
      if (startCurve != null) {
        if (startCurve.distanceToSquared(point) <= tolerance) {
          activeBezier = DrawyBezierSelected.A;
          return pt;
        }
      }
      if (endCurve != null) {
        if (endCurve.distanceToSquared(point) <= tolerance) {
          activeBezier = DrawyBezierSelected.B;
          return pt;
        }
      }
    }
    activeBezier = DrawyBezierSelected.none;
    return null;
  }

  void update(Canvas ctx) {
    // DRAW
    // draw all paths
    var pathCount = drawPaths.length;
    for (int i = 0; i < pathCount; i++) {
      // print("  Path $i has ${drawPaths[i].pathPoints.length} points");
      var path = drawPaths[i];
      path.draw(ctx, PEN_DEFAULT_STROKE);

      // don't draw anything else if path isn't selected
      if (path.isActive == false) {
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

          drawGuidePoint(ctx, DrawyGuideType.fullSquare, pt.getPosition());

          for (final p in [cubicEnd, cubicStart]) {
            if (p != null &&
                pt.getPosition().distanceToSquared(p) >
                    MIN_DISTANCE_TO_START_CURVE) {
              drawGuidePoint(ctx, DrawyGuideType.circle, p);
            }
          }
        } else {
          drawGuidePoint(ctx, DrawyGuideType.square, pt.getPosition());
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
        textPainter.paint(ctx, Offset(pt.getPosition().x, pt.getPosition().y));
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

  void drawGuidePoint(
    Canvas ctx,
    DrawyGuideType typeToDraw,
    Vector2? position,
  ) {
    if (position == null) {
      return;
    }
    double size = 9;
    Offset pos = Offset(position.x, position.y);

    if (typeToDraw == DrawyGuideType.square) {
      ctx.drawRect(
        Rect.fromCenter(center: pos, width: size, height: size),
        guidePaintSemiFull,
      );

      ctx.drawRect(
        Rect.fromCenter(center: pos, width: size, height: size),
        guidePaintStroke,
      );
    } else if (typeToDraw == DrawyGuideType.fullSquare) {
      ctx.drawRect(
        Rect.fromCenter(center: pos, width: size, height: size),
        guidePaintFull,
      );
    } else if (typeToDraw == DrawyGuideType.circle) {
      ctx.drawCircle(pos, size / 2, guidePaintSemiFull);
      ctx.drawCircle(pos, size / 2, guidePaintStroke);
    } else if (typeToDraw == DrawyGuideType.testType) {
      ctx.drawCircle(pos, size / 2, redPaintFull);
      ctx.drawCircle(pos, size / 2, guidePaintStroke);
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
