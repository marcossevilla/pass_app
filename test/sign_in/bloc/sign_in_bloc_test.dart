import 'package:api_models/api_models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_app/sign_in/sign_in.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('SignInBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();
    });

    group('SignInUsernameChanged', () {
      blocTest<SignInBloc, SignInState>(
        'emits [SignInState] with new username',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInUsernameChanged('username')),
        expect: () => [SignInState(username: 'username')],
      );
    });

    group('SignInPasswordChanged', () {
      blocTest<SignInBloc, SignInState>(
        'emits [SignInState] with new password',
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInPasswordChanged('password')),
        expect: () => [SignInState(password: 'password')],
      );
    });

    group('SignInFormSubmitted', () {
      late SignInState initialState;
      late User user;

      setUp(() {
        initialState = SignInState(
          username: 'username',
          password: 'password',
        );

        user = User(
          id: 'id',
          username: 'username',
          password: 'password',
        );
      });

      blocTest<SignInBloc, SignInState>(
        'emits [inProgress, success] when repository returns user',
        setUp: () {
          when(
            () => userRepository.signIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) => Future.value(user));
        },
        seed: () => initialState,
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInFormSubmitted()),
        expect: () => [
          initialState.copyWith(status: FormzSubmissionStatus.inProgress),
          initialState.copyWith(
            user: user,
            status: FormzSubmissionStatus.success,
          ),
        ],
      );

      blocTest<SignInBloc, SignInState>(
        'emits [inProgress, submissionFailure] when repository throws',
        setUp: () {
          when(
            () => userRepository.signIn(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenThrow(Exception('oops'));
        },
        seed: () => initialState,
        build: () => SignInBloc(userRepository: userRepository),
        act: (bloc) => bloc.add(SignInFormSubmitted()),
        expect: () => [
          initialState.copyWith(status: FormzSubmissionStatus.inProgress),
          initialState.copyWith(status: FormzSubmissionStatus.failure),
        ],
        verify: (_) {
          verify(
            () => userRepository.signIn(
              username: initialState.username!,
              password: initialState.password!,
            ),
          ).called(1);
        },
      );
    });
  });
}
