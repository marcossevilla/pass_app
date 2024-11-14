part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
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

  SignUpState copyWith({
    String? username,
    String? password,
    User? user,
    FormzSubmissionStatus? status,
  }) {
    return SignUpState(
      username: username ?? this.username,
      password: password ?? this.password,
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
