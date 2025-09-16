import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:db_client/db_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_data_source/pass_data_source.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

class _MockUuid extends Mock implements Uuid {}

class _MockDbClient extends Mock implements DbClient {}

class _MockPkPass extends Mock implements PkPass {}

class _MockPassData extends Mock implements PassData {}

class _FakeFile extends Fake implements File {
  @override
  String readAsStringSync({Encoding encoding = utf8}) => 'file';
}

void main() {
  group(PassDataSource, () {
    late Uuid uuid;
    late DbClient dbClient;
    late PkPass pkPass;
    late PassDataSource passDataSource;

    setUp(() {
      uuid = _MockUuid();
      dbClient = _MockDbClient();
      pkPass = _MockPkPass();

      when(() => uuid.v4(config: any(named: 'config'))).thenReturn('id');

      passDataSource = PassDataSource(
        uuid: uuid,
        dbClient: dbClient,
      );
    });

    test('can be instantiated', () {
      expect(PassDataSource(dbClient: dbClient), isNotNull);
    });

    group('sign', () {
      late PassData passData;

      setUp(() {
        passData = _MockPassData();

        when(() => pkPass.pass).thenReturn(passData);
        when(
          () => pkPass.copyWith(pass: any(named: 'pass')),
        ).thenReturn(pkPass);
        when(() => passData.serialNumber).thenReturn('serialNumber');
        when(
          () => passData.copyWith(serialNumber: any(named: 'serialNumber')),
        ).thenReturn(passData);
      });

      test('returns bytes correctly', () async {
        when(
          () => pkPass.write(
            certificatePem: any(named: 'certificatePem'),
            privateKeyPem: any(named: 'privateKeyPem'),
          ),
        ).thenReturn(Uint8List.fromList([1, 2, 3]));

        await expectLater(
          passDataSource.sign(
            pkPass,
            privateKey: _FakeFile(),
            passCertificate: _FakeFile(),
          ),
          completion(isA<Uint8List>()),
        );
      });

      test('throws when returned bytes are null', () async {
        when(
          () => pkPass.write(
            privateKeyPem: any(named: 'privateKeyPem'),
            certificatePem: any(named: 'certificatePem'),
          ),
        ).thenReturn(null);

        await expectLater(
          passDataSource.sign(
            pkPass,
            privateKey: _FakeFile(),
            passCertificate: _FakeFile(),
          ),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('create', () {
      test('returns an id when pass was created successfully', () async {
        when(
          () => dbClient.add(DataBox.passes, data: any(named: 'data')),
        ).thenAnswer((_) => Future.value('id'));

        await expectLater(
          passDataSource.create(
            userId: 'userId',
            bytes: Uint8List.fromList([1, 2, 3]),
          ),
          completion(equals('id')),
        );
      });
    });
  });
}
