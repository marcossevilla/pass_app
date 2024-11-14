import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:pass_data_source/pass_data_source.dart';

FutureOr<Response> onRequest(RequestContext context) {
  return switch (context.request.method) {
    HttpMethod.get => _get(context),
    HttpMethod.post => _post(context),
    _ => Response(statusCode: HttpStatus.methodNotAllowed),
  };
}

Future<Response> _get(RequestContext context) async {
  final passDataSource = await context.readAsync<PassDataSource>();
  final userId = context.request.uri.queryParameters['userId']!;
  final passes = await passDataSource.readByUserId(userId);
  final body = passes.map((pass) => {'data': base64.encode(pass)}).toList();

  return Response.json(body: body);
}

Future<Response> _post(RequestContext context) async {
  final passDataSource = await context.readAsync<PassDataSource>();
  final userId = context.request.uri.queryParameters['userId']!;
  final body = await context.request.body();
  final bodyJson = json.decode(body) as Map<String, dynamic>;

  final flutterConfLatamLogo = File(
    '${Directory.current.path}/public/image.png',
  ).readAsBytesSync();

  final unsignedPass = PkPass(
    logo: PkImage(image1: flutterConfLatamLogo),
    icon: PkImage(image1: flutterConfLatamLogo),
    pass: PassData.fromJson(bodyJson),
  );

  final bytes = await passDataSource.sign(
    unsignedPass,
    privateKey: File('data/private_key.pem'),
    passCertificate: File('data/pass_certificate.pem'),
  );

  final passId = await passDataSource.create(
    userId: userId,
    bytes: bytes,
  );

  return Response.json(
    statusCode: HttpStatus.created,
    body: {'id': passId},
  );
}
