// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_stats_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryStatsState {
  LibraryStatsStatus get status;
  LibrarySnapshotEntity? get snapshot;
  String? get errorMessage;
  bool get isChecklistDismissed;
  bool get step1Completed;
  bool get step2Completed;
  bool get step3Completed;
  double get checklistProgress;

  /// Create a copy of LibraryStatsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryStatsStateCopyWith<LibraryStatsState> get copyWith =>
      _$LibraryStatsStateCopyWithImpl<LibraryStatsState>(
          this as LibraryStatsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryStatsState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isChecklistDismissed, isChecklistDismissed) ||
                other.isChecklistDismissed == isChecklistDismissed) &&
            (identical(other.step1Completed, step1Completed) ||
                other.step1Completed == step1Completed) &&
            (identical(other.step2Completed, step2Completed) ||
                other.step2Completed == step2Completed) &&
            (identical(other.step3Completed, step3Completed) ||
                other.step3Completed == step3Completed) &&
            (identical(other.checklistProgress, checklistProgress) ||
                other.checklistProgress == checklistProgress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      snapshot,
      errorMessage,
      isChecklistDismissed,
      step1Completed,
      step2Completed,
      step3Completed,
      checklistProgress);

  @override
  String toString() {
    return 'LibraryStatsState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage, isChecklistDismissed: $isChecklistDismissed, step1Completed: $step1Completed, step2Completed: $step2Completed, step3Completed: $step3Completed, checklistProgress: $checklistProgress)';
  }
}

/// @nodoc
abstract mixin class $LibraryStatsStateCopyWith<$Res> {
  factory $LibraryStatsStateCopyWith(
          LibraryStatsState value, $Res Function(LibraryStatsState) _then) =
      _$LibraryStatsStateCopyWithImpl;
  @useResult
  $Res call(
      {LibraryStatsStatus status,
      LibrarySnapshotEntity? snapshot,
      String? errorMessage,
      bool isChecklistDismissed,
      bool step1Completed,
      bool step2Completed,
      bool step3Completed,
      double checklistProgress});
}

/// @nodoc
class _$LibraryStatsStateCopyWithImpl<$Res>
    implements $LibraryStatsStateCopyWith<$Res> {
  _$LibraryStatsStateCopyWithImpl(this._self, this._then);

  final LibraryStatsState _self;
  final $Res Function(LibraryStatsState) _then;

  /// Create a copy of LibraryStatsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? snapshot = freezed,
    Object? errorMessage = freezed,
    Object? isChecklistDismissed = null,
    Object? step1Completed = null,
    Object? step2Completed = null,
    Object? step3Completed = null,
    Object? checklistProgress = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as LibraryStatsStatus,
      snapshot: freezed == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as LibrarySnapshotEntity?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isChecklistDismissed: null == isChecklistDismissed
          ? _self.isChecklistDismissed
          : isChecklistDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      step1Completed: null == step1Completed
          ? _self.step1Completed
          : step1Completed // ignore: cast_nullable_to_non_nullable
              as bool,
      step2Completed: null == step2Completed
          ? _self.step2Completed
          : step2Completed // ignore: cast_nullable_to_non_nullable
              as bool,
      step3Completed: null == step3Completed
          ? _self.step3Completed
          : step3Completed // ignore: cast_nullable_to_non_nullable
              as bool,
      checklistProgress: null == checklistProgress
          ? _self.checklistProgress
          : checklistProgress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [LibraryStatsState].
extension LibraryStatsStatePatterns on LibraryStatsState {
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
    TResult Function(_LibraryStatsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryStatsState() when $default != null:
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
    TResult Function(_LibraryStatsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryStatsState():
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
    TResult? Function(_LibraryStatsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryStatsState() when $default != null:
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
            LibraryStatsStatus status,
            LibrarySnapshotEntity? snapshot,
            String? errorMessage,
            bool isChecklistDismissed,
            bool step1Completed,
            bool step2Completed,
            bool step3Completed,
            double checklistProgress)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryStatsState() when $default != null:
        return $default(
            _that.status,
            _that.snapshot,
            _that.errorMessage,
            _that.isChecklistDismissed,
            _that.step1Completed,
            _that.step2Completed,
            _that.step3Completed,
            _that.checklistProgress);
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
            LibraryStatsStatus status,
            LibrarySnapshotEntity? snapshot,
            String? errorMessage,
            bool isChecklistDismissed,
            bool step1Completed,
            bool step2Completed,
            bool step3Completed,
            double checklistProgress)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryStatsState():
        return $default(
            _that.status,
            _that.snapshot,
            _that.errorMessage,
            _that.isChecklistDismissed,
            _that.step1Completed,
            _that.step2Completed,
            _that.step3Completed,
            _that.checklistProgress);
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
            LibraryStatsStatus status,
            LibrarySnapshotEntity? snapshot,
            String? errorMessage,
            bool isChecklistDismissed,
            bool step1Completed,
            bool step2Completed,
            bool step3Completed,
            double checklistProgress)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryStatsState() when $default != null:
        return $default(
            _that.status,
            _that.snapshot,
            _that.errorMessage,
            _that.isChecklistDismissed,
            _that.step1Completed,
            _that.step2Completed,
            _that.step3Completed,
            _that.checklistProgress);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _LibraryStatsState implements LibraryStatsState {
  const _LibraryStatsState(
      {this.status = LibraryStatsStatus.initial,
      this.snapshot,
      this.errorMessage,
      this.isChecklistDismissed = false,
      this.step1Completed = false,
      this.step2Completed = false,
      this.step3Completed = false,
      this.checklistProgress = 0.0});

  @override
  @JsonKey()
  final LibraryStatsStatus status;
  @override
  final LibrarySnapshotEntity? snapshot;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool isChecklistDismissed;
  @override
  @JsonKey()
  final bool step1Completed;
  @override
  @JsonKey()
  final bool step2Completed;
  @override
  @JsonKey()
  final bool step3Completed;
  @override
  @JsonKey()
  final double checklistProgress;

  /// Create a copy of LibraryStatsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LibraryStatsStateCopyWith<_LibraryStatsState> get copyWith =>
      __$LibraryStatsStateCopyWithImpl<_LibraryStatsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LibraryStatsState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.snapshot, snapshot) ||
                other.snapshot == snapshot) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isChecklistDismissed, isChecklistDismissed) ||
                other.isChecklistDismissed == isChecklistDismissed) &&
            (identical(other.step1Completed, step1Completed) ||
                other.step1Completed == step1Completed) &&
            (identical(other.step2Completed, step2Completed) ||
                other.step2Completed == step2Completed) &&
            (identical(other.step3Completed, step3Completed) ||
                other.step3Completed == step3Completed) &&
            (identical(other.checklistProgress, checklistProgress) ||
                other.checklistProgress == checklistProgress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      snapshot,
      errorMessage,
      isChecklistDismissed,
      step1Completed,
      step2Completed,
      step3Completed,
      checklistProgress);

  @override
  String toString() {
    return 'LibraryStatsState(status: $status, snapshot: $snapshot, errorMessage: $errorMessage, isChecklistDismissed: $isChecklistDismissed, step1Completed: $step1Completed, step2Completed: $step2Completed, step3Completed: $step3Completed, checklistProgress: $checklistProgress)';
  }
}

/// @nodoc
abstract mixin class _$LibraryStatsStateCopyWith<$Res>
    implements $LibraryStatsStateCopyWith<$Res> {
  factory _$LibraryStatsStateCopyWith(
          _LibraryStatsState value, $Res Function(_LibraryStatsState) _then) =
      __$LibraryStatsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {LibraryStatsStatus status,
      LibrarySnapshotEntity? snapshot,
      String? errorMessage,
      bool isChecklistDismissed,
      bool step1Completed,
      bool step2Completed,
      bool step3Completed,
      double checklistProgress});
}

/// @nodoc
class __$LibraryStatsStateCopyWithImpl<$Res>
    implements _$LibraryStatsStateCopyWith<$Res> {
  __$LibraryStatsStateCopyWithImpl(this._self, this._then);

  final _LibraryStatsState _self;
  final $Res Function(_LibraryStatsState) _then;

  /// Create a copy of LibraryStatsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? snapshot = freezed,
    Object? errorMessage = freezed,
    Object? isChecklistDismissed = null,
    Object? step1Completed = null,
    Object? step2Completed = null,
    Object? step3Completed = null,
    Object? checklistProgress = null,
  }) {
    return _then(_LibraryStatsState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as LibraryStatsStatus,
      snapshot: freezed == snapshot
          ? _self.snapshot
          : snapshot // ignore: cast_nullable_to_non_nullable
              as LibrarySnapshotEntity?,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isChecklistDismissed: null == isChecklistDismissed
          ? _self.isChecklistDismissed
          : isChecklistDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      step1Completed: null == step1Completed
          ? _self.step1Completed
          : step1Completed // ignore: cast_nullable_to_non_nullable
              as bool,
      step2Completed: null == step2Completed
          ? _self.step2Completed
          : step2Completed // ignore: cast_nullable_to_non_nullable
              as bool,
      step3Completed: null == step3Completed
          ? _self.step3Completed
          : step3Completed // ignore: cast_nullable_to_non_nullable
              as bool,
      checklistProgress: null == checklistProgress
          ? _self.checklistProgress
          : checklistProgress // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
