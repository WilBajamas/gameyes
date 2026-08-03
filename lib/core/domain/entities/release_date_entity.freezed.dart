// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'release_date_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReleaseDateEntity {

 DateTime get date; String get human;
/// Create a copy of ReleaseDateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReleaseDateEntityCopyWith<ReleaseDateEntity> get copyWith => _$ReleaseDateEntityCopyWithImpl<ReleaseDateEntity>(this as ReleaseDateEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReleaseDateEntity&&(identical(other.date, date) || other.date == date)&&(identical(other.human, human) || other.human == human));
}


@override
int get hashCode => Object.hash(runtimeType,date,human);

@override
String toString() {
  return 'ReleaseDateEntity(date: $date, human: $human)';
}


}

/// @nodoc
abstract mixin class $ReleaseDateEntityCopyWith<$Res>  {
  factory $ReleaseDateEntityCopyWith(ReleaseDateEntity value, $Res Function(ReleaseDateEntity) _then) = _$ReleaseDateEntityCopyWithImpl;
@useResult
$Res call({
 DateTime date, String human
});




}
/// @nodoc
class _$ReleaseDateEntityCopyWithImpl<$Res>
    implements $ReleaseDateEntityCopyWith<$Res> {
  _$ReleaseDateEntityCopyWithImpl(this._self, this._then);

  final ReleaseDateEntity _self;
  final $Res Function(ReleaseDateEntity) _then;

/// Create a copy of ReleaseDateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? human = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,human: null == human ? _self.human : human // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReleaseDateEntity].
extension ReleaseDateEntityPatterns on ReleaseDateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReleaseDateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReleaseDateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReleaseDateEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReleaseDateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReleaseDateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReleaseDateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  String human)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReleaseDateEntity() when $default != null:
return $default(_that.date,_that.human);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  String human)  $default,) {final _that = this;
switch (_that) {
case _ReleaseDateEntity():
return $default(_that.date,_that.human);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  String human)?  $default,) {final _that = this;
switch (_that) {
case _ReleaseDateEntity() when $default != null:
return $default(_that.date,_that.human);case _:
  return null;

}
}

}

/// @nodoc


class _ReleaseDateEntity implements ReleaseDateEntity {
  const _ReleaseDateEntity({required this.date, required this.human});
  

@override final  DateTime date;
@override final  String human;

/// Create a copy of ReleaseDateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReleaseDateEntityCopyWith<_ReleaseDateEntity> get copyWith => __$ReleaseDateEntityCopyWithImpl<_ReleaseDateEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReleaseDateEntity&&(identical(other.date, date) || other.date == date)&&(identical(other.human, human) || other.human == human));
}


@override
int get hashCode => Object.hash(runtimeType,date,human);

@override
String toString() {
  return 'ReleaseDateEntity(date: $date, human: $human)';
}


}

/// @nodoc
abstract mixin class _$ReleaseDateEntityCopyWith<$Res> implements $ReleaseDateEntityCopyWith<$Res> {
  factory _$ReleaseDateEntityCopyWith(_ReleaseDateEntity value, $Res Function(_ReleaseDateEntity) _then) = __$ReleaseDateEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, String human
});




}
/// @nodoc
class __$ReleaseDateEntityCopyWithImpl<$Res>
    implements _$ReleaseDateEntityCopyWith<$Res> {
  __$ReleaseDateEntityCopyWithImpl(this._self, this._then);

  final _ReleaseDateEntity _self;
  final $Res Function(_ReleaseDateEntity) _then;

/// Create a copy of ReleaseDateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? human = null,}) {
  return _then(_ReleaseDateEntity(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,human: null == human ? _self.human : human // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
