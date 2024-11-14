part of 'home_bloc.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.passes = const [],
    this.status = HomeStatus.initial,
  });

  final List<PkPass> passes;
  final HomeStatus status;

  @override
  List<Object?> get props => [passes, status];

  HomeState copyWith({
    List<PkPass>? passes,
    HomeStatus? status,
  }) {
    return HomeState(
      passes: passes ?? this.passes,
      status: status ?? this.status,
    );
  }
}
