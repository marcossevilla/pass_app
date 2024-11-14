import 'package:api/api.dart';
import 'package:api_models/api_models.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:db_client/db_client.dart';
import 'package:user_repository/user_repository.dart';

Handler middleware(Handler handler) {
  return handler.use(authenticationProvider()).use(userRepositoryProvider());
}

Middleware authenticationProvider() {
  return basicAuthentication<User>(
    authenticator: (context, username, password) async {
      final userRepository = await context.readAsync<UserRepository>();
      final user = await userRepository.userFromCredentials(username, password);
      return user;
    },
    applies: (context) async {
      final method = context.request.method;
      return method != HttpMethod.get && method != HttpMethod.post;
    },
  );
}

Middleware userRepositoryProvider() {
  return provider<Future<UserRepository>>(
    (context) async {
      final dbClient = await context.readAsync<DbClient>();
      return UserRepository(dbClient: dbClient);
    },
  );
}
