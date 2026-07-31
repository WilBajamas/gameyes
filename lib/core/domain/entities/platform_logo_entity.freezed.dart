// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_logo_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlatformLogoEntity {

 String? get url;
/// Create a copy of PlatformLogoEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformLogoEntityCopyWith<PlatformLogoEntity> get copyWith => _$PlatformLogoEntityCopyWithImpl<PlatformLogoEntity>(this as PlatformLogoEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformLogoEntity&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'PlatformLogoEntity(url: $url)';
}


}

/// @nodoc
abstract mixin class $PlatformLogoEntityCopyWith<$Res>  {
  factory $PlatformLogoEntityCopyWith(PlatformLogoEntity value, $Res Function(PlatformLogoEntity) _then) = _$PlatformLogoEntityCopyWithImpl;
@useResult
$Res call({
 String? url
});




}
/// @nodoc
class _$PlatformLogoEntityCopyWithImpl<$Res>
    implements $PlatformLogoEntityCopyWith<$Res> {
  _$PlatformLogoEntityCopyWithImpl(this._self, this._then);

  final PlatformLogoEntity _self;
  final $Res Function(PlatformLogoEntity) _then;

/// Create a copy of PlatformLogoEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlatformLogoEntity].
extension PlatformLogoEntityPatterns on PlatformLogoEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformLogoEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformLogoEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformLogoEntity value)  $default,){
final _that = this;
switch (_that) {
case _PlatformLogoEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformLogoEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformLogoEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformLogoEntity() when $default != null:
return $default(_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? url)  $default,) {final _that = this;
switch (_that) {
case _PlatformLogoEntity():
return $default(_that.url);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? url)?  $default,) {final _that = this;
switch (_that) {
case _PlatformLogoEntity() when $default != null:
return $default(_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _PlatformLogoEntity implements PlatformLogoEntity {
  const _PlatformLogoEntity({this.url});
  

@override final  String? url;

/// Create a copy of PlatformLogoEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformLogoEntityCopyWith<_PlatformLogoEntity> get copyWith => __$PlatformLogoEntityCopyWithImpl<_PlatformLogoEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformLogoEntity&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'PlatformLogoEntity(url: $url)';
}


}

/// @nodoc
abstract mixin class _$PlatformLogoEntityCopyWith<$Res> implements $PlatformLogoEntityCopyWith<$Res> {
  factory _$PlatformLogoEntityCopyWith(_PlatformLogoEntity value, $Res Function(_PlatformLogoEntity) _then) = __$PlatformLogoEntityCopyWithImpl;
@override @useResult
$Res call({
 String? url
});




}
/// @nodoc
class __$PlatformLogoEntityCopyWithImpl<$Res>
    implements _$PlatformLogoEntityCopyWith<$Res> {
  __$PlatformLogoEntityCopyWithImpl(this._self, this._then);

  final _PlatformLogoEntity _self;
  final $Res Function(_PlatformLogoEntity) _then;

/// Create a copy of PlatformLogoEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,}) {
  return _then(_PlatformLogoEntity(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
