import 'package:dart_frog/dart_frog.dart';

/// Extension methods for the [RequestContext] class.
extension RequestContextX on RequestContext {
  /// Reads a value of type [Future<T>] from the context.
  Future<T> readAsync<T extends Object>() => read<Future<T>>();
}
