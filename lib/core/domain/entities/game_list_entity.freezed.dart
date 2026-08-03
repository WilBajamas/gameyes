// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_list_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GameListEntity {

 int get totalCount; List<GameEntity> get items; int? get currentPage; String? get nextUrl;
/// Create a copy of GameListEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameListEntityCopyWith<GameListEntity> get copyWith => _$GameListEntityCopyWithImpl<GameListEntity>(this as GameListEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameListEntity&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl));
}


@override
int get hashCode => Object.hash(runtimeType,totalCount,const DeepCollectionEquality().hash(items),currentPage,nextUrl);

@override
String toString() {
  return 'GameListEntity(totalCount: $totalCount, items: $items, currentPage: $currentPage, nextUrl: $nextUrl)';
}


}

/// @nodoc
abstract mixin class $GameListEntityCopyWith<$Res>  {
  factory $GameListEntityCopyWith(GameListEntity value, $Res Function(GameListEntity) _then) = _$GameListEntityCopyWithImpl;
@useResult
$Res call({
 int totalCount, List<GameEntity> items, int? currentPage, String? nextUrl
});




}
/// @nodoc
class _$GameListEntityCopyWithImpl<$Res>
    implements $GameListEntityCopyWith<$Res> {
  _$GameListEntityCopyWithImpl(this._self, this._then);

  final GameListEntity _self;
  final $Res Function(GameListEntity) _then;

/// Create a copy of GameListEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? items = null,Object? currentPage = freezed,Object? nextUrl = freezed,}) {
  return _then(_self.copyWith(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<GameEntity>,currentPage: freezed == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int?,nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameListEntity].
extension GameListEntityPatterns on GameListEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameListEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameListEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameListEntity value)  $default,){
final _that = this;
switch (_that) {
case _GameListEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameListEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GameListEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCount,  List<GameEntity> items,  int? currentPage,  String? nextUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameListEntity() when $default != null:
return $default(_that.totalCount,_that.items,_that.currentPage,_that.nextUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCount,  List<GameEntity> items,  int? currentPage,  String? nextUrl)  $default,) {final _that = this;
switch (_that) {
case _GameListEntity():
return $default(_that.totalCount,_that.items,_that.currentPage,_that.nextUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCount,  List<GameEntity> items,  int? currentPage,  String? nextUrl)?  $default,) {final _that = this;
switch (_that) {
case _GameListEntity() when $default != null:
return $default(_that.totalCount,_that.items,_that.currentPage,_that.nextUrl);case _:
  return null;

}
}

}

/// @nodoc


class _GameListEntity implements GameListEntity {
  const _GameListEntity({required this.totalCount, required final  List<GameEntity> items, this.currentPage, this.nextUrl}): _items = items;
  

@override final  int totalCount;
 final  List<GameEntity> _items;
@override List<GameEntity> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int? currentPage;
@override final  String? nextUrl;

/// Create a copy of GameListEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameListEntityCopyWith<_GameListEntity> get copyWith => __$GameListEntityCopyWithImpl<_GameListEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameListEntity&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl));
}


@override
int get hashCode => Object.hash(runtimeType,totalCount,const DeepCollectionEquality().hash(_items),currentPage,nextUrl);

@override
String toString() {
  return 'GameListEntity(totalCount: $totalCount, items: $items, currentPage: $currentPage, nextUrl: $nextUrl)';
}


}

/// @nodoc
abstract mixin class _$GameListEntityCopyWith<$Res> implements $GameListEntityCopyWith<$Res> {
  factory _$GameListEntityCopyWith(_GameListEntity value, $Res Function(_GameListEntity) _then) = __$GameListEntityCopyWithImpl;
@override @useResult
$Res call({
 int totalCount, List<GameEntity> items, int? currentPage, String? nextUrl
});




}
/// @nodoc
class __$GameListEntityCopyWithImpl<$Res>
    implements _$GameListEntityCopyWith<$Res> {
  __$GameListEntityCopyWithImpl(this._self, this._then);

  final _GameListEntity _self;
  final $Res Function(_GameListEntity) _then;

/// Create a copy of GameListEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? items = null,Object? currentPage = freezed,Object? nextUrl = freezed,}) {
  return _then(_GameListEntity(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<GameEntity>,currentPage: freezed == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int?,nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
