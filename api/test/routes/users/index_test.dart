import 'dart:convert';
import 'dart:io';

import 'package:api/api.dart';
import 'package:api_models/api_models.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

import '../../../routes/users/index.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('/users', () {
    late Uri uri;
    late RequestContext context;
    late UserRepository userRepository;
    late User user;

    setUp(() {
      uri = Uri.parse('http://localhost/routes/users/');
      context = _MockRequestContext();
      userRepository = _MockUserRepository();
      user = User(id: 'id', username: 'username', password: 'password');

      when(
        () => context.readAsync<UserRepository>(),
      ).thenAnswer((_) => Future.value(userRepository));
    });

    group('[POST]', () {
      test('returns an ID when user was created successfully', () async {
        const id = 'id';

        when(() => context.request).thenReturn(
          Request.post(
            uri,
            body: json.encode({
              'username': 'username',
              'password': 'password',
            }),
          ),
        );

        when(
          () => userRepository.createUser(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(id));

        final response = await onRequest(context);
        final body = await response.body();
        final decodedBody = json.decode(body) as Map<String, dynamic>;

        expect(
          decodedBody,
          isMap.having((map) => map.containsValue(id), 'value', isTrue),
        );
      });

      test(
        'returns response with bad request if username or password is null',
        () async {
          const id = 'id';

          when(() => context.request).thenReturn(
            Request.post(uri, body: json.encode({})),
          );

          when(
            () => userRepository.createUser(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) => Future.value(id));

          await expectLater(
            onRequest(context),
            completion(
              isA<Response>().having(
                (response) => response.statusCode,
                'statusCode',
                equals(HttpStatus.badRequest),
              ),
            ),
          );
        },
      );
    });

    group('[GET]', () {
      test('returns bad request if query parameters are missing', () async {
        when(() => context.request).thenReturn(
          Request.get(
            Uri.http(
              'localhost',
              '/routes/users/',
              {},
            ),
          ),
        );

        await expectLater(
          onRequest(context),
          completion(
            isA<Response>().having(
              (response) => response.statusCode,
              'statusCode',
              equals(HttpStatus.badRequest),
            ),
          ),
        );
      });

      test('returns not found if user is not found', () async {
        when(() => context.request).thenReturn(
          Request.get(
            Uri.http(
              'localhost',
              '/routes/users/',
              {'username': 'username', 'password': 'password'},
            ),
          ),
        );

        when(
          () => userRepository.userFromCredentials(any(), any()),
        ).thenReturn(null);

        await expectLater(
          onRequest(context),
          completion(
            isA<Response>().having(
              (response) => response.statusCode,
              'statusCode',
              equals(HttpStatus.notFound),
            ),
          ),
        );
      });

      test('returns user when repository returns correctly', () async {
        when(() => context.request).thenReturn(
          Request.get(
            Uri.http(
              'localhost',
              '/routes/users/',
              {'username': 'username', 'password': 'password'},
            ),
          ),
        );

        when(
          () => userRepository.userFromCredentials(any(), any()),
        ).thenReturn(user);

        final response = await onRequest(context);
        final body = await response.body();
        final decodedBody = json.decode(body) as Map<String, dynamic>;

        expect(User.fromJson(decodedBody), equals(user));
      });
    });

    test('any other method returns method not allowed', () async {
      when(() => context.request).thenReturn(Request.delete(uri));

      expect(
        onRequest(context),
        isA<Response>().having(
          (response) => response.statusCode,
          'statusCode',
          equals(HttpStatus.methodNotAllowed),
        ),
      );
    });
  });
}
