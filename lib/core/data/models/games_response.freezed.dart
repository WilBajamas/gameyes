// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'games_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GamesResponse {
  int get count;
  int? get currentPage;
  String? get next;
  List<Game>? get results;

  /// Create a copy of GamesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GamesResponseCopyWith<GamesResponse> get copyWith =>
      _$GamesResponseCopyWithImpl<GamesResponse>(
          this as GamesResponse, _$identity);

  /// Serializes this GamesResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GamesResponse &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.next, next) || other.next == next) &&
            const DeepCollectionEquality().equals(other.results, results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count, currentPage, next,
      const DeepCollectionEquality().hash(results));

  @override
  String toString() {
    return 'GamesResponse(count: $count, currentPage: $currentPage, next: $next, results: $results)';
  }
}

/// @nodoc
abstract mixin class $GamesResponseCopyWith<$Res> {
  factory $GamesResponseCopyWith(
          GamesResponse value, $Res Function(GamesResponse) _then) =
      _$GamesResponseCopyWithImpl;
  @useResult
  $Res call({int count, int? currentPage, String? next, List<Game>? results});
}

/// @nodoc
class _$GamesResponseCopyWithImpl<$Res>
    implements $GamesResponseCopyWith<$Res> {
  _$GamesResponseCopyWithImpl(this._self, this._then);

  final GamesResponse _self;
  final $Res Function(GamesResponse) _then;

  /// Create a copy of GamesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? currentPage = freezed,
    Object? next = freezed,
    Object? results = freezed,
  }) {
    return _then(_self.copyWith(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: freezed == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      next: freezed == next
          ? _self.next
          : next // ignore: cast_nullable_to_non_nullable
              as String?,
      results: freezed == results
          ? _self.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Game>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [GamesResponse].
extension GamesResponsePatterns on GamesResponse {
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

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_GamesResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamesResponse() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_GamesResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesResponse():
        return $default(_that);
    }
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

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_GamesResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesResponse() when $default != null:
        return $default(_that);
      case _:
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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int count, int? currentPage, String? next, List<Game>? results)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GamesResponse() when $default != null:
        return $default(
            _that.count, _that.currentPage, _that.next, _that.results);
      case _:
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int count, int? currentPage, String? next, List<Game>? results)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesResponse():
        return $default(
            _that.count, _that.currentPage, _that.next, _that.results);
    }
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int count, int? currentPage, String? next, List<Game>? results)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GamesResponse() when $default != null:
        return $default(
            _that.count, _that.currentPage, _that.next, _that.results);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GamesResponse implements GamesResponse {
  const _GamesResponse(
      {required this.count,
      this.currentPage,
      this.next,
      final List<Game>? results})
      : _results = results;
  factory _GamesResponse.fromJson(Map<String, dynamic> json) =>
      _$GamesResponseFromJson(json);

  @override
  final int count;
  @override
  final int? currentPage;
  @override
  final String? next;
  final List<Game>? _results;
  @override
  List<Game>? get results {
    final value = _results;
    if (value == null) return null;
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of GamesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GamesResponseCopyWith<_GamesResponse> get copyWith =>
      __$GamesResponseCopyWithImpl<_GamesResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GamesResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GamesResponse &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.next, next) || other.next == next) &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count, currentPage, next,
      const DeepCollectionEquality().hash(_results));

  @override
  String toString() {
    return 'GamesResponse(count: $count, currentPage: $currentPage, next: $next, results: $results)';
  }
}

/// @nodoc
abstract mixin class _$GamesResponseCopyWith<$Res>
    implements $GamesResponseCopyWith<$Res> {
  factory _$GamesResponseCopyWith(
          _GamesResponse value, $Res Function(_GamesResponse) _then) =
      __$GamesResponseCopyWithImpl;
  @override
  @useResult
  $Res call({int count, int? currentPage, String? next, List<Game>? results});
}

/// @nodoc
class __$GamesResponseCopyWithImpl<$Res>
    implements _$GamesResponseCopyWith<$Res> {
  __$GamesResponseCopyWithImpl(this._self, this._then);

  final _GamesResponse _self;
  final $Res Function(_GamesResponse) _then;

  /// Create a copy of GamesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? count = null,
    Object? currentPage = freezed,
    Object? next = freezed,
    Object? results = freezed,
  }) {
    return _then(_GamesResponse(
      count: null == count
          ? _self.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: freezed == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int?,
      next: freezed == next
          ? _self.next
          : next // ignore: cast_nullable_to_non_nullable
              as String?,
      results: freezed == results
          ? _self._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<Game>?,
    ));
  }
}

// dart format on
