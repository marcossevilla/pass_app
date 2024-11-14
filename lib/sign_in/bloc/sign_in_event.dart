part of 'sign_in_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

final class SignInUsernameChanged extends SignInEvent {
  const SignInUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

final class SignInPasswordChanged extends SignInEvent {
  const SignInPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class SignInFormSubmitted extends SignInEvent {
  const SignInFormSubmitted();
}
