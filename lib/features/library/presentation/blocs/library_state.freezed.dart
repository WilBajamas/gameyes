// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryState {

 LibraryStatus? get activeStatus; LibrarySort get sort; LibraryViewMode get viewMode; String get searchTerm; List<LibraryEntryEntity> get entries; LibraryLoadStatus get status; LibraryNextPageStatus get nextPageStatus; bool get hasReachedEnd;// Null means the counts have not been read, which is not the same as a
// library where every status is genuinely zero.
 LibraryCountsEntity? get counts; int get matchedCount; ErrorType? get error; ErrorType? get nextPageError;
/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryStateCopyWith<LibraryState> get copyWith => _$LibraryStateCopyWithImpl<LibraryState>(this as LibraryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryState&&(identical(other.activeStatus, activeStatus) || other.activeStatus == activeStatus)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode)&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&const DeepCollectionEquality().equals(other.entries, entries)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextPageStatus, nextPageStatus) || other.nextPageStatus == nextPageStatus)&&(identical(other.hasReachedEnd, hasReachedEnd) || other.hasReachedEnd == hasReachedEnd)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.error, error) || other.error == error)&&(identical(other.nextPageError, nextPageError) || other.nextPageError == nextPageError));
}


@override
int get hashCode => Object.hash(runtimeType,activeStatus,sort,viewMode,searchTerm,const DeepCollectionEquality().hash(entries),status,nextPageStatus,hasReachedEnd,counts,matchedCount,error,nextPageError);

@override
String toString() {
  return 'LibraryState(activeStatus: $activeStatus, sort: $sort, viewMode: $viewMode, searchTerm: $searchTerm, entries: $entries, status: $status, nextPageStatus: $nextPageStatus, hasReachedEnd: $hasReachedEnd, counts: $counts, matchedCount: $matchedCount, error: $error, nextPageError: $nextPageError)';
}


}

/// @nodoc
abstract mixin class $LibraryStateCopyWith<$Res>  {
  factory $LibraryStateCopyWith(LibraryState value, $Res Function(LibraryState) _then) = _$LibraryStateCopyWithImpl;
@useResult
$Res call({
 LibraryStatus? activeStatus, LibrarySort sort, LibraryViewMode viewMode, String searchTerm, List<LibraryEntryEntity> entries, LibraryLoadStatus status, LibraryNextPageStatus nextPageStatus, bool hasReachedEnd, LibraryCountsEntity? counts, int matchedCount, ErrorType? error, ErrorType? nextPageError
});


$LibraryCountsEntityCopyWith<$Res>? get counts;$ErrorTypeCopyWith<$Res>? get error;$ErrorTypeCopyWith<$Res>? get nextPageError;

}
/// @nodoc
class _$LibraryStateCopyWithImpl<$Res>
    implements $LibraryStateCopyWith<$Res> {
  _$LibraryStateCopyWithImpl(this._self, this._then);

  final LibraryState _self;
  final $Res Function(LibraryState) _then;

/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeStatus = freezed,Object? sort = null,Object? viewMode = null,Object? searchTerm = null,Object? entries = null,Object? status = null,Object? nextPageStatus = null,Object? hasReachedEnd = null,Object? counts = freezed,Object? matchedCount = null,Object? error = freezed,Object? nextPageError = freezed,}) {
  return _then(_self.copyWith(
activeStatus: freezed == activeStatus ? _self.activeStatus : activeStatus // ignore: cast_nullable_to_non_nullable
as LibraryStatus?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as LibrarySort,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as LibraryViewMode,searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<LibraryEntryEntity>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LibraryLoadStatus,nextPageStatus: null == nextPageStatus ? _self.nextPageStatus : nextPageStatus // ignore: cast_nullable_to_non_nullable
as LibraryNextPageStatus,hasReachedEnd: null == hasReachedEnd ? _self.hasReachedEnd : hasReachedEnd // ignore: cast_nullable_to_non_nullable
as bool,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as LibraryCountsEntity?,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorType?,nextPageError: freezed == nextPageError ? _self.nextPageError : nextPageError // ignore: cast_nullable_to_non_nullable
as ErrorType?,
  ));
}
/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryCountsEntityCopyWith<$Res>? get counts {
    if (_self.counts == null) {
    return null;
  }

  return $LibraryCountsEntityCopyWith<$Res>(_self.counts!, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorTypeCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorTypeCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorTypeCopyWith<$Res>? get nextPageError {
    if (_self.nextPageError == null) {
    return null;
  }

  return $ErrorTypeCopyWith<$Res>(_self.nextPageError!, (value) {
    return _then(_self.copyWith(nextPageError: value));
  });
}
}


/// Adds pattern-matching-related methods to [LibraryState].
extension LibraryStatePatterns on LibraryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryState value)  $default,){
final _that = this;
switch (_that) {
case _LibraryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryState value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LibraryStatus? activeStatus,  LibrarySort sort,  LibraryViewMode viewMode,  String searchTerm,  List<LibraryEntryEntity> entries,  LibraryLoadStatus status,  LibraryNextPageStatus nextPageStatus,  bool hasReachedEnd,  LibraryCountsEntity? counts,  int matchedCount,  ErrorType? error,  ErrorType? nextPageError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
return $default(_that.activeStatus,_that.sort,_that.viewMode,_that.searchTerm,_that.entries,_that.status,_that.nextPageStatus,_that.hasReachedEnd,_that.counts,_that.matchedCount,_that.error,_that.nextPageError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LibraryStatus? activeStatus,  LibrarySort sort,  LibraryViewMode viewMode,  String searchTerm,  List<LibraryEntryEntity> entries,  LibraryLoadStatus status,  LibraryNextPageStatus nextPageStatus,  bool hasReachedEnd,  LibraryCountsEntity? counts,  int matchedCount,  ErrorType? error,  ErrorType? nextPageError)  $default,) {final _that = this;
switch (_that) {
case _LibraryState():
return $default(_that.activeStatus,_that.sort,_that.viewMode,_that.searchTerm,_that.entries,_that.status,_that.nextPageStatus,_that.hasReachedEnd,_that.counts,_that.matchedCount,_that.error,_that.nextPageError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LibraryStatus? activeStatus,  LibrarySort sort,  LibraryViewMode viewMode,  String searchTerm,  List<LibraryEntryEntity> entries,  LibraryLoadStatus status,  LibraryNextPageStatus nextPageStatus,  bool hasReachedEnd,  LibraryCountsEntity? counts,  int matchedCount,  ErrorType? error,  ErrorType? nextPageError)?  $default,) {final _that = this;
switch (_that) {
case _LibraryState() when $default != null:
return $default(_that.activeStatus,_that.sort,_that.viewMode,_that.searchTerm,_that.entries,_that.status,_that.nextPageStatus,_that.hasReachedEnd,_that.counts,_that.matchedCount,_that.error,_that.nextPageError);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryState implements LibraryState {
  const _LibraryState({this.activeStatus, this.sort = LibrarySort.recentlyAdded, this.viewMode = LibraryViewMode.grid, this.searchTerm = '', final  List<LibraryEntryEntity> entries = const <LibraryEntryEntity>[], this.status = LibraryLoadStatus.initial, this.nextPageStatus = LibraryNextPageStatus.initial, this.hasReachedEnd = false, this.counts, this.matchedCount = 0, this.error, this.nextPageError}): _entries = entries;
  

@override final  LibraryStatus? activeStatus;
@override@JsonKey() final  LibrarySort sort;
@override@JsonKey() final  LibraryViewMode viewMode;
@override@JsonKey() final  String searchTerm;
 final  List<LibraryEntryEntity> _entries;
@override@JsonKey() List<LibraryEntryEntity> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@override@JsonKey() final  LibraryLoadStatus status;
@override@JsonKey() final  LibraryNextPageStatus nextPageStatus;
@override@JsonKey() final  bool hasReachedEnd;
// Null means the counts have not been read, which is not the same as a
// library where every status is genuinely zero.
@override final  LibraryCountsEntity? counts;
@override@JsonKey() final  int matchedCount;
@override final  ErrorType? error;
@override final  ErrorType? nextPageError;

/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryStateCopyWith<_LibraryState> get copyWith => __$LibraryStateCopyWithImpl<_LibraryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryState&&(identical(other.activeStatus, activeStatus) || other.activeStatus == activeStatus)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.viewMode, viewMode) || other.viewMode == viewMode)&&(identical(other.searchTerm, searchTerm) || other.searchTerm == searchTerm)&&const DeepCollectionEquality().equals(other._entries, _entries)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextPageStatus, nextPageStatus) || other.nextPageStatus == nextPageStatus)&&(identical(other.hasReachedEnd, hasReachedEnd) || other.hasReachedEnd == hasReachedEnd)&&(identical(other.counts, counts) || other.counts == counts)&&(identical(other.matchedCount, matchedCount) || other.matchedCount == matchedCount)&&(identical(other.error, error) || other.error == error)&&(identical(other.nextPageError, nextPageError) || other.nextPageError == nextPageError));
}


@override
int get hashCode => Object.hash(runtimeType,activeStatus,sort,viewMode,searchTerm,const DeepCollectionEquality().hash(_entries),status,nextPageStatus,hasReachedEnd,counts,matchedCount,error,nextPageError);

@override
String toString() {
  return 'LibraryState(activeStatus: $activeStatus, sort: $sort, viewMode: $viewMode, searchTerm: $searchTerm, entries: $entries, status: $status, nextPageStatus: $nextPageStatus, hasReachedEnd: $hasReachedEnd, counts: $counts, matchedCount: $matchedCount, error: $error, nextPageError: $nextPageError)';
}


}

/// @nodoc
abstract mixin class _$LibraryStateCopyWith<$Res> implements $LibraryStateCopyWith<$Res> {
  factory _$LibraryStateCopyWith(_LibraryState value, $Res Function(_LibraryState) _then) = __$LibraryStateCopyWithImpl;
@override @useResult
$Res call({
 LibraryStatus? activeStatus, LibrarySort sort, LibraryViewMode viewMode, String searchTerm, List<LibraryEntryEntity> entries, LibraryLoadStatus status, LibraryNextPageStatus nextPageStatus, bool hasReachedEnd, LibraryCountsEntity? counts, int matchedCount, ErrorType? error, ErrorType? nextPageError
});


@override $LibraryCountsEntityCopyWith<$Res>? get counts;@override $ErrorTypeCopyWith<$Res>? get error;@override $ErrorTypeCopyWith<$Res>? get nextPageError;

}
/// @nodoc
class __$LibraryStateCopyWithImpl<$Res>
    implements _$LibraryStateCopyWith<$Res> {
  __$LibraryStateCopyWithImpl(this._self, this._then);

  final _LibraryState _self;
  final $Res Function(_LibraryState) _then;

/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeStatus = freezed,Object? sort = null,Object? viewMode = null,Object? searchTerm = null,Object? entries = null,Object? status = null,Object? nextPageStatus = null,Object? hasReachedEnd = null,Object? counts = freezed,Object? matchedCount = null,Object? error = freezed,Object? nextPageError = freezed,}) {
  return _then(_LibraryState(
activeStatus: freezed == activeStatus ? _self.activeStatus : activeStatus // ignore: cast_nullable_to_non_nullable
as LibraryStatus?,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as LibrarySort,viewMode: null == viewMode ? _self.viewMode : viewMode // ignore: cast_nullable_to_non_nullable
as LibraryViewMode,searchTerm: null == searchTerm ? _self.searchTerm : searchTerm // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LibraryEntryEntity>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LibraryLoadStatus,nextPageStatus: null == nextPageStatus ? _self.nextPageStatus : nextPageStatus // ignore: cast_nullable_to_non_nullable
as LibraryNextPageStatus,hasReachedEnd: null == hasReachedEnd ? _self.hasReachedEnd : hasReachedEnd // ignore: cast_nullable_to_non_nullable
as bool,counts: freezed == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as LibraryCountsEntity?,matchedCount: null == matchedCount ? _self.matchedCount : matchedCount // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorType?,nextPageError: freezed == nextPageError ? _self.nextPageError : nextPageError // ignore: cast_nullable_to_non_nullable
as ErrorType?,
  ));
}

/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryCountsEntityCopyWith<$Res>? get counts {
    if (_self.counts == null) {
    return null;
  }

  return $LibraryCountsEntityCopyWith<$Res>(_self.counts!, (value) {
    return _then(_self.copyWith(counts: value));
  });
}/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorTypeCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorTypeCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}/// Create a copy of LibraryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorTypeCopyWith<$Res>? get nextPageError {
    if (_self.nextPageError == null) {
    return null;
  }

  return $ErrorTypeCopyWith<$Res>(_self.nextPageError!, (value) {
    return _then(_self.copyWith(nextPageError: value));
  });
}
}

// dart format on
