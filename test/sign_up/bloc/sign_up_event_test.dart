import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/sign_up/sign_up.dart';

void main() {
  group('SignUpEvent', () {
    group('SignUpUsernameChanged', () {
      test('supports value comparisons', () {
        expect(
          SignUpUsernameChanged('username'),
          equals(SignUpUsernameChanged('username')),
        );
      });
    });

    group('SignUpPasswordChanged', () {
      test('supports value comparisons', () {
        expect(
          SignUpPasswordChanged('password'),
          equals(SignUpPasswordChanged('password')),
        );
      });
    });

    group('SignUpFormSubmitted', () {
      test('supports value comparisons', () {
        expect(SignUpFormSubmitted(), equals(SignUpFormSubmitted()));
      });
    });
  });
}
