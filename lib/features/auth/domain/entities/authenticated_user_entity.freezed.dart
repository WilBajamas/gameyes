// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authenticated_user_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticatedUserEntity {

 String get id; SignInProvider? get provider; String? get email; String? get displayName; String? get avatarUrl;
/// Create a copy of AuthenticatedUserEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedUserEntityCopyWith<AuthenticatedUserEntity> get copyWith => _$AuthenticatedUserEntityCopyWithImpl<AuthenticatedUserEntity>(this as AuthenticatedUserEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticatedUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,provider,email,displayName,avatarUrl);

@override
String toString() {
  return 'AuthenticatedUserEntity(id: $id, provider: $provider, email: $email, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedUserEntityCopyWith<$Res>  {
  factory $AuthenticatedUserEntityCopyWith(AuthenticatedUserEntity value, $Res Function(AuthenticatedUserEntity) _then) = _$AuthenticatedUserEntityCopyWithImpl;
@useResult
$Res call({
 String id, SignInProvider? provider, String? email, String? displayName, String? avatarUrl
});




}
/// @nodoc
class _$AuthenticatedUserEntityCopyWithImpl<$Res>
    implements $AuthenticatedUserEntityCopyWith<$Res> {
  _$AuthenticatedUserEntityCopyWithImpl(this._self, this._then);

  final AuthenticatedUserEntity _self;
  final $Res Function(AuthenticatedUserEntity) _then;

/// Create a copy of AuthenticatedUserEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provider = freezed,Object? email = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as SignInProvider?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthenticatedUserEntity].
extension AuthenticatedUserEntityPatterns on AuthenticatedUserEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthenticatedUserEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthenticatedUserEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthenticatedUserEntity value)  $default,){
final _that = this;
switch (_that) {
case _AuthenticatedUserEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthenticatedUserEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AuthenticatedUserEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  SignInProvider? provider,  String? email,  String? displayName,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthenticatedUserEntity() when $default != null:
return $default(_that.id,_that.provider,_that.email,_that.displayName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  SignInProvider? provider,  String? email,  String? displayName,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _AuthenticatedUserEntity():
return $default(_that.id,_that.provider,_that.email,_that.displayName,_that.avatarUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  SignInProvider? provider,  String? email,  String? displayName,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _AuthenticatedUserEntity() when $default != null:
return $default(_that.id,_that.provider,_that.email,_that.displayName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _AuthenticatedUserEntity implements AuthenticatedUserEntity {
  const _AuthenticatedUserEntity({required this.id, this.provider, this.email, this.displayName, this.avatarUrl});
  

@override final  String id;
@override final  SignInProvider? provider;
@override final  String? email;
@override final  String? displayName;
@override final  String? avatarUrl;

/// Create a copy of AuthenticatedUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedUserEntityCopyWith<_AuthenticatedUserEntity> get copyWith => __$AuthenticatedUserEntityCopyWithImpl<_AuthenticatedUserEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticatedUserEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,provider,email,displayName,avatarUrl);

@override
String toString() {
  return 'AuthenticatedUserEntity(id: $id, provider: $provider, email: $email, displayName: $displayName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedUserEntityCopyWith<$Res> implements $AuthenticatedUserEntityCopyWith<$Res> {
  factory _$AuthenticatedUserEntityCopyWith(_AuthenticatedUserEntity value, $Res Function(_AuthenticatedUserEntity) _then) = __$AuthenticatedUserEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, SignInProvider? provider, String? email, String? displayName, String? avatarUrl
});




}
/// @nodoc
class __$AuthenticatedUserEntityCopyWithImpl<$Res>
    implements _$AuthenticatedUserEntityCopyWith<$Res> {
  __$AuthenticatedUserEntityCopyWithImpl(this._self, this._then);

  final _AuthenticatedUserEntity _self;
  final $Res Function(_AuthenticatedUserEntity) _then;

/// Create a copy of AuthenticatedUserEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provider = freezed,Object? email = freezed,Object? displayName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_AuthenticatedUserEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as SignInProvider?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
