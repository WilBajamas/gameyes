// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'critics_grid_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CriticsGridState {
  CriticsGridStatus get status;
  List<GameEntity> get criticsGames;
  GenrePreferencesEntity? get genrePreferencesEntity;
  String? get errorMessage;

  /// Create a copy of CriticsGridState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CriticsGridStateCopyWith<CriticsGridState> get copyWith =>
      _$CriticsGridStateCopyWithImpl<CriticsGridState>(
          this as CriticsGridState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CriticsGridState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other.criticsGames, criticsGames) &&
            (identical(other.genrePreferencesEntity, genrePreferencesEntity) ||
                other.genrePreferencesEntity == genrePreferencesEntity) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(criticsGames),
      genrePreferencesEntity,
      errorMessage);

  @override
  String toString() {
    return 'CriticsGridState(status: $status, criticsGames: $criticsGames, genrePreferencesEntity: $genrePreferencesEntity, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class $CriticsGridStateCopyWith<$Res> {
  factory $CriticsGridStateCopyWith(
          CriticsGridState value, $Res Function(CriticsGridState) _then) =
      _$CriticsGridStateCopyWithImpl;
  @useResult
  $Res call(
      {CriticsGridStatus status,
      List<GameEntity> criticsGames,
      GenrePreferencesEntity? genrePreferencesEntity,
      String? errorMessage});
}

/// @nodoc
class _$CriticsGridStateCopyWithImpl<$Res>
    implements $CriticsGridStateCopyWith<$Res> {
  _$CriticsGridStateCopyWithImpl(this._self, this._then);

  final CriticsGridState _self;
  final $Res Function(CriticsGridState) _then;

  /// Create a copy of CriticsGridState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? criticsGames = null,
    Object? genrePreferencesEntity = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as CriticsGridStatus,
      criticsGames: null == criticsGames
          ? _self.criticsGames
          : criticsGames // ignore: cast_nullable_to_non_nullable
              as List<GameEntity>,
      genrePreferencesEntity: freezed == genrePreferencesEntity
          ? _self.genrePreferencesEntity
          : genrePreferencesEntity // ignore: cast_nullable_to_non_nullable
              as GenrePreferencesEntity?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CriticsGridState].
extension CriticsGridStatePatterns on CriticsGridState {
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
    TResult Function(_CriticsGridState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CriticsGridState() when $default != null:
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
    TResult Function(_CriticsGridState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CriticsGridState():
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
    TResult? Function(_CriticsGridState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CriticsGridState() when $default != null:
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
            CriticsGridStatus status,
            List<GameEntity> criticsGames,
            GenrePreferencesEntity? genrePreferencesEntity,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CriticsGridState() when $default != null:
        return $default(_that.status, _that.criticsGames,
            _that.genrePreferencesEntity, _that.errorMessage);
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
            CriticsGridStatus status,
            List<GameEntity> criticsGames,
            GenrePreferencesEntity? genrePreferencesEntity,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CriticsGridState():
        return $default(_that.status, _that.criticsGames,
            _that.genrePreferencesEntity, _that.errorMessage);
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
            CriticsGridStatus status,
            List<GameEntity> criticsGames,
            GenrePreferencesEntity? genrePreferencesEntity,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CriticsGridState() when $default != null:
        return $default(_that.status, _that.criticsGames,
            _that.genrePreferencesEntity, _that.errorMessage);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CriticsGridState implements CriticsGridState {
  const _CriticsGridState(
      {this.status = CriticsGridStatus.initial,
      final List<GameEntity> criticsGames = const <GameEntity>[],
      this.genrePreferencesEntity,
      this.errorMessage})
      : _criticsGames = criticsGames;

  @override
  @JsonKey()
  final CriticsGridStatus status;
  final List<GameEntity> _criticsGames;
  @override
  @JsonKey()
  List<GameEntity> get criticsGames {
    if (_criticsGames is EqualUnmodifiableListView) return _criticsGames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_criticsGames);
  }

  @override
  final GenrePreferencesEntity? genrePreferencesEntity;
  @override
  final String? errorMessage;

  /// Create a copy of CriticsGridState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CriticsGridStateCopyWith<_CriticsGridState> get copyWith =>
      __$CriticsGridStateCopyWithImpl<_CriticsGridState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CriticsGridState &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._criticsGames, _criticsGames) &&
            (identical(other.genrePreferencesEntity, genrePreferencesEntity) ||
                other.genrePreferencesEntity == genrePreferencesEntity) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      const DeepCollectionEquality().hash(_criticsGames),
      genrePreferencesEntity,
      errorMessage);

  @override
  String toString() {
    return 'CriticsGridState(status: $status, criticsGames: $criticsGames, genrePreferencesEntity: $genrePreferencesEntity, errorMessage: $errorMessage)';
  }
}

/// @nodoc
abstract mixin class _$CriticsGridStateCopyWith<$Res>
    implements $CriticsGridStateCopyWith<$Res> {
  factory _$CriticsGridStateCopyWith(
          _CriticsGridState value, $Res Function(_CriticsGridState) _then) =
      __$CriticsGridStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {CriticsGridStatus status,
      List<GameEntity> criticsGames,
      GenrePreferencesEntity? genrePreferencesEntity,
      String? errorMessage});
}

/// @nodoc
class __$CriticsGridStateCopyWithImpl<$Res>
    implements _$CriticsGridStateCopyWith<$Res> {
  __$CriticsGridStateCopyWithImpl(this._self, this._then);

  final _CriticsGridState _self;
  final $Res Function(_CriticsGridState) _then;

  /// Create a copy of CriticsGridState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? criticsGames = null,
    Object? genrePreferencesEntity = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_CriticsGridState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as CriticsGridStatus,
      criticsGames: null == criticsGames
          ? _self._criticsGames
          : criticsGames // ignore: cast_nullable_to_non_nullable
              as List<GameEntity>,
      genrePreferencesEntity: freezed == genrePreferencesEntity
          ? _self.genrePreferencesEntity
          : genrePreferencesEntity // ignore: cast_nullable_to_non_nullable
              as GenrePreferencesEntity?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
