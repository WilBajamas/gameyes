// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_page_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryPageEntity {

 List<LibraryEntryEntity> get entries; int get matchedCount;
/// Create a copy of LibraryPageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryPageEntityCopyWith<LibraryPageEntity> get copyWith => _$LibraryPageEntityCopyWithImpl<LibraryPageEntity>(this as LibraryPageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryPageEntity&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entries),matchedCount);

@override
String toString() {
  return 'LibraryPageEntity(entries: $entries, matchedCount: $matchedCount)';
}


}

/// @nodoc
abstract mixin class $LibraryPageEntityCopyWith<$Res>  {
  factory $LibraryPageEntityCopyWith(LibraryPageEntity value, $Res Function(LibraryPageEntity) _then) = _$LibraryPageEntityCopyWithImpl;
@useResult
$Res call({
 List<LibraryEntryEntity> entries, int matchedCount
});




}
/// @nodoc
class _$LibraryPageEntityCopyWithImpl<$Res>
    implements $LibraryPageEntityCopyWith<$Res> {
  _$LibraryPageEntityCopyWithImpl(this._self, this._then);

  final LibraryPageEntity _self;
  final $Res Function(LibraryPageEntity) _then;

/// Create a copy of LibraryPageEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entries = null,Object? matchedCount = null,}) {
  return _then(_self.copyWith(
entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LibraryEntryEntity>,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryPageEntity].
extension LibraryPageEntityPatterns on LibraryPageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryPageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryPageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryPageEntity value)  $default,){
final _that = this;
switch (_that) {
case _LibraryPageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryPageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryPageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LibraryEntryEntity> entries,  int matchedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryPageEntity() when $default != null:
return $default(_that.entries,_that.matchedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LibraryEntryEntity> entries,  int matchedCount)  $default,) {final _that = this;
switch (_that) {
case _LibraryPageEntity():
return $default(_that.entries,_that.matchedCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LibraryEntryEntity> entries,  int matchedCount)?  $default,) {final _that = this;
switch (_that) {
case _LibraryPageEntity() when $default != null:
return $default(_that.entries,_that.matchedCount);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryPageEntity implements LibraryPageEntity {
  const _LibraryPageEntity({required final  List<LibraryEntryEntity> entries, required this.matchedCount}): _entries = entries;
  

 final  List<LibraryEntryEntity> _entries;
@override List<LibraryEntryEntity> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override final  int matchedCount;

/// Create a copy of LibraryPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryPageEntityCopyWith<_LibraryPageEntity> get copyWith => __$LibraryPageEntityCopyWithImpl<_LibraryPageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryPageEntity&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),matchedCount);

@override
String toString() {
  return 'LibraryPageEntity(entries: $entries, matchedCount: $matchedCount)';
}


}

/// @nodoc
abstract mixin class _$LibraryPageEntityCopyWith<$Res> implements $LibraryPageEntityCopyWith<$Res> {
  factory _$LibraryPageEntityCopyWith(_LibraryPageEntity value, $Res Function(_LibraryPageEntity) _then) = __$LibraryPageEntityCopyWithImpl;
@override @useResult
$Res call({
 List<LibraryEntryEntity> entries, int matchedCount
});




}
/// @nodoc
class __$LibraryPageEntityCopyWithImpl<$Res>
    implements _$LibraryPageEntityCopyWith<$Res> {
  __$LibraryPageEntityCopyWithImpl(this._self, this._then);

  final _LibraryPageEntity _self;
  final $Res Function(_LibraryPageEntity) _then;

/// Create a copy of LibraryPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? matchedCount = null,}) {
  return _then(_LibraryPageEntity(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LibraryEntryEntity>,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
