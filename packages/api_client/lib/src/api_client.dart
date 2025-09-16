import 'dart:convert';

import 'package:api_client/api_client.dart';
import 'package:api_models/api_models.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Type definition for a model that can be converted from JSON.
typedef ModelFromJson<T> = T Function(Map<String, dynamic>);

/// Type definition for a list of models that can be converted from JSON.
typedef ModelFromJsonList<T> = T Function(List<Map<String, dynamic>>);

/// {@template api_client}
/// A client to interact with the Dart Frog API.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  ApiClient({
    required this.host,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    if (dio != null) {
      _dio.interceptors.add(
        PrettyDioLogger(requestHeader: true),
      );
    }
  }

  final Dio _dio;

  /// The host of the API.
  final String host;

  /// HTTP GET method.
  static const get = 'GET';

  /// HTTP POST method.
  static const post = 'POST';

  /// HTTP PUT method.
  static const put = 'PUT';

  /// HTTP PATCH method.
  static const patch = 'PATCH';

  /// HTTP DELETE method.
  static const delete = 'DELETE';

  static const _usersPath = '/users';

  static const _passesPath = '/passes';

  /// Generic method to perform an API request.
  @protected
  Future<T> callApi<T>({
    required String path,
    String httpMethod = get,
    dynamic body,
    String? contentType,
    Map<String, dynamic>? queryParameters = const <String, dynamic>{},
    ModelFromJson<T>? modelFromJson,
    ModelFromJsonList<T>? modelFromJsonList,
  }) async {
    late final Response<dynamic> response;

    try {
      response = await _dio.requestUri(
        Uri.http(host, path, queryParameters),
        data: json.encode(body),
        options: Options(
          method: httpMethod,
          contentType: contentType,
        ),
      );
    } on DioException catch (error, stackTrace) {
      throw ApiError(
        message: error.message,
        stackTrace: stackTrace,
      );
    }

    if (modelFromJson == null && modelFromJsonList == null) {
      // If JSON converters are not provided, we assume it's a void response.
      return Future<T>.value();
    }

    final data = response.data;

    if (data == null) throw NoDataError();

    if (modelFromJson != null && data is Map<String, dynamic>) {
      return modelFromJson(data);
    }

    if (modelFromJsonList != null && data is List) {
      return modelFromJsonList(data.cast<Map<String, dynamic>>());
    }

    throw ApiError(
      message: 'Unknown error',
      stackTrace: StackTrace.current,
    );
  }

  /// Create a user.
  Future<String> createUser({
    required String username,
    required String password,
  }) async {
    try {
      final response = await callApi<String>(
        path: _usersPath,
        httpMethod: post,
        modelFromJson: (json) => json['id'] as String,
        body: {
          'username': username,
          'password': password,
        },
      );
      return response;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const ApiError(message: 'Failed to create user'),
        stackTrace,
      );
    }
  }

  /// Find a user by ID.
  Future<User> findUserBy({required String id}) async {
    try {
      final user = await callApi<User>(
        path: '$_usersPath/$id',
        modelFromJson: User.fromJson,
      );
      return user;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const ApiError(message: 'Failed to find user'),
        stackTrace,
      );
    }
  }

  /// Sign in a user with the given [username] and [password].
  Future<User> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final user = await callApi<User>(
        path: _usersPath,
        modelFromJson: User.fromJson,
        queryParameters: {
          'username': username,
          'password': password,
        },
      );
      return user;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const ApiError(message: 'Failed to sign in user'),
        stackTrace,
      );
    }
  }

  /// Create a pass. Returns the pass ID.
  Future<String> createPass({
    required String userId,
    required PassData passData,
  }) async {
    try {
      final response = await callApi<String>(
        path: _passesPath,
        httpMethod: post,
        body: passData.toJson(),
        modelFromJson: (json) => json['id'] as String,
        queryParameters: {'userId': userId},
      );
      return response;
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(
        const ApiError(message: 'Failed to create pass'),
        stackTrace,
      );
    }
  }

  /// Get all passes for a [User].
  Future<List<PkPass>> getPassesForUser({required String userId}) async {
    try {
      final response = await callApi<List<PkPass>>(
        path: _passesPath,
        queryParameters: {'userId': userId},
        modelFromJsonList: passesFromJsonList,
      );
      return response;
    } on Exception catch (error, stackTrace) {
      throw ApiError(
        message: 'Failed to get passes',
        stackTrace: stackTrace,
      );
    }
  }

  /// Get a pass by ID.
  Future<PkPass> getPassById({required String id}) async {
    try {
      final response = await callApi<PkPass>(
        path: '$_passesPath/$id',
        modelFromJson: passFromJson,
      );
      return response;
    } on Exception catch (error, stackTrace) {
      throw ApiError(
        message: 'Failed to get pass by ID',
        stackTrace: stackTrace,
      );
    }
  }
}

/// Convert a JSON map to a [PkPass] object.
PkPass passFromJson(Map<String, dynamic> json) {
  final data = json['data'] as String;
  return PkPass.fromBytes(base64.decode(data));
}

/// Convert a list of JSON maps to a list of [PkPass] objects.
List<PkPass> passesFromJsonList(List<Map<String, dynamic>> jsonList) {
  return jsonList.map(passFromJson).toList();
}
