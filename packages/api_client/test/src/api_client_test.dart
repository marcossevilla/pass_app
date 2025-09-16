import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group(ApiClient, () {
    test(
      'can be instantiated',
      () => expect(ApiClient(host: 'localhost:8080'), isNotNull),
    );
  });
}
