// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilterState {
  GameOrdering get ordering;
  Set<GamePlatform> get platforms;
  Set<GameGenre> get genres;
  DateTime? get dateFrom;
  DateTime? get dateTo;
  String? get searchTerm;
  bool get ascending;

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FilterStateCopyWith<FilterState> get copyWith =>
      _$FilterStateCopyWithImpl<FilterState>(this as FilterState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FilterState &&
            (identical(other.ordering, ordering) ||
                other.ordering == ordering) &&
            const DeepCollectionEquality().equals(other.platforms, platforms) &&
            const DeepCollectionEquality().equals(other.genres, genres) &&
            (identical(other.dateFrom, dateFrom) ||
                other.dateFrom == dateFrom) &&
            (identical(other.dateTo, dateTo) || other.dateTo == dateTo) &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      ordering,
      const DeepCollectionEquality().hash(platforms),
      const DeepCollectionEquality().hash(genres),
      dateFrom,
      dateTo,
      searchTerm,
      ascending);

  @override
  String toString() {
    return 'FilterState(ordering: $ordering, platforms: $platforms, genres: $genres, dateFrom: $dateFrom, dateTo: $dateTo, searchTerm: $searchTerm, ascending: $ascending)';
  }
}

/// @nodoc
abstract mixin class $FilterStateCopyWith<$Res> {
  factory $FilterStateCopyWith(
          FilterState value, $Res Function(FilterState) _then) =
      _$FilterStateCopyWithImpl;
  @useResult
  $Res call(
      {GameOrdering ordering,
      Set<GamePlatform> platforms,
      Set<GameGenre> genres,
      DateTime? dateFrom,
      DateTime? dateTo,
      String? searchTerm,
      bool ascending});
}

/// @nodoc
class _$FilterStateCopyWithImpl<$Res> implements $FilterStateCopyWith<$Res> {
  _$FilterStateCopyWithImpl(this._self, this._then);

  final FilterState _self;
  final $Res Function(FilterState) _then;

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ordering = null,
    Object? platforms = null,
    Object? genres = null,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? searchTerm = freezed,
    Object? ascending = null,
  }) {
    return _then(_self.copyWith(
      ordering: null == ordering
          ? _self.ordering
          : ordering // ignore: cast_nullable_to_non_nullable
              as GameOrdering,
      platforms: null == platforms
          ? _self.platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
      genres: null == genres
          ? _self.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as Set<GameGenre>,
      dateFrom: freezed == dateFrom
          ? _self.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _self.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchTerm: freezed == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String?,
      ascending: null == ascending
          ? _self.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [FilterState].
extension FilterStatePatterns on FilterState {
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
    TResult Function(_FilterState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FilterState() when $default != null:
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
    TResult Function(_FilterState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FilterState():
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
    TResult? Function(_FilterState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FilterState() when $default != null:
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
            GameOrdering ordering,
            Set<GamePlatform> platforms,
            Set<GameGenre> genres,
            DateTime? dateFrom,
            DateTime? dateTo,
            String? searchTerm,
            bool ascending)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FilterState() when $default != null:
        return $default(_that.ordering, _that.platforms, _that.genres,
            _that.dateFrom, _that.dateTo, _that.searchTerm, _that.ascending);
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
            GameOrdering ordering,
            Set<GamePlatform> platforms,
            Set<GameGenre> genres,
            DateTime? dateFrom,
            DateTime? dateTo,
            String? searchTerm,
            bool ascending)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FilterState():
        return $default(_that.ordering, _that.platforms, _that.genres,
            _that.dateFrom, _that.dateTo, _that.searchTerm, _that.ascending);
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
            GameOrdering ordering,
            Set<GamePlatform> platforms,
            Set<GameGenre> genres,
            DateTime? dateFrom,
            DateTime? dateTo,
            String? searchTerm,
            bool ascending)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FilterState() when $default != null:
        return $default(_that.ordering, _that.platforms, _that.genres,
            _that.dateFrom, _that.dateTo, _that.searchTerm, _that.ascending);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FilterState implements FilterState {
  const _FilterState(
      {this.ordering = GameOrdering.released,
      final Set<GamePlatform> platforms = const <GamePlatform>{},
      final Set<GameGenre> genres = const <GameGenre>{},
      this.dateFrom,
      this.dateTo,
      this.searchTerm,
      this.ascending = false})
      : _platforms = platforms,
        _genres = genres;

  @override
  @JsonKey()
  final GameOrdering ordering;
  final Set<GamePlatform> _platforms;
  @override
  @JsonKey()
  Set<GamePlatform> get platforms {
    if (_platforms is EqualUnmodifiableSetView) return _platforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_platforms);
  }

  final Set<GameGenre> _genres;
  @override
  @JsonKey()
  Set<GameGenre> get genres {
    if (_genres is EqualUnmodifiableSetView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_genres);
  }

  @override
  final DateTime? dateFrom;
  @override
  final DateTime? dateTo;
  @override
  final String? searchTerm;
  @override
  @JsonKey()
  final bool ascending;

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FilterStateCopyWith<_FilterState> get copyWith =>
      __$FilterStateCopyWithImpl<_FilterState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FilterState &&
            (identical(other.ordering, ordering) ||
                other.ordering == ordering) &&
            const DeepCollectionEquality()
                .equals(other._platforms, _platforms) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.dateFrom, dateFrom) ||
                other.dateFrom == dateFrom) &&
            (identical(other.dateTo, dateTo) || other.dateTo == dateTo) &&
            (identical(other.searchTerm, searchTerm) ||
                other.searchTerm == searchTerm) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      ordering,
      const DeepCollectionEquality().hash(_platforms),
      const DeepCollectionEquality().hash(_genres),
      dateFrom,
      dateTo,
      searchTerm,
      ascending);

  @override
  String toString() {
    return 'FilterState(ordering: $ordering, platforms: $platforms, genres: $genres, dateFrom: $dateFrom, dateTo: $dateTo, searchTerm: $searchTerm, ascending: $ascending)';
  }
}

/// @nodoc
abstract mixin class _$FilterStateCopyWith<$Res>
    implements $FilterStateCopyWith<$Res> {
  factory _$FilterStateCopyWith(
          _FilterState value, $Res Function(_FilterState) _then) =
      __$FilterStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {GameOrdering ordering,
      Set<GamePlatform> platforms,
      Set<GameGenre> genres,
      DateTime? dateFrom,
      DateTime? dateTo,
      String? searchTerm,
      bool ascending});
}

/// @nodoc
class __$FilterStateCopyWithImpl<$Res> implements _$FilterStateCopyWith<$Res> {
  __$FilterStateCopyWithImpl(this._self, this._then);

  final _FilterState _self;
  final $Res Function(_FilterState) _then;

  /// Create a copy of FilterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? ordering = null,
    Object? platforms = null,
    Object? genres = null,
    Object? dateFrom = freezed,
    Object? dateTo = freezed,
    Object? searchTerm = freezed,
    Object? ascending = null,
  }) {
    return _then(_FilterState(
      ordering: null == ordering
          ? _self.ordering
          : ordering // ignore: cast_nullable_to_non_nullable
              as GameOrdering,
      platforms: null == platforms
          ? _self._platforms
          : platforms // ignore: cast_nullable_to_non_nullable
              as Set<GamePlatform>,
      genres: null == genres
          ? _self._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as Set<GameGenre>,
      dateFrom: freezed == dateFrom
          ? _self.dateFrom
          : dateFrom // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateTo: freezed == dateTo
          ? _self.dateTo
          : dateTo // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchTerm: freezed == searchTerm
          ? _self.searchTerm
          : searchTerm // ignore: cast_nullable_to_non_nullable
              as String?,
      ascending: null == ascending
          ? _self.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
