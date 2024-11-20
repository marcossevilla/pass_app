import 'package:api_models/api_models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_app/sign_up/sign_up.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('SignUpBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();
    });

    group('SignUpUsernameChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits [SignUpState] with new username',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpUsernameChanged('username')),
        expect: () => [SignUpState(username: 'username')],
      );
    });

    group('SignUpPasswordChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits [SignUpState] with new password',
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpPasswordChanged('password')),
        expect: () => [SignUpState(password: 'password')],
      );
    });

    group('SignUpFormSubmitted', () {
      late SignUpState initialState;
      late User user;

      setUp(() {
        initialState = SignUpState(
          username: 'username',
          password: 'password',
        );

        user = User(
          id: 'id',
          username: 'username',
          password: 'password',
        );
      });

      blocTest<SignUpBloc, SignUpState>(
        'emits [inProgress, success] when repository returns user',
        setUp: () {
          when(
            () => userRepository.signUp(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) => Future.value(user));
        },
        seed: () => initialState,
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpFormSubmitted()),
        expect: () => [
          initialState.copyWith(status: FormzSubmissionStatus.inProgress),
          initialState.copyWith(
            user: user,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [inProgress, submissionFailure] when repository throws',
        setUp: () {
          when(
            () => userRepository.signUp(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        seed: () => initialState,
        build: () => SignUpBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignUpFormSubmitted()),
        expect: () => [
          initialState.copyWith(status: FormzSubmissionStatus.inProgress),
          initialState.copyWith(status: FormzSubmissionStatus.failure),
        ],
        verify: (_) {
          verify(
            () => userRepository.signUp(
              username: initialState.username!,
              password: initialState.password!,
            ),
          ).called(1);
        },
      );
    });
  });
}
