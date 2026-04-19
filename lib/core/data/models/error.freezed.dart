// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ErrorType {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ErrorType);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ErrorType()';
  }
}

/// @nodoc
class $ErrorTypeCopyWith<$Res> {
  $ErrorTypeCopyWith(ErrorType _, $Res Function(ErrorType) __);
}

/// Adds pattern-matching-related methods to [ErrorType].
extension ErrorTypePatterns on ErrorType {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResponseError value)? responseError,
    TResult Function(ConnectionTimeout value)? connectionTimeout,
    TResult Function(ReceiveTimeout value)? receiveTimeout,
    TResult Function(SendTimeout value)? sendTimeout,
    TResult Function(UnknownError value)? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ResponseError() when responseError != null:
        return responseError(_that);
      case ConnectionTimeout() when connectionTimeout != null:
        return connectionTimeout(_that);
      case ReceiveTimeout() when receiveTimeout != null:
        return receiveTimeout(_that);
      case SendTimeout() when sendTimeout != null:
        return sendTimeout(_that);
      case UnknownError() when unknown != null:
        return unknown(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(ResponseError value) responseError,
    required TResult Function(ConnectionTimeout value) connectionTimeout,
    required TResult Function(ReceiveTimeout value) receiveTimeout,
    required TResult Function(SendTimeout value) sendTimeout,
    required TResult Function(UnknownError value) unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ResponseError():
        return responseError(_that);
      case ConnectionTimeout():
        return connectionTimeout(_that);
      case ReceiveTimeout():
        return receiveTimeout(_that);
      case SendTimeout():
        return sendTimeout(_that);
      case UnknownError():
        return unknown(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ResponseError value)? responseError,
    TResult? Function(ConnectionTimeout value)? connectionTimeout,
    TResult? Function(ReceiveTimeout value)? receiveTimeout,
    TResult? Function(SendTimeout value)? sendTimeout,
    TResult? Function(UnknownError value)? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ResponseError() when responseError != null:
        return responseError(_that);
      case ConnectionTimeout() when connectionTimeout != null:
        return connectionTimeout(_that);
      case ReceiveTimeout() when receiveTimeout != null:
        return receiveTimeout(_that);
      case SendTimeout() when sendTimeout != null:
        return sendTimeout(_that);
      case UnknownError() when unknown != null:
        return unknown(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String? message, String? error, int? statusCode)?
        responseError,
    TResult Function()? connectionTimeout,
    TResult Function()? receiveTimeout,
    TResult Function()? sendTimeout,
    TResult Function()? unknown,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case ResponseError() when responseError != null:
        return responseError(_that.message, _that.error, _that.statusCode);
      case ConnectionTimeout() when connectionTimeout != null:
        return connectionTimeout();
      case ReceiveTimeout() when receiveTimeout != null:
        return receiveTimeout();
      case SendTimeout() when sendTimeout != null:
        return sendTimeout();
      case UnknownError() when unknown != null:
        return unknown();
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
  TResult when<TResult extends Object?>({
    required TResult Function(String? message, String? error, int? statusCode)
        responseError,
    required TResult Function() connectionTimeout,
    required TResult Function() receiveTimeout,
    required TResult Function() sendTimeout,
    required TResult Function() unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ResponseError():
        return responseError(_that.message, _that.error, _that.statusCode);
      case ConnectionTimeout():
        return connectionTimeout();
      case ReceiveTimeout():
        return receiveTimeout();
      case SendTimeout():
        return sendTimeout();
      case UnknownError():
        return unknown();
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String? message, String? error, int? statusCode)?
        responseError,
    TResult? Function()? connectionTimeout,
    TResult? Function()? receiveTimeout,
    TResult? Function()? sendTimeout,
    TResult? Function()? unknown,
  }) {
    final _that = this;
    switch (_that) {
      case ResponseError() when responseError != null:
        return responseError(_that.message, _that.error, _that.statusCode);
      case ConnectionTimeout() when connectionTimeout != null:
        return connectionTimeout();
      case ReceiveTimeout() when receiveTimeout != null:
        return receiveTimeout();
      case SendTimeout() when sendTimeout != null:
        return sendTimeout();
      case UnknownError() when unknown != null:
        return unknown();
      case _:
        return null;
    }
  }
}

/// @nodoc

class ResponseError extends ErrorType {
  const ResponseError({this.message, this.error, this.statusCode}) : super._();

  final String? message;
  final String? error;
  final int? statusCode;

  /// Create a copy of ErrorType
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ResponseErrorCopyWith<ResponseError> get copyWith =>
      _$ResponseErrorCopyWithImpl<ResponseError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ResponseError &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, error, statusCode);

  @override
  String toString() {
    return 'ErrorType.responseError(message: $message, error: $error, statusCode: $statusCode)';
  }
}

/// @nodoc
abstract mixin class $ResponseErrorCopyWith<$Res>
    implements $ErrorTypeCopyWith<$Res> {
  factory $ResponseErrorCopyWith(
          ResponseError value, $Res Function(ResponseError) _then) =
      _$ResponseErrorCopyWithImpl;
  @useResult
  $Res call({String? message, String? error, int? statusCode});
}

/// @nodoc
class _$ResponseErrorCopyWithImpl<$Res>
    implements $ResponseErrorCopyWith<$Res> {
  _$ResponseErrorCopyWithImpl(this._self, this._then);

  final ResponseError _self;
  final $Res Function(ResponseError) _then;

  /// Create a copy of ErrorType
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = freezed,
    Object? error = freezed,
    Object? statusCode = freezed,
  }) {
    return _then(ResponseError(
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      statusCode: freezed == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class ConnectionTimeout extends ErrorType {
  const ConnectionTimeout() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ConnectionTimeout);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ErrorType.connectionTimeout()';
  }
}

/// @nodoc

class ReceiveTimeout extends ErrorType {
  const ReceiveTimeout() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is ReceiveTimeout);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ErrorType.receiveTimeout()';
  }
}

/// @nodoc

class SendTimeout extends ErrorType {
  const SendTimeout() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is SendTimeout);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ErrorType.sendTimeout()';
  }
}

/// @nodoc

class UnknownError extends ErrorType {
  const UnknownError() : super._();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is UnknownError);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'ErrorType.unknown()';
  }
}

// dart format on
