// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../routes/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('middleware', () {
    late RequestContext context;
    late Request request;

    setUp(() {
      context = _MockRequestContext();
      request = Request.get(Uri.parse('http://localhost/'));

      when(() => context.request).thenReturn(request);
      when(() => context.provide<Future<DbClient>>(any())).thenReturn(context);
    });

    test('provides a DbClient instance', () async {
      final handler = middleware((_) => Response());

      await handler(context);

      final create = verify(
        () => context.provide<Future<DbClient>>(captureAny()),
      ).captured.single as Future<DbClient> Function();

      await expectLater(
        create(),
        completion(isA<DbClient>()),
      );
    });

    test(
      'returns Response with HttpStatus.notFound when NotFound is thrown',
      () async {
        final handler = middleware((_) => throw NotFound('Not found'));

        await expectLater(
          handler(context),
          completion(
            isA<Response>().having(
              (response) => response.statusCode,
              'statusCode',
              equals(HttpStatus.notFound),
            ),
          ),
        );
      },
    );

    test(
      'returns Response with HttpStatus.badRequest when BadRequest is thrown',
      () async {
        final handler = middleware((_) => throw BadRequest('Bad request'));

        await expectLater(
          handler(context),
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
}
