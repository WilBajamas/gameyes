// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskState {

 TrackerTaskEntity? get task;
/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskStateCopyWith<TaskState> get copyWith => _$TaskStateCopyWithImpl<TaskState>(this as TaskState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskState&&(identical(other.task, task) || other.task == task));
}


@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskState(task: $task)';
}


}

/// @nodoc
abstract mixin class $TaskStateCopyWith<$Res>  {
  factory $TaskStateCopyWith(TaskState value, $Res Function(TaskState) _then) = _$TaskStateCopyWithImpl;
@useResult
$Res call({
 TrackerTaskEntity? task
});


$TrackerTaskEntityCopyWith<$Res>? get task;

}
/// @nodoc
class _$TaskStateCopyWithImpl<$Res>
    implements $TaskStateCopyWith<$Res> {
  _$TaskStateCopyWithImpl(this._self, this._then);

  final TaskState _self;
  final $Res Function(TaskState) _then;

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = freezed,}) {
  return _then(_self.copyWith(
task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TrackerTaskEntity?,
  ));
}
/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackerTaskEntityCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $TrackerTaskEntityCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskState].
extension TaskStatePatterns on TaskState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskState value)?  $default,{TResult Function( RemoveStepFailed value)?  removeStepFailed,TResult Function( RemoveStepSuccess value)?  removeStepSuccess,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskState() when $default != null:
return $default(_that);case RemoveStepFailed() when removeStepFailed != null:
return removeStepFailed(_that);case RemoveStepSuccess() when removeStepSuccess != null:
return removeStepSuccess(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskState value)  $default,{required TResult Function( RemoveStepFailed value)  removeStepFailed,required TResult Function( RemoveStepSuccess value)  removeStepSuccess,}){
final _that = this;
switch (_that) {
case _TaskState():
return $default(_that);case RemoveStepFailed():
return removeStepFailed(_that);case RemoveStepSuccess():
return removeStepSuccess(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskState value)?  $default,{TResult? Function( RemoveStepFailed value)?  removeStepFailed,TResult? Function( RemoveStepSuccess value)?  removeStepSuccess,}){
final _that = this;
switch (_that) {
case _TaskState() when $default != null:
return $default(_that);case RemoveStepFailed() when removeStepFailed != null:
return removeStepFailed(_that);case RemoveStepSuccess() when removeStepSuccess != null:
return removeStepSuccess(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrackerTaskEntity? task)?  $default,{TResult Function( TrackerTaskEntity? task)?  removeStepFailed,TResult Function( TrackerTaskEntity? task)?  removeStepSuccess,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskState() when $default != null:
return $default(_that.task);case RemoveStepFailed() when removeStepFailed != null:
return removeStepFailed(_that.task);case RemoveStepSuccess() when removeStepSuccess != null:
return removeStepSuccess(_that.task);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrackerTaskEntity? task)  $default,{required TResult Function( TrackerTaskEntity? task)  removeStepFailed,required TResult Function( TrackerTaskEntity? task)  removeStepSuccess,}) {final _that = this;
switch (_that) {
case _TaskState():
return $default(_that.task);case RemoveStepFailed():
return removeStepFailed(_that.task);case RemoveStepSuccess():
return removeStepSuccess(_that.task);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrackerTaskEntity? task)?  $default,{TResult? Function( TrackerTaskEntity? task)?  removeStepFailed,TResult? Function( TrackerTaskEntity? task)?  removeStepSuccess,}) {final _that = this;
switch (_that) {
case _TaskState() when $default != null:
return $default(_that.task);case RemoveStepFailed() when removeStepFailed != null:
return removeStepFailed(_that.task);case RemoveStepSuccess() when removeStepSuccess != null:
return removeStepSuccess(_that.task);case _:
  return null;

}
}

}

/// @nodoc


class _TaskState implements TaskState {
  const _TaskState({this.task});
  

@override final  TrackerTaskEntity? task;

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskStateCopyWith<_TaskState> get copyWith => __$TaskStateCopyWithImpl<_TaskState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskState&&(identical(other.task, task) || other.task == task));
}


@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskState(task: $task)';
}


}

/// @nodoc
abstract mixin class _$TaskStateCopyWith<$Res> implements $TaskStateCopyWith<$Res> {
  factory _$TaskStateCopyWith(_TaskState value, $Res Function(_TaskState) _then) = __$TaskStateCopyWithImpl;
@override @useResult
$Res call({
 TrackerTaskEntity? task
});


@override $TrackerTaskEntityCopyWith<$Res>? get task;

}
/// @nodoc
class __$TaskStateCopyWithImpl<$Res>
    implements _$TaskStateCopyWith<$Res> {
  __$TaskStateCopyWithImpl(this._self, this._then);

  final _TaskState _self;
  final $Res Function(_TaskState) _then;

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = freezed,}) {
  return _then(_TaskState(
task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TrackerTaskEntity?,
  ));
}

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackerTaskEntityCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $TrackerTaskEntityCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

/// @nodoc


class RemoveStepFailed implements TaskState {
  const RemoveStepFailed({this.task});
  

@override final  TrackerTaskEntity? task;

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveStepFailedCopyWith<RemoveStepFailed> get copyWith => _$RemoveStepFailedCopyWithImpl<RemoveStepFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveStepFailed&&(identical(other.task, task) || other.task == task));
}


@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskState.removeStepFailed(task: $task)';
}


}

/// @nodoc
abstract mixin class $RemoveStepFailedCopyWith<$Res> implements $TaskStateCopyWith<$Res> {
  factory $RemoveStepFailedCopyWith(RemoveStepFailed value, $Res Function(RemoveStepFailed) _then) = _$RemoveStepFailedCopyWithImpl;
@override @useResult
$Res call({
 TrackerTaskEntity? task
});


@override $TrackerTaskEntityCopyWith<$Res>? get task;

}
/// @nodoc
class _$RemoveStepFailedCopyWithImpl<$Res>
    implements $RemoveStepFailedCopyWith<$Res> {
  _$RemoveStepFailedCopyWithImpl(this._self, this._then);

  final RemoveStepFailed _self;
  final $Res Function(RemoveStepFailed) _then;

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = freezed,}) {
  return _then(RemoveStepFailed(
task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TrackerTaskEntity?,
  ));
}

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackerTaskEntityCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $TrackerTaskEntityCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

/// @nodoc


class RemoveStepSuccess implements TaskState {
  const RemoveStepSuccess({this.task});
  

@override final  TrackerTaskEntity? task;

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveStepSuccessCopyWith<RemoveStepSuccess> get copyWith => _$RemoveStepSuccessCopyWithImpl<RemoveStepSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveStepSuccess&&(identical(other.task, task) || other.task == task));
}


@override
int get hashCode => Object.hash(runtimeType,task);

@override
String toString() {
  return 'TaskState.removeStepSuccess(task: $task)';
}


}

/// @nodoc
abstract mixin class $RemoveStepSuccessCopyWith<$Res> implements $TaskStateCopyWith<$Res> {
  factory $RemoveStepSuccessCopyWith(RemoveStepSuccess value, $Res Function(RemoveStepSuccess) _then) = _$RemoveStepSuccessCopyWithImpl;
@override @useResult
$Res call({
 TrackerTaskEntity? task
});


@override $TrackerTaskEntityCopyWith<$Res>? get task;

}
/// @nodoc
class _$RemoveStepSuccessCopyWithImpl<$Res>
    implements $RemoveStepSuccessCopyWith<$Res> {
  _$RemoveStepSuccessCopyWithImpl(this._self, this._then);

  final RemoveStepSuccess _self;
  final $Res Function(RemoveStepSuccess) _then;

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = freezed,}) {
  return _then(RemoveStepSuccess(
task: freezed == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TrackerTaskEntity?,
  ));
}

/// Create a copy of TaskState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackerTaskEntityCopyWith<$Res>? get task {
    if (_self.task == null) {
    return null;
  }

  return $TrackerTaskEntityCopyWith<$Res>(_self.task!, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
