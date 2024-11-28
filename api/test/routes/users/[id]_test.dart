import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:api_models/api_models.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../../../routes/users/[id].dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('/users/[id]', () {
    late RequestContext context;
    late UserRepository userRepository;
    late User user;

    setUp(() {
      context = _MockRequestContext();
      userRepository = _MockUserRepository();
      user = const User(id: 'id', username: 'username', password: 'password');

      when(
        () => context.readAsync<UserRepository>(),
      ).thenAnswer((_) => Future.value(userRepository));
    });

    test('[GET] returns a User', () async {
      const id = 'id';

      when(() => context.request).thenReturn(
        Request.get(
          Uri.parse('http://localhost/routes/users/$id'),
        ),
      );

      when(
        () => userRepository.userFromId(id),
      ).thenAnswer((_) => Future.value(user));

      final response = await onRequest(context, id);
      final body = await response.body();

      expect(
        User.fromJson(jsonDecode(body) as Map<String, dynamic>),
        isA<User>(),
      );
    });

    test('any other method returns method not allowed', () async {
      const id = 'id';

      when(() => context.request).thenReturn(
        Request.post(
          Uri.parse('http://localhost/routes/users/$id'),
        ),
      );

      expect(
        onRequest(context, id),
        isA<Response>().having(
          (response) => response.statusCode,
          'statusCode',
          equals(HttpStatus.methodNotAllowed),
        ),
      );
    });
  });
}
