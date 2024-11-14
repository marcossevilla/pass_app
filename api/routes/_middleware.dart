import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';

Handler middleware(Handler handler) {
  return (context) async {
    try {
      return await handler
          .use(requestLogger())
          .use(dbClientProvider())
          .call(context);
    } on NotFound catch (error) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: error.toJson(),
      );
    } on BadRequest catch (error) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: error.toJson(),
      );
    }
  };
}

Middleware dbClientProvider() {
  return provider<Future<DbClient>>((context) async {
    Hive
      ..init(Directory.current.path)
      ..registerAdapters();

    final usersBox = await Hive.openBox<DbEntityRecord>(DataBox.users.name);
    final passesBox = await Hive.openBox<DbEntityRecord>(DataBox.passes.name);

    return DbClient(
      usersBox: usersBox,
      passesBox: passesBox,
    );
  });
}
