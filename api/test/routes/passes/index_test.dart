import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_data_source/pass_data_source.dart';
import 'package:test/test.dart';

import '../../../routes/passes/index.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockPassDataSource extends Mock implements PassDataSource {}

class _FakeFile extends Fake implements File {}

class _FakePkPass extends Fake implements PkPass {}

class _FakePassData extends Fake implements PassData {
  @override
  Map<String, dynamic> toJson() {
    return {
      'teamIdentifier': 'teamIdentifier',
      'passTypeIdentifier': 'passTypeIdentifier',
      'logoText': 'logoText',
      'description': 'description',
      'serialNumber': 'serialNumber',
      'organizationName': 'organizationName',
      'eventTicket': {
        'primaryFields': [
          {
            'key': 'key',
            'label': 'label',
            'value': 'value',
          },
        ],
        'secondaryFields': [
          {
            'key': 'key',
            'label': 'label',
            'value': 'value',
          },
        ],
        'auxiliaryFields': [
          {
            'key': 'key',
            'label': 'label',
            'value': 'value',
          },
        ],
        'backFields': [
          {
            'key': 'key',
            'label': 'label',
            'value': 'value',
          },
        ],
      },
      'suppressStripShine': false,
      'labelColor': '#ca4d4f',
      'backgroundColor': '#FFFFFF',
      'foregroundColor': '#000000',
      'locations': [
        {'latitude': -16.39889, 'longitude': -71.535},
      ],
      'barcodes': [
        {
          'format': 'PKBarcodeFormatQR',
          'message': 'https://flutterconflatam.dev/',
          'messageEncoding': 'iso-8859-1',
        },
      ],
    };
  }
}

void main() {
  group('/passes', () {
    setUpAll(() {
      registerFallbackValue(_FakeFile());
      registerFallbackValue(_FakePkPass());
      registerFallbackValue(Uint8List.fromList([1, 2, 3]));
    });

    late Uri uri;
    late RequestContext context;
    late PassDataSource passDataSource;

    setUp(() {
      uri = Uri.parse('http://localhost/routes/passes/');
      context = _MockRequestContext();
      passDataSource = _MockPassDataSource();

      when(
        () => context.readAsync<PassDataSource>(),
      ).thenAnswer((_) => Future.value(passDataSource));
    });

    group('[GET]', () {
      test(
        'returns response with bad request if user ID is not provided',
        () async {
          when(() => context.request).thenReturn(Request.get(uri));

          await expectLater(
            onRequest(context),
            completion(
              isA<Response>()
                  .having(
                    (response) => response.statusCode,
                    'statusCode',
                    equals(HttpStatus.badRequest),
                  )
                  .having(
                    (response) => response.body(),
                    'body',
                    completion(equals('Missing query parameter: userId')),
                  ),
            ),
          );
        },
      );

      test(
        'returns response with a list of pass bytes '
        'when data source returns correctly',
        () async {
          final bytes = [
            Uint8List.fromList([1, 2, 3]),
            Uint8List.fromList([4, 5, 6]),
          ];

          when(() => context.request).thenReturn(
            Request.get(
              Uri.http(
                'localhost',
                '/routes/passes/',
                {'userId': 'userId'},
              ),
            ),
          );

          when(() => passDataSource.readByUserId('userId')).thenAnswer(
            (_) => Future.value(bytes),
          );

          final response = await onRequest(context);
          final body = await response.body();

          expect(
            json.decode(body),
            equals([
              {'data': base64.encode(bytes.first)},
              {'data': base64.encode(bytes.last)},
            ]),
          );
        },
      );
    });

    group('[POST]', () {
      test(
        'returns response with bad request if user ID is not provided',
        () async {
          when(() => context.request).thenReturn(Request.post(uri));

          await expectLater(
            onRequest(context),
            completion(
              isA<Response>()
                  .having(
                    (response) => response.statusCode,
                    'statusCode',
                    equals(HttpStatus.badRequest),
                  )
                  .having(
                    (response) => response.body(),
                    'body',
                    completion(equals('Missing query parameter: userId')),
                  ),
            ),
          );
        },
      );

      test('returns an ID when user was created successfully', () async {
        when(() => context.request).thenReturn(
          Request.post(
            Uri.http(
              'localhost',
              '/routes/passes/',
              {'userId': 'userId'},
            ),
            body: json.encode(_FakePassData().toJson()),
          ),
        );

        when(
          () => passDataSource.sign(
            any(),
            passCertificate: any(named: 'passCertificate'),
            privateKey: any(named: 'privateKey'),
          ),
        ).thenAnswer((_) => Future.value(Uint8List.fromList([1, 2, 3])));

        when(
          () => passDataSource.create(
            userId: any(named: 'userId'),
            bytes: any(named: 'bytes'),
          ),
        ).thenAnswer((_) => Future.value('id'));

        final response = await onRequest(context);
        final body = await response.body();
        final decodedBody = json.decode(body) as Map<String, dynamic>;

        expect(response.statusCode, equals(HttpStatus.created));
        expect(decodedBody, equals({'id': 'id'}));
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
