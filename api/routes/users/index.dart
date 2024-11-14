import 'dart:async';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:user_repository/user_repository.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.post => _createUser(context),
    HttpMethod.get => _getUser(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _createUser(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final username = body['username'] as String?;
  final password = body['password'] as String?;

  final userRepository = await context.readAsync<UserRepository>();

  if (username != null && password != null) {
    final id = await userRepository.createUser(
      username: username,
      password: password,
    );

    return Response.json(body: {'id': id});
  }

  return Response(statusCode: HttpStatus.badRequest);
}

Future<Response> _getUser(RequestContext context) async {
  final userRepository = await context.readAsync<UserRepository>();
  final queryParams = context.request.uri.queryParameters;

  final user = await userRepository.userFromCredentials(
    queryParams['username']!,
    queryParams['password']!,
  );

  if (user != null) {
    return Response.json(body: user.toJson());
  }

  return Response(statusCode: HttpStatus.notFound);
}
