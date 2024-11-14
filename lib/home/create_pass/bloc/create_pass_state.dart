part of 'create_pass_bloc.dart';

class CreatePassState extends Equatable {
  const CreatePassState({
    this.pass,
    this.name,
    this.title,
    this.company,
    this.status = FormzSubmissionStatus.initial,
  });

  final PkPass? pass;
  final String? name;
  final String? title;
  final String? company;
  final FormzSubmissionStatus status;

  @override
  List<Object?> get props => [pass, name, title, company, status];

  CreatePassState copyWith({
    PkPass? pass,
    String? name,
    String? title,
    String? company,
    FormzSubmissionStatus? status,
  }) {
    return CreatePassState(
      pass: pass ?? this.pass,
      name: name ?? this.name,
      title: title ?? this.title,
      company: company ?? this.company,
      status: status ?? this.status,
    );
  }

  bool get isFormValid => name != null && title != null && company != null;
}
