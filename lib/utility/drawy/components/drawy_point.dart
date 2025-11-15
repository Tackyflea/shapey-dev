import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';
part 'drawy_point.freezed.dart';

// this lets me still use copyWith, but its a modifiable
// point
@unfreezed
abstract class DrawyPoint with _$DrawyPoint {
  factory DrawyPoint({
    required Vector2 position,
    required bool isClosed,
    // Indicates path is selected
    required bool active,
    // control points are for MATH for controls
    // Default End Cubic , we use the current path
    Vector2? thisPointCubicPointEnd,
    // the default start Cublic , we use the last point's end cubic
    Vector2? nextPointCubicPointStart,
  }) = _DrawyPoint;

  factory DrawyPoint.withDefaults({
    Vector2? position,
    bool? isClosed,
    bool? active,
  }) {
    return DrawyPoint(
      position: position ?? Vector2.zero(),
      isClosed: isClosed ?? false,
      active: active ?? false,
    );
  }

  const DrawyPoint._();

  void setActive(bool newActive) => active = newActive;
  bool isActive() => active;

  void updatePosition(Vector2 newPosition) => position = newPosition;
  Vector2 getPosition() => position;

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
    return copyWith(
      position: position.clone(),
      nextPointCubicPointStart: nextPointCubicPointStart?.clone(),
      thisPointCubicPointEnd: thisPointCubicPointEnd?.clone(),
    );
  }
}
