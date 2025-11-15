// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drawy_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DrawyPoint {

 Vector2 get position; set position(Vector2 value); bool get isClosed; set isClosed(bool value);// Indicates path is selected
 bool get active;// Indicates path is selected
 set active(bool value);// control points are for MATH for controls
// Default End Cubic , we use the current path
 Vector2? get thisPointCubicPointEnd;// control points are for MATH for controls
// Default End Cubic , we use the current path
 set thisPointCubicPointEnd(Vector2? value);// the default start Cublic , we use the last point's end cubic
 Vector2? get nextPointCubicPointStart;// the default start Cublic , we use the last point's end cubic
 set nextPointCubicPointStart(Vector2? value);
/// Create a copy of DrawyPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrawyPointCopyWith<DrawyPoint> get copyWith => _$DrawyPointCopyWithImpl<DrawyPoint>(this as DrawyPoint, _$identity);





@override
String toString() {
  return 'DrawyPoint(position: $position, isClosed: $isClosed, active: $active, thisPointCubicPointEnd: $thisPointCubicPointEnd, nextPointCubicPointStart: $nextPointCubicPointStart)';
}


}

/// @nodoc
abstract mixin class $DrawyPointCopyWith<$Res>  {
  factory $DrawyPointCopyWith(DrawyPoint value, $Res Function(DrawyPoint) _then) = _$DrawyPointCopyWithImpl;
@useResult
$Res call({
 Vector2 position, bool isClosed, bool active, Vector2? thisPointCubicPointEnd, Vector2? nextPointCubicPointStart
});




}
/// @nodoc
class _$DrawyPointCopyWithImpl<$Res>
    implements $DrawyPointCopyWith<$Res> {
  _$DrawyPointCopyWithImpl(this._self, this._then);

  final DrawyPoint _self;
  final $Res Function(DrawyPoint) _then;

/// Create a copy of DrawyPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? isClosed = null,Object? active = null,Object? thisPointCubicPointEnd = freezed,Object? nextPointCubicPointStart = freezed,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector2,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,thisPointCubicPointEnd: freezed == thisPointCubicPointEnd ? _self.thisPointCubicPointEnd : thisPointCubicPointEnd // ignore: cast_nullable_to_non_nullable
as Vector2?,nextPointCubicPointStart: freezed == nextPointCubicPointStart ? _self.nextPointCubicPointStart : nextPointCubicPointStart // ignore: cast_nullable_to_non_nullable
as Vector2?,
  ));
}

}


/// Adds pattern-matching-related methods to [DrawyPoint].
extension DrawyPointPatterns on DrawyPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrawyPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrawyPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrawyPoint value)  $default,){
final _that = this;
switch (_that) {
case _DrawyPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrawyPoint value)?  $default,){
final _that = this;
switch (_that) {
case _DrawyPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Vector2 position,  bool isClosed,  bool active,  Vector2? thisPointCubicPointEnd,  Vector2? nextPointCubicPointStart)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrawyPoint() when $default != null:
return $default(_that.position,_that.isClosed,_that.active,_that.thisPointCubicPointEnd,_that.nextPointCubicPointStart);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Vector2 position,  bool isClosed,  bool active,  Vector2? thisPointCubicPointEnd,  Vector2? nextPointCubicPointStart)  $default,) {final _that = this;
switch (_that) {
case _DrawyPoint():
return $default(_that.position,_that.isClosed,_that.active,_that.thisPointCubicPointEnd,_that.nextPointCubicPointStart);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Vector2 position,  bool isClosed,  bool active,  Vector2? thisPointCubicPointEnd,  Vector2? nextPointCubicPointStart)?  $default,) {final _that = this;
switch (_that) {
case _DrawyPoint() when $default != null:
return $default(_that.position,_that.isClosed,_that.active,_that.thisPointCubicPointEnd,_that.nextPointCubicPointStart);case _:
  return null;

}
}

}

/// @nodoc


class _DrawyPoint extends DrawyPoint {
   _DrawyPoint({required this.position, required this.isClosed, required this.active, this.thisPointCubicPointEnd, this.nextPointCubicPointStart}): super._();
  

@override  Vector2 position;
@override  bool isClosed;
// Indicates path is selected
@override  bool active;
// control points are for MATH for controls
// Default End Cubic , we use the current path
@override  Vector2? thisPointCubicPointEnd;
// the default start Cublic , we use the last point's end cubic
@override  Vector2? nextPointCubicPointStart;

/// Create a copy of DrawyPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrawyPointCopyWith<_DrawyPoint> get copyWith => __$DrawyPointCopyWithImpl<_DrawyPoint>(this, _$identity);





@override
String toString() {
  return 'DrawyPoint(position: $position, isClosed: $isClosed, active: $active, thisPointCubicPointEnd: $thisPointCubicPointEnd, nextPointCubicPointStart: $nextPointCubicPointStart)';
}


}

/// @nodoc
abstract mixin class _$DrawyPointCopyWith<$Res> implements $DrawyPointCopyWith<$Res> {
  factory _$DrawyPointCopyWith(_DrawyPoint value, $Res Function(_DrawyPoint) _then) = __$DrawyPointCopyWithImpl;
@override @useResult
$Res call({
 Vector2 position, bool isClosed, bool active, Vector2? thisPointCubicPointEnd, Vector2? nextPointCubicPointStart
});




}
/// @nodoc
class __$DrawyPointCopyWithImpl<$Res>
    implements _$DrawyPointCopyWith<$Res> {
  __$DrawyPointCopyWithImpl(this._self, this._then);

  final _DrawyPoint _self;
  final $Res Function(_DrawyPoint) _then;

/// Create a copy of DrawyPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? isClosed = null,Object? active = null,Object? thisPointCubicPointEnd = freezed,Object? nextPointCubicPointStart = freezed,}) {
  return _then(_DrawyPoint(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Vector2,isClosed: null == isClosed ? _self.isClosed : isClosed // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,thisPointCubicPointEnd: freezed == thisPointCubicPointEnd ? _self.thisPointCubicPointEnd : thisPointCubicPointEnd // ignore: cast_nullable_to_non_nullable
as Vector2?,nextPointCubicPointStart: freezed == nextPointCubicPointStart ? _self.nextPointCubicPointStart : nextPointCubicPointStart // ignore: cast_nullable_to_non_nullable
as Vector2?,
  ));
}


}

// dart format on
