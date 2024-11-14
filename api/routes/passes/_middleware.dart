import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:pass_data_source/pass_data_source.dart';

Handler middleware(Handler handler) {
  return handler.use(passDataSourceProvider());
}

Middleware passDataSourceProvider() {
  return provider<Future<PassDataSource>>(
    (context) async {
      final dbClient = await context.readAsync<DbClient>();
      return PassDataSource(dbClient: dbClient);
    },
  );
}
