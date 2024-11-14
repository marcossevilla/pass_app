part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class HomePassesRequested extends HomeEvent {
  const HomePassesRequested(this.userId);

  final String userId;

  @override
  List<Object> get props => [userId];
}
