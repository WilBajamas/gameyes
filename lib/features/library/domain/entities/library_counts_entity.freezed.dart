// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_counts_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryCountsEntity {

 Map<LibraryStatus, int> get byStatus; int get total;
/// Create a copy of LibraryCountsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryCountsEntityCopyWith<LibraryCountsEntity> get copyWith => _$LibraryCountsEntityCopyWithImpl<LibraryCountsEntity>(this as LibraryCountsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryCountsEntity&&const DeepCollectionEquality().equals(other.byStatus, byStatus)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(byStatus),total);

@override
String toString() {
  return 'LibraryCountsEntity(byStatus: $byStatus, total: $total)';
}


}

/// @nodoc
abstract mixin class $LibraryCountsEntityCopyWith<$Res>  {
  factory $LibraryCountsEntityCopyWith(LibraryCountsEntity value, $Res Function(LibraryCountsEntity) _then) = _$LibraryCountsEntityCopyWithImpl;
@useResult
$Res call({
 Map<LibraryStatus, int> byStatus, int total
});




}
/// @nodoc
class _$LibraryCountsEntityCopyWithImpl<$Res>
    implements $LibraryCountsEntityCopyWith<$Res> {
  _$LibraryCountsEntityCopyWithImpl(this._self, this._then);

  final LibraryCountsEntity _self;
  final $Res Function(LibraryCountsEntity) _then;

/// Create a copy of LibraryCountsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? byStatus = null,Object? total = null,}) {
  return _then(_self.copyWith(
byStatus: null == byStatus ? _self.byStatus : byStatus // ignore: cast_nullable_to_non_nullable
as Map<LibraryStatus, int>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryCountsEntity].
extension LibraryCountsEntityPatterns on LibraryCountsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryCountsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryCountsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryCountsEntity value)  $default,){
final _that = this;
switch (_that) {
case _LibraryCountsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryCountsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryCountsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<LibraryStatus, int> byStatus,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryCountsEntity() when $default != null:
return $default(_that.byStatus,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<LibraryStatus, int> byStatus,  int total)  $default,) {final _that = this;
switch (_that) {
case _LibraryCountsEntity():
return $default(_that.byStatus,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<LibraryStatus, int> byStatus,  int total)?  $default,) {final _that = this;
switch (_that) {
case _LibraryCountsEntity() when $default != null:
return $default(_that.byStatus,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryCountsEntity implements LibraryCountsEntity {
  const _LibraryCountsEntity({required final  Map<LibraryStatus, int> byStatus, required this.total}): _byStatus = byStatus;
  

 final  Map<LibraryStatus, int> _byStatus;
@override Map<LibraryStatus, int> get byStatus {
  if (_byStatus is EqualUnmodifiableMapView) return _byStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byStatus);
}

@override final  int total;

/// Create a copy of LibraryCountsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryCountsEntityCopyWith<_LibraryCountsEntity> get copyWith => __$LibraryCountsEntityCopyWithImpl<_LibraryCountsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryCountsEntity&&const DeepCollectionEquality().equals(other._byStatus, _byStatus)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_byStatus),total);

@override
String toString() {
  return 'LibraryCountsEntity(byStatus: $byStatus, total: $total)';
}


}

/// @nodoc
abstract mixin class _$LibraryCountsEntityCopyWith<$Res> implements $LibraryCountsEntityCopyWith<$Res> {
  factory _$LibraryCountsEntityCopyWith(_LibraryCountsEntity value, $Res Function(_LibraryCountsEntity) _then) = __$LibraryCountsEntityCopyWithImpl;
@override @useResult
$Res call({
 Map<LibraryStatus, int> byStatus, int total
});




}
/// @nodoc
class __$LibraryCountsEntityCopyWithImpl<$Res>
    implements _$LibraryCountsEntityCopyWith<$Res> {
  __$LibraryCountsEntityCopyWithImpl(this._self, this._then);

  final _LibraryCountsEntity _self;
  final $Res Function(_LibraryCountsEntity) _then;

/// Create a copy of LibraryCountsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? byStatus = null,Object? total = null,}) {
  return _then(_LibraryCountsEntity(
byStatus: null == byStatus ? _self._byStatus : byStatus // ignore: cast_nullable_to_non_nullable
as Map<LibraryStatus, int>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
