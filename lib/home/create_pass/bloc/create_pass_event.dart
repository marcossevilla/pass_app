part of 'create_pass_bloc.dart';

sealed class CreatePassEvent extends Equatable {
  const CreatePassEvent();
}

final class PassNameChanged extends CreatePassEvent {
  const PassNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

final class PassTitleChanged extends CreatePassEvent {
  const PassTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

final class PassCompanyChanged extends CreatePassEvent {
  const PassCompanyChanged(this.company);

  final String company;

  @override
  List<Object> get props => [company];
}

final class PassRequested extends CreatePassEvent {
  const PassRequested({required this.userId});

  final String userId;

  @override
  List<Object> get props => [userId];
}
