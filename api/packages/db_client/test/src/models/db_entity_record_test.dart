import 'package:db_client/db_client.dart';
import 'package:test/test.dart';

void main() {
  group('DbEntityRecord', () {
    test(
      'supports value comparisons',
      () => expect(
        DbEntityRecord(id: 'id'),
        equals(DbEntityRecord(id: 'id')),
      ),
    );
  });
}
