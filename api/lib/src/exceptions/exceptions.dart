/// {@template bad_request}
/// Exception thrown when a request is invalid.
/// {@endtemplate}
class BadRequest implements Exception {
  /// {@macro bad_request}
  const BadRequest(this.type, [this.data = const {}]);

  /// The type of the bad request.
  final String type;

  /// Additional data about the bad request.
  final Map<String, dynamic> data;

  /// Converts the [BadRequest] to a JSON-encodable [Map].
  Map<String, dynamic> toJson() {
    return {'type': type, 'data': data};
  }
}

/// {@template not_found}
/// Exception thrown when a resource is not found.
/// {@endtemplate}
class NotFound implements Exception {
  /// {@macro not_found}
  const NotFound(this.type, [this.data = const {}]);

  /// The type of the not found resource.
  final String type;

  /// Additional data about the not found resource.
  final Map<String, dynamic> data;

  /// Converts the [NotFound] to a JSON-encodable [Map].
  Map<String, dynamic> toJson() {
    return {'type': type, 'data': data};
  }
}
