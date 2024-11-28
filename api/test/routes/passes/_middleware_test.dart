import 'package:api/api.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_data_source/pass_data_source.dart';
import 'package:test/test.dart';

import '../../../routes/passes/_middleware.dart';

class _MockRequestContext extends Mock implements RequestContext {}

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('middleware', () {
    late RequestContext context;
    late Request request;
    late DbClient dbClient;

    setUp(() {
      context = _MockRequestContext();
      request = Request.get(Uri.parse('http://localhost/passes/'));
      dbClient = _MockDbClient();

      when(() => context.request).thenReturn(request);
      when(context.readAsync<DbClient>).thenAnswer(
        (_) => Future.value(dbClient),
      );
      when(
        () => context.provide<Future<PassDataSource>>(any()),
      ).thenReturn(context);
    });

    test('provides a PassDataSource instance', () async {
      final handler = middleware((_) => Response());

      await handler(context);

      final create = verify(
        () => context.provide<Future<PassDataSource>>(captureAny()),
      ).captured.single as Future<PassDataSource> Function();

      await expectLater(
        create(),
        completion(isA<PassDataSource>()),
      );
    });
  });
}
