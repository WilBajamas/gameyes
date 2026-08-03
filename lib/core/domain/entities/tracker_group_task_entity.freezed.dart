// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker_group_task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackerGroupTaskEntity {

 int get id; int? get gameId; String? get title; String? get description; List<TrackerTaskEntity> get tasks;
/// Create a copy of TrackerGroupTaskEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackerGroupTaskEntityCopyWith<TrackerGroupTaskEntity> get copyWith => _$TrackerGroupTaskEntityCopyWithImpl<TrackerGroupTaskEntity>(this as TrackerGroupTaskEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackerGroupTaskEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tasks, tasks));
}


@override
int get hashCode => Object.hash(runtimeType,id,gameId,title,description,const DeepCollectionEquality().hash(tasks));

@override
String toString() {
  return 'TrackerGroupTaskEntity(id: $id, gameId: $gameId, title: $title, description: $description, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class $TrackerGroupTaskEntityCopyWith<$Res>  {
  factory $TrackerGroupTaskEntityCopyWith(TrackerGroupTaskEntity value, $Res Function(TrackerGroupTaskEntity) _then) = _$TrackerGroupTaskEntityCopyWithImpl;
@useResult
$Res call({
 int id, int? gameId, String? title, String? description, List<TrackerTaskEntity> tasks
});




}
/// @nodoc
class _$TrackerGroupTaskEntityCopyWithImpl<$Res>
    implements $TrackerGroupTaskEntityCopyWith<$Res> {
  _$TrackerGroupTaskEntityCopyWithImpl(this._self, this._then);

  final TrackerGroupTaskEntity _self;
  final $Res Function(TrackerGroupTaskEntity) _then;

/// Create a copy of TrackerGroupTaskEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameId = freezed,Object? title = freezed,Object? description = freezed,Object? tasks = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gameId: freezed == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TrackerTaskEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackerGroupTaskEntity].
extension TrackerGroupTaskEntityPatterns on TrackerGroupTaskEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackerGroupTaskEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackerGroupTaskEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackerGroupTaskEntity value)  $default,){
final _that = this;
switch (_that) {
case _TrackerGroupTaskEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackerGroupTaskEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TrackerGroupTaskEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? gameId,  String? title,  String? description,  List<TrackerTaskEntity> tasks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackerGroupTaskEntity() when $default != null:
return $default(_that.id,_that.gameId,_that.title,_that.description,_that.tasks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? gameId,  String? title,  String? description,  List<TrackerTaskEntity> tasks)  $default,) {final _that = this;
switch (_that) {
case _TrackerGroupTaskEntity():
return $default(_that.id,_that.gameId,_that.title,_that.description,_that.tasks);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? gameId,  String? title,  String? description,  List<TrackerTaskEntity> tasks)?  $default,) {final _that = this;
switch (_that) {
case _TrackerGroupTaskEntity() when $default != null:
return $default(_that.id,_that.gameId,_that.title,_that.description,_that.tasks);case _:
  return null;

}
}

}

/// @nodoc


class _TrackerGroupTaskEntity implements TrackerGroupTaskEntity {
  const _TrackerGroupTaskEntity({required this.id, this.gameId, this.title, this.description, final  List<TrackerTaskEntity> tasks = const []}): _tasks = tasks;
  

@override final  int id;
@override final  int? gameId;
@override final  String? title;
@override final  String? description;
 final  List<TrackerTaskEntity> _tasks;
@override@JsonKey() List<TrackerTaskEntity> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}


/// Create a copy of TrackerGroupTaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackerGroupTaskEntityCopyWith<_TrackerGroupTaskEntity> get copyWith => __$TrackerGroupTaskEntityCopyWithImpl<_TrackerGroupTaskEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackerGroupTaskEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tasks, _tasks));
}


@override
int get hashCode => Object.hash(runtimeType,id,gameId,title,description,const DeepCollectionEquality().hash(_tasks));

@override
String toString() {
  return 'TrackerGroupTaskEntity(id: $id, gameId: $gameId, title: $title, description: $description, tasks: $tasks)';
}


}

/// @nodoc
abstract mixin class _$TrackerGroupTaskEntityCopyWith<$Res> implements $TrackerGroupTaskEntityCopyWith<$Res> {
  factory _$TrackerGroupTaskEntityCopyWith(_TrackerGroupTaskEntity value, $Res Function(_TrackerGroupTaskEntity) _then) = __$TrackerGroupTaskEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int? gameId, String? title, String? description, List<TrackerTaskEntity> tasks
});




}
/// @nodoc
class __$TrackerGroupTaskEntityCopyWithImpl<$Res>
    implements _$TrackerGroupTaskEntityCopyWith<$Res> {
  __$TrackerGroupTaskEntityCopyWithImpl(this._self, this._then);

  final _TrackerGroupTaskEntity _self;
  final $Res Function(_TrackerGroupTaskEntity) _then;

/// Create a copy of TrackerGroupTaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameId = freezed,Object? title = freezed,Object? description = freezed,Object? tasks = null,}) {
  return _then(_TrackerGroupTaskEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gameId: freezed == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<TrackerTaskEntity>,
  ));
}


}

// dart format on
