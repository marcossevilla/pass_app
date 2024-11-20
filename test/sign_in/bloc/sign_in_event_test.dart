import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/sign_in/sign_in.dart';

void main() {
  group('SignInEvent', () {
    group('SignInUsernameChanged', () {
      test('supports value comparisons', () {
        expect(
          SignInUsernameChanged('username'),
          equals(SignInUsernameChanged('username')),
        );
      });
    });

    group('SignInPasswordChanged', () {
      test('supports value comparisons', () {
        expect(
          SignInPasswordChanged('password'),
          equals(SignInPasswordChanged('password')),
        );
      });
    });

    group('SignInFormSubmitted', () {
      test('supports value comparisons', () {
        expect(SignInFormSubmitted(), equals(SignInFormSubmitted()));
      });
    });
  });
}
