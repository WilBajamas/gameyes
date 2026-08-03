// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'platform_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlatformItem {

 Platform? get platform;
/// Create a copy of PlatformItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlatformItemCopyWith<PlatformItem> get copyWith => _$PlatformItemCopyWithImpl<PlatformItem>(this as PlatformItem, _$identity);

  /// Serializes this PlatformItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlatformItem&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform);

@override
String toString() {
  return 'PlatformItem(platform: $platform)';
}


}

/// @nodoc
abstract mixin class $PlatformItemCopyWith<$Res>  {
  factory $PlatformItemCopyWith(PlatformItem value, $Res Function(PlatformItem) _then) = _$PlatformItemCopyWithImpl;
@useResult
$Res call({
 Platform? platform
});


$PlatformCopyWith<$Res>? get platform;

}
/// @nodoc
class _$PlatformItemCopyWithImpl<$Res>
    implements $PlatformItemCopyWith<$Res> {
  _$PlatformItemCopyWithImpl(this._self, this._then);

  final PlatformItem _self;
  final $Res Function(PlatformItem) _then;

/// Create a copy of PlatformItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? platform = freezed,}) {
  return _then(_self.copyWith(
platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as Platform?,
  ));
}
/// Create a copy of PlatformItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlatformCopyWith<$Res>? get platform {
    if (_self.platform == null) {
    return null;
  }

  return $PlatformCopyWith<$Res>(_self.platform!, (value) {
    return _then(_self.copyWith(platform: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlatformItem].
extension PlatformItemPatterns on PlatformItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlatformItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlatformItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlatformItem value)  $default,){
final _that = this;
switch (_that) {
case _PlatformItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlatformItem value)?  $default,){
final _that = this;
switch (_that) {
case _PlatformItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Platform? platform)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlatformItem() when $default != null:
return $default(_that.platform);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Platform? platform)  $default,) {final _that = this;
switch (_that) {
case _PlatformItem():
return $default(_that.platform);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Platform? platform)?  $default,) {final _that = this;
switch (_that) {
case _PlatformItem() when $default != null:
return $default(_that.platform);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlatformItem implements PlatformItem {
  const _PlatformItem({this.platform});
  factory _PlatformItem.fromJson(Map<String, dynamic> json) => _$PlatformItemFromJson(json);

@override final  Platform? platform;

/// Create a copy of PlatformItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlatformItemCopyWith<_PlatformItem> get copyWith => __$PlatformItemCopyWithImpl<_PlatformItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlatformItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlatformItem&&(identical(other.platform, platform) || other.platform == platform));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform);

@override
String toString() {
  return 'PlatformItem(platform: $platform)';
}


}

/// @nodoc
abstract mixin class _$PlatformItemCopyWith<$Res> implements $PlatformItemCopyWith<$Res> {
  factory _$PlatformItemCopyWith(_PlatformItem value, $Res Function(_PlatformItem) _then) = __$PlatformItemCopyWithImpl;
@override @useResult
$Res call({
 Platform? platform
});


@override $PlatformCopyWith<$Res>? get platform;

}
/// @nodoc
class __$PlatformItemCopyWithImpl<$Res>
    implements _$PlatformItemCopyWith<$Res> {
  __$PlatformItemCopyWithImpl(this._self, this._then);

  final _PlatformItem _self;
  final $Res Function(_PlatformItem) _then;

/// Create a copy of PlatformItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? platform = freezed,}) {
  return _then(_PlatformItem(
platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as Platform?,
  ));
}

/// Create a copy of PlatformItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlatformCopyWith<$Res>? get platform {
    if (_self.platform == null) {
    return null;
  }

  return $PlatformCopyWith<$Res>(_self.platform!, (value) {
    return _then(_self.copyWith(platform: value));
  });
}
}

// dart format on
