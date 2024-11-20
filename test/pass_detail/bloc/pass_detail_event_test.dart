import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/pass_detail/pass_detail.dart';
import 'package:passkit/passkit.dart';

class _FakePkPass extends Fake implements PkPass {}

void main() {
  group('PassDetailEvent', () {
    group('PassDetailPassAdded', () {
      test('supports value comparisons', () {
        final pkPass = _FakePkPass();
        expect(
          PassDetailPassAdded(pkPass),
          equals(PassDetailPassAdded(pkPass)),
        );
      });
    });
  });
}
