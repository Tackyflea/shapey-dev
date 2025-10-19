import 'package:vector_math/vector_math.dart';

// Generic Point which can be expanded with more data than just position
class DrawyPoint {
  late Vector2 _position;
  // control points are for MATH for controls

  // Default End Cubic , we use the current path
  Vector2? thisPointCubicPointEnd;
  // the default start Cublic , we use the last point's end cubic
  Vector2? nextPointCubicPointStart;
  // Indicates path is selected
  bool active = false;

  DrawyPoint({required Vector2 position}) {
    updatePosition(position);
  }

  void setActive(bool newActive) {
    active = newActive;
  }

  bool isActive() => active;

  void updatePosition(Vector2 newPosition) {
    _position = newPosition;
  }

  Vector2 getPosition() => _position;
  // assigns curves to curve to for  beziers
  void updateCurves(
    Vector2? newCubicPointStart,
    Vector2? newPointCubicPointEnd,
  ) {
    nextPointCubicPointStart = newCubicPointStart;
    thisPointCubicPointEnd = newPointCubicPointEnd;
  }

  // cleans up if curves dont need to exist
  void cleanCurves() {
    var tVal1 = nextPointCubicPointStart, tVal2 = thisPointCubicPointEnd;
    if (tVal1 == null || tVal2 == null) {
      nextPointCubicPointStart = null;
      thisPointCubicPointEnd = null;
      return;
    }
    var dist = tVal1.distanceToSquared(tVal2);
    // distance to closed, you're now a non curved point
    if (dist < 20) {
      nextPointCubicPointStart = null;
      thisPointCubicPointEnd = null;
    }
  }

  DrawyPoint copy() {
    var clonePoint = DrawyPoint(position: Vector2.copy(_position));
    clonePoint.updateCurves(
      nextPointCubicPointStart?.clone(),
      thisPointCubicPointEnd?.clone(),
    );
    clonePoint.active = isActive();
    return clonePoint;
  }
}
