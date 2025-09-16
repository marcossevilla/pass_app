import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  group(PassRepository, () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = _MockApiClient();
    });

    test(
      'can be instantiated',
      () => expect(PassRepository(apiClient: apiClient), isNotNull),
    );
  });
}
