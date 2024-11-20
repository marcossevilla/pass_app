part of 'pass_detail_bloc.dart';

enum PassDetailStatus { initial, added, failure }

class PassDetailState extends Equatable {
  const PassDetailState({
    required this.pass,
    this.status = PassDetailStatus.initial,
  });

  final PkPass pass;
  final PassDetailStatus status;

  @override
  List<Object> get props => [pass, status];

  PassDetailState copyWith({
    PkPass? pass,
    PassDetailStatus? status,
  }) {
    return PassDetailState(
      pass: pass ?? this.pass,
      status: status ?? this.status,
    );
  }
}
