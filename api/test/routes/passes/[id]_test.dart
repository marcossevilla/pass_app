import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_data_source/pass_data_source.dart';
import 'package:test/test.dart';

import '../../../routes/passes/[id].dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockPassDataSource extends Mock implements PassDataSource {}

void main() {
  group('/passes/[id]', () {
    late RequestContext context;
    late PassDataSource passDataSource;

    setUp(() {
      context = _MockRequestContext();
      passDataSource = _MockPassDataSource();

      when(
        () => context.readAsync<PassDataSource>(),
      ).thenAnswer((_) => Future.value(passDataSource));
    });

    group('[GET]', () {
      test('returns encoded bytes when data source succeeds', () async {
        const id = 'id';
        final bytes = Uint8List.fromList([1, 2, 3]);

        when(() => context.request).thenReturn(
          Request.get(
            Uri.parse('http://localhost/routes/passes/$id'),
          ),
        );

        when(() => passDataSource.read(id)).thenReturn(bytes);

        final response = await onRequest(context, id);
        final body = await response.body();
        final decodedBody = json.decode(body) as Map<String, dynamic>;

        expect(decodedBody, equals({'data': base64.encode(bytes)}));
      });

      test('returns not found when data source fails', () async {
        const id = 'id';

        when(() => context.request).thenReturn(
          Request.get(
            Uri.parse('http://localhost/routes/passes/$id'),
          ),
        );

        when(() => passDataSource.read(id)).thenThrow(Exception());

        await expectLater(
          onRequest(context, id),
          completion(
            isA<Response>().having(
              (response) => response.statusCode,
              'statusCode',
              equals(HttpStatus.notFound),
            ),
          ),
        );
      });
    });

    test('any other method returns method not allowed', () async {
      const id = 'id';

      when(() => context.request).thenReturn(
        Request.post(
          Uri.parse('http://localhost/routes/passes/$id'),
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
