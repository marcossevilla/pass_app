import 'dart:async';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:user_repository/user_repository.dart';

FutureOr<Response> onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _getUser(context, id),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _getUser(RequestContext context, String id) async {
  final userRepository = await context.readAsync<UserRepository>();
  final user = await userRepository.userFromId(id);

  return Response.json(body: user);
}
