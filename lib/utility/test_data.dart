import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/utility/drawy/components/drawy_point.dart';
import 'package:shapey/utility/drawy/drawy_path.dart';
import 'package:vector_math/vector_math.dart';

Data TEST_DATA_RECTANGLE() {
  Data shape = Data(drawPaths: List.empty(growable: true));
  shape.drawPaths.add(
    DrawyPath(
      pathPoints: [
        DrawyPoint(
          position: Vector2(596.4705810546875, 407.38824462890625),
          isClosed: false,
          active: false,
          thisPointCubicPointEnd: Vector2(
            596.4705810546875,
            407.38824462890625,
          ),
          nextPointCubicPointStart: Vector2(
            596.4705810546875,
            407.38824462890625,
          ),
        ),
        DrawyPoint(
          position: Vector2(575.88232421875, 138.56471252441406),
          isClosed: false,
          active: false,
          thisPointCubicPointEnd: Vector2(575.88232421875, 138.56471252441406),
          nextPointCubicPointStart: Vector2(
            575.88232421875,
            138.56471252441406,
          ),
        ),
        DrawyPoint(
          position: Vector2(346.4705810546875, 123.27059173583984),
          isClosed: false,
          active: false,
          thisPointCubicPointEnd: Vector2(
            346.4705810546875,
            123.27059173583984,
          ),
          nextPointCubicPointStart: Vector2(
            346.4705810546875,
            123.27059173583984,
          ),
        ),
        DrawyPoint(
          position: Vector2(239.41175842285156, 358.564697265625),
          isClosed: false,
          active: true,
          thisPointCubicPointEnd: Vector2(239.41175842285156, 358.564697265625),
          nextPointCubicPointStart: Vector2(
            239.41175842285156,
            358.564697265625,
          ),
        ),
      ],
    ),
  );
  return shape;
}

Data TEST_DATA_CIRCLE() {
  Data shape = Data(drawPaths: List.empty(growable: true));
  shape.drawPaths.add(
    DrawyPath(
      pathPoints: [
        DrawyPoint(
          position: Vector2(407.6470642089844, 381.5058898925781),
          isClosed: false,
          active: false,
          thisPointCubicPointEnd: Vector2(407.6470642089844, 381.5058898925781),
          nextPointCubicPointStart: Vector2(
            407.6470642089844,
            381.5058898925781,
          ),
        ),
        DrawyPoint(
          position: Vector2(596.4705810546875, 245.03529357910156),
          isClosed: false,
          active: false,
          thisPointCubicPointEnd: Vector2(602.941162109375, 417.9764709472656),
          nextPointCubicPointStart: Vector2(590.0, 72.0941162109375),
        ),
        DrawyPoint(
          position: Vector2(422.3529357910156, 125.62352752685547),
          isClosed: false,
          active: false,
          thisPointCubicPointEnd: Vector2(
            493.5293884277344,
            121.50587463378906,
          ),
          nextPointCubicPointStart: Vector2(
            351.1764831542969,
            129.74118041992188,
          ),
        ),
        DrawyPoint(
          position: Vector2(281.76470947265625, 254.44705200195312),
          isClosed: false,
          active: false,
          thisPointCubicPointEnd: Vector2(
            281.1764831542969,
            129.15292358398438,
          ),
          nextPointCubicPointStart: Vector2(
            282.3529357910156,
            379.7411804199219,
          ),
        ),
        DrawyPoint(
          position: Vector2(407.6470642089844, 378.564697265625),
          isClosed: false,
          active: true,
          thisPointCubicPointEnd: Vector2(316.4706115722656, 385.0352783203125),
          nextPointCubicPointStart: Vector2(
            498.8235168457031,
            372.0941162109375,
          ),
        ),
      ],
    ),
  );
  return shape;
}
