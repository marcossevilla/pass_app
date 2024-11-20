import 'package:api_models/api_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/sign_in/sign_in.dart';

void main() {
  group('SignInState', () {
    group('copyWith', () {
      test(
        'returns same object when no properties are passed',
        () => expect(SignInState().copyWith(), equals(SignInState())),
      );

      test('returns object with updated properties', () {
        final state = SignInState(
          username: 'username',
          password: 'password',
          user: User(
            id: 'id',
            username: 'username',
            password: 'password',
          ),
          status: FormzSubmissionStatus.success,
        );
        expect(
          state.copyWith(
            username: 'new_username',
            password: 'new_password',
            user: User(
              id: 'new_id',
              username: 'new_username',
              password: 'new_password',
            ),
            status: FormzSubmissionStatus.inProgress,
          ),
          equals(
            SignInState(
              username: 'new_username',
              password: 'new_password',
              user: User(
                id: 'new_id',
                username: 'new_username',
                password: 'new_password',
              ),
              status: FormzSubmissionStatus.inProgress,
            ),
          ),
        );
      });
    });
  });
}
