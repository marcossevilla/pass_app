part of 'pass_detail_bloc.dart';

sealed class PassDetailEvent extends Equatable {
  const PassDetailEvent();
}

final class PassDetailPassAdded extends PassDetailEvent {
  const PassDetailPassAdded(this.pass);

  final PkPass pass;

  @override
  List<Object> get props => [pass];
}
