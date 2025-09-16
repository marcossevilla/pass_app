// Can cause issues when accessing variables in the test.
// ignore_for_file: prefer_const_constructors

import 'package:api_models/api_models.dart';
import 'package:db_client/db_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class _MockDbClient extends Mock implements DbClient {}

class _FakeDbEntityRecord extends Fake implements DbEntityRecord {
  _FakeDbEntityRecord({Map<String, dynamic>? data}) : _data = data ?? {};

  final Map<String, dynamic> _data;

  @override
  Map<String, dynamic> get data => _data;
}

void main() {
  group(UserRepository, () {
    const id =
        'ae5deb822e0d71992900471a7199d0d95b8e7c9d05c40a8245a281fd2c1d6684';
    const password =
        '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8';

    late DataBox box;
    late DbClient dbClient;
    late UserRepository repository;

    setUpAll(() {
      registerFallbackValue(_FakeDbEntityRecord());
    });

    setUp(() {
      box = DataBox.users;
      dbClient = _MockDbClient();
      repository = UserRepository(dbClient: dbClient);
    });

    test(
      'can be instantiated',
      () => expect(UserRepository(dbClient: dbClient), isNotNull),
    );

    group('userFromCredentials', () {
      test('returns null if client throws', () async {
        when(
          () => dbClient.getBy(box, fields: any(named: 'fields')),
        ).thenThrow(Exception());

        await expectLater(
          repository.userFromCredentials('testuser', 'password'),
          completion(isNull),
        );
      });

      test('returns user if client succeeds', () async {
        when(
          () => dbClient.getBy(box, fields: any(named: 'fields')),
        ).thenReturn([
          DbEntityRecord(
            id: id,
            data: User(
              id: 'testid',
              username: 'testuser',
              password: password,
            ).toJson(),
          ),
        ]);

        await expectLater(
          repository.userFromCredentials('testuser', 'password'),
          completion(
            equals(
              User(
                id: 'testid',
                username: 'testuser',
                password: password,
              ),
            ),
          ),
        );
      });
    });

    group('userFromId', () {
      test('returns user', () async {
        final user = User(
          id: 'id',
          username: 'testuser',
          password: 'password',
        );

        when(
          () => dbClient.get(box, id: any(named: 'id')),
        ).thenReturn(_FakeDbEntityRecord(data: user.toJson()));

        await expectLater(
          repository.userFromId(id),
          completion(equals(user)),
        );
      });

      test('returns null when db client fails', () async {
        when(
          () => dbClient.get(box, id: any(named: 'id')),
        ).thenThrow(Exception());

        await expectLater(
          repository.userFromId(id),
          completion(isNull),
        );
      });
    });

    group('createUser', () {
      test('adds a new user, returning its id', () async {
        when(() => dbClient.add(box, data: any(named: 'data'))).thenAnswer(
          (_) => Future.value(id),
        );
        when(
          () => dbClient.update(box, record: any(named: 'record')),
        ).thenAnswer((_) => Future.value());

        await expectLater(
          repository.createUser(
            username: 'testuser',
            password: 'password',
          ),
          completion(equals(id)),
        );
      });

      test('throws when db client fails', () async {
        when(
          () => dbClient.add(box, data: any(named: 'data')),
        ).thenThrow(Exception());

        await expectLater(
          repository.createUser(
            username: 'testuser',
            password: 'password',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
