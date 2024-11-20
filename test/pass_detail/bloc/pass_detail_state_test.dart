import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/pass_detail/pass_detail.dart';
import 'package:passkit/passkit.dart';

class _FakePkPass extends Fake implements PkPass {}

void main() {
  group('PassDetailState', () {
    late PkPass pkPass;

    setUp(() {
      pkPass = _FakePkPass();
    });

    test(
      'returns same object when no arguments are passed',
      () => expect(
        PassDetailState(pass: pkPass).copyWith(),
        equals(PassDetailState(pass: pkPass)),
      ),
    );

    test(
      'returns object with updated properties',
      () => expect(
        PassDetailState(pass: pkPass).copyWith(status: PassDetailStatus.added),
        equals(PassDetailState(pass: pkPass, status: PassDetailStatus.added)),
      ),
    );
  });
}
