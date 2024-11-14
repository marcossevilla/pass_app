import 'package:api_models/api_models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppUnauthenticated()) {
    on<AppUserSignedIn>(_onUserSignedIn);
    on<AppSignUpCompleted>(_onSignUpComplete);
    on<AppLogoutRequested>(_onLogoutRequested);
  }

  void _onUserSignedIn(AppUserSignedIn event, Emitter<AppState> emit) {
    emit(AppAuthenticated(event.user));
  }

  void _onSignUpComplete(AppSignUpCompleted event, Emitter<AppState> emit) {
    emit(AppAuthenticated(event.user));
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    emit(AppUnauthenticated());
  }
}
