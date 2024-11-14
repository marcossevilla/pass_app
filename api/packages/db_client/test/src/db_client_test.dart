// ignore_for_file: prefer_const_constructors

import 'package:db_client/db_client.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

class _MockUuid extends Mock implements Uuid {}

class _MockBox<DbEntityRecord> extends Mock implements Box<DbEntityRecord> {}

class _FakeDbEntityRecord extends Fake implements DbEntityRecord {
  @override
  Map<String, dynamic> get data => {'name': 'test'};
}

void main() {
  group('DbClient', () {
    setUpAll(() {
      registerFallbackValue(_FakeDbEntityRecord());
    });

    late Uuid uuid;
    late Box<DbEntityRecord> usersBox;
    late Box<DbEntityRecord> passesBox;
    late DbClient dbClient;

    setUp(() {
      uuid = _MockUuid();
      usersBox = _MockBox();
      passesBox = _MockBox();

      when(() => uuid.v4(config: any(named: 'config'))).thenReturn('id');

      dbClient = DbClient(
        uuid: uuid,
        usersBox: usersBox,
        passesBox: passesBox,
      );
    });

    test(
      'can instantiate',
      () => expect(
        DbClient(
          uuid: uuid,
          usersBox: usersBox,
          passesBox: passesBox,
        ),
        isNotNull,
      ),
    );

    group('resolveBox', () {
      test('returns correct box', () {
        expect(dbClient.resolveBox(DataBox.users), usersBox);
        expect(dbClient.resolveBox(DataBox.passes), passesBox);
      });
    });

    group('add', () {
      test('returns the expected id when adding a new record', () async {
        when(() => usersBox.put(any<Object>(), any())).thenAnswer(
          (_) => Future.value(),
        );

        await expectLater(
          dbClient.add(DataBox.users, data: {}),
          completion('id'),
        );
      });

      test('throws when box fails', () async {
        when(() => usersBox.put(any<Object>(), any())).thenThrow(Exception());

        await expectLater(
          dbClient.add(DataBox.users, data: {}),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('get', () {
      test('returns the expected record', () {
        when(
          () => usersBox.get(
            any<Object>(),
            defaultValue: any(named: 'defaultValue'),
          ),
        ).thenReturn(_FakeDbEntityRecord());

        expect(
          dbClient.get(DataBox.users, id: 'id'),
          isA<DbEntityRecord>(),
        );
      });

      test('throws when box returns null', () {
        when(
          () => usersBox.get(
            any<Object>(),
            defaultValue: any(named: 'defaultValue'),
          ),
        ).thenReturn(null);

        expect(
          () => dbClient.get(DataBox.users, id: 'id'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getBy', () {
      test('returns the expected record', () {
        when(() => usersBox.values).thenReturn([_FakeDbEntityRecord()]);

        expect(
          dbClient.getBy(DataBox.users, fields: {'name': 'test'}),
          isA<DbEntityRecord>(),
        );
      });

      test('throws when record is not found', () {
        when(() => usersBox.values).thenReturn([]);

        expect(
          () => dbClient.getBy(DataBox.users, fields: {'name': 'test'}),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('update', () {
      test('completes when updating a record', () async {
        when(() => usersBox.put(any<Object>(), any())).thenAnswer(
          (_) => Future.value(),
        );

        await expectLater(
          dbClient.update(DataBox.users, record: DbEntityRecord(id: 'id')),
          completes,
        );
      });

      test('throws when box fails', () async {
        when(() => usersBox.put(any<Object>(), any())).thenThrow(Exception());

        await expectLater(
          dbClient.update(DataBox.users, record: DbEntityRecord(id: 'id')),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
