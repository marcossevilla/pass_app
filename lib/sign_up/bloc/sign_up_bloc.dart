import 'package:api_models/api_models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const SignUpState()) {
    on<SignUpUsernameChanged>(_onUsernameChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpFormSubmitted>(_onFormSubmitted);
  }

  final UserRepository _userRepository;

  void _onUsernameChanged(
    SignUpUsernameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        username: event.username,
      ),
    );
  }

  void _onPasswordChanged(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
      ),
    );
  }

  Future<void> _onFormSubmitted(
    SignUpFormSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(
      state.copyWith(
        status: FormzSubmissionStatus.inProgress,
      ),
    );

    try {
      final user = await _userRepository.signUp(
        username: state.username!,
        password: state.password!,
      );

      emit(
        state.copyWith(
          user: user,
          status: FormzSubmissionStatus.success,
        ),
      );
    } catch (error) {
      addError(error);
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
    }
  }
}
