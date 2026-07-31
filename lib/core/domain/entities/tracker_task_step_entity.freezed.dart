// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker_task_step_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackerTaskStepEntity {

 String get id; int? get taskId; int? get number; String? get title; String? get description; String? get image;
/// Create a copy of TrackerTaskStepEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackerTaskStepEntityCopyWith<TrackerTaskStepEntity> get copyWith => _$TrackerTaskStepEntityCopyWithImpl<TrackerTaskStepEntity>(this as TrackerTaskStepEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackerTaskStepEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image));
}


@override
int get hashCode => Object.hash(runtimeType,id,taskId,number,title,description,image);

@override
String toString() {
  return 'TrackerTaskStepEntity(id: $id, taskId: $taskId, number: $number, title: $title, description: $description, image: $image)';
}


}

/// @nodoc
abstract mixin class $TrackerTaskStepEntityCopyWith<$Res>  {
  factory $TrackerTaskStepEntityCopyWith(TrackerTaskStepEntity value, $Res Function(TrackerTaskStepEntity) _then) = _$TrackerTaskStepEntityCopyWithImpl;
@useResult
$Res call({
 String id, int? taskId, int? number, String? title, String? description, String? image
});




}
/// @nodoc
class _$TrackerTaskStepEntityCopyWithImpl<$Res>
    implements $TrackerTaskStepEntityCopyWith<$Res> {
  _$TrackerTaskStepEntityCopyWithImpl(this._self, this._then);

  final TrackerTaskStepEntity _self;
  final $Res Function(TrackerTaskStepEntity) _then;

/// Create a copy of TrackerTaskStepEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = freezed,Object? number = freezed,Object? title = freezed,Object? description = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackerTaskStepEntity].
extension TrackerTaskStepEntityPatterns on TrackerTaskStepEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackerTaskStepEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackerTaskStepEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackerTaskStepEntity value)  $default,){
final _that = this;
switch (_that) {
case _TrackerTaskStepEntity():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackerTaskStepEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TrackerTaskStepEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int? taskId,  int? number,  String? title,  String? description,  String? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackerTaskStepEntity() when $default != null:
return $default(_that.id,_that.taskId,_that.number,_that.title,_that.description,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int? taskId,  int? number,  String? title,  String? description,  String? image)  $default,) {final _that = this;
switch (_that) {
case _TrackerTaskStepEntity():
return $default(_that.id,_that.taskId,_that.number,_that.title,_that.description,_that.image);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int? taskId,  int? number,  String? title,  String? description,  String? image)?  $default,) {final _that = this;
switch (_that) {
case _TrackerTaskStepEntity() when $default != null:
return $default(_that.id,_that.taskId,_that.number,_that.title,_that.description,_that.image);case _:
  return null;

}
}

}

/// @nodoc


class _TrackerTaskStepEntity implements TrackerTaskStepEntity {
  const _TrackerTaskStepEntity({required this.id, this.taskId, this.number, this.title, this.description, this.image});
  

@override final  String id;
@override final  int? taskId;
@override final  int? number;
@override final  String? title;
@override final  String? description;
@override final  String? image;

/// Create a copy of TrackerTaskStepEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackerTaskStepEntityCopyWith<_TrackerTaskStepEntity> get copyWith => __$TrackerTaskStepEntityCopyWithImpl<_TrackerTaskStepEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackerTaskStepEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.number, number) || other.number == number)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.image, image) || other.image == image));
}


@override
int get hashCode => Object.hash(runtimeType,id,taskId,number,title,description,image);

@override
String toString() {
  return 'TrackerTaskStepEntity(id: $id, taskId: $taskId, number: $number, title: $title, description: $description, image: $image)';
}


}

/// @nodoc
abstract mixin class _$TrackerTaskStepEntityCopyWith<$Res> implements $TrackerTaskStepEntityCopyWith<$Res> {
  factory _$TrackerTaskStepEntityCopyWith(_TrackerTaskStepEntity value, $Res Function(_TrackerTaskStepEntity) _then) = __$TrackerTaskStepEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, int? taskId, int? number, String? title, String? description, String? image
});




}
/// @nodoc
class __$TrackerTaskStepEntityCopyWithImpl<$Res>
    implements _$TrackerTaskStepEntityCopyWith<$Res> {
  __$TrackerTaskStepEntityCopyWithImpl(this._self, this._then);

  final _TrackerTaskStepEntity _self;
  final $Res Function(_TrackerTaskStepEntity) _then;

/// Create a copy of TrackerTaskStepEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = freezed,Object? number = freezed,Object? title = freezed,Object? description = freezed,Object? image = freezed,}) {
  return _then(_TrackerTaskStepEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as int?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
