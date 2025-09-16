/// {@template api_error}
/// Error thrown when an error occurs while interacting with the API.
/// {@endtemplate}
class ApiError implements Exception {
  /// {@macro api_error}
  const ApiError({
    this.message,
    this.stackTrace = StackTrace.empty,
  });

  /// General description of what went wrong.
  final String? message;

  /// Stack trace of the error.
  final StackTrace stackTrace;

  @override
  String toString() => '$message\n$stackTrace';
}

/// {@template no_data_error}
/// Error thrown when no data is returned from the API.
/// {@endtemplate}
class NoDataError extends ApiError {
  /// {@macro no_data_error}
  NoDataError()
    : super(
        message: 'No data returned',
        stackTrace: StackTrace.current,
      );
}
