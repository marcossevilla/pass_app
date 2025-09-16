import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:pass_data_source/pass_data_source.dart';

FutureOr<Response> onRequest(RequestContext context, String id) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context, id),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context, String id) async {
  try {
    final passDataSource = await context.readAsync<PassDataSource>();
    final pass = passDataSource.read(id);
    return Response.json(
      body: {
        'data': base64.encode(pass),
      },
    );
  } on Exception catch (_) {
    return Response(
      statusCode: HttpStatus.notFound,
      body: 'Not found',
    );
  }
}
