import 'package:api_models/api_models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
       super(const SignInState()) {
    on<SignInUsernameChanged>(_onUsernameChanged);
    on<SignInPasswordChanged>(_onPasswordChanged);
    on<SignInFormSubmitted>(_onFormSubmitted);
  }

  final UserRepository _userRepository;

  void _onUsernameChanged(
    SignInUsernameChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(
      state.copyWith(
        username: event.username,
      ),
    );
  }

  void _onPasswordChanged(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
      ),
    );
  }

  Future<void> _onFormSubmitted(
    SignInFormSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      final user = await _userRepository.signIn(
        username: state.username!,
        password: state.password!,
      );

      emit(
        state.copyWith(
          user: user,
          status: FormzSubmissionStatus.success,
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
