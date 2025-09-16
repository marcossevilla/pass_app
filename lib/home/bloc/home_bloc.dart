import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:passkit/passkit.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required PassRepository passRepository,
  }) : _passRepository = passRepository,
       super(const HomeState()) {
    on<HomePassesRequested>(_onPassesRequested);
  }

  final PassRepository _passRepository;

  Future<void> _onPassesRequested(
    HomePassesRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(status: HomeStatus.loading),
    );

    try {
      final passes = await _passRepository.getPassesForUser(
        userId: event.userId,
      );

      emit(
        state.copyWith(
          passes: passes,
          status: HomeStatus.success,
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(status: HomeStatus.failure),
      );
    }
  }
}
