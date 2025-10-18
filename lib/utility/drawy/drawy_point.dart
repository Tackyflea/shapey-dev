import 'package:vector_math/vector_math.dart';

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
