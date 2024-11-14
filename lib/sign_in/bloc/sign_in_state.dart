part of 'sign_in_bloc.dart';

class SignInState extends Equatable {
  const SignInState({
    this.username,
    this.password,
    this.user,
    this.status = FormzSubmissionStatus.initial,
  });

  final String? username;
  final String? password;
  final User? user;
  final FormzSubmissionStatus status;

  @override
  List<Object?> get props => [username, password, user, status];

  bool get isFormValid => username != null && password != null;

  SignInState copyWith({
    String? name,
    String? username,
    String? password,
    User? user,
    FormzSubmissionStatus? status,
  }) {
    return SignInState(
      username: username ?? this.username,
      password: password ?? this.password,
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
