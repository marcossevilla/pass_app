// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';

void main() {
  group('CreatePassState', () {
    group('copyWith', () {
      test(
        'returns same object when no arguments are passed',
        () => expect(CreatePassState().copyWith(), CreatePassState()),
      );

      test(
        'returns object with updated status when status is passed',
        () => expect(
          CreatePassState().copyWith(status: FormzSubmissionStatus.inProgress),
          CreatePassState(status: FormzSubmissionStatus.inProgress),
        ),
      );
    });

    group('isFormValid', () {
      test('returns correct value based on props', () {
        const state = CreatePassState();

        expect(state.copyWith(name: 'name').isFormValid, isFalse);
        expect(state.copyWith(title: 'title').isFormValid, isFalse);
        expect(state.copyWith(company: 'company').isFormValid, isFalse);

        expect(
          state.copyWith(name: 'name', title: 'title').isFormValid,
          isFalse,
        );
        expect(
          state.copyWith(name: 'name', company: 'company').isFormValid,
          isFalse,
        );
        expect(
          state.copyWith(title: 'title', company: 'company').isFormValid,
          isFalse,
        );

        expect(
          state
              .copyWith(name: 'name', title: 'title', company: 'company')
              .isFormValid,
          isTrue,
        );
      });
    });
  });
}
