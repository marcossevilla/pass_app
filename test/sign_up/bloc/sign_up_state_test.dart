import 'package:api_models/api_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/sign_up/sign_up.dart';

void main() {
  group('SignUpState', () {
    group('copyWith', () {
      test(
        'returns same object when no properties are passed',
        () => expect(SignUpState().copyWith(), equals(SignUpState())),
      );

      test('returns object with updated properties', () {
        final state = SignUpState(
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
            SignUpState(
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
