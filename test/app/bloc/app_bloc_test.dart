import 'package:api_models/api_models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/app/bloc/app_bloc.dart';

class _FakeUser extends Fake implements User {}

void main() {
  group('AppBloc', () {
    late User user;

    setUp(() {
      user = _FakeUser();
    });

    blocTest<AppBloc, AppState>(
      'emits [AppAuthenticated] when AppUserSignedIn is added',
      build: AppBloc.new,
      act: (bloc) => bloc.add(AppUserSignedIn(user)),
      expect: () => [AppAuthenticated(user)],
    );

    blocTest<AppBloc, AppState>(
      'emits [AppAuthenticated] when AppSignUpCompleted is added',
      build: AppBloc.new,
      act: (bloc) => bloc.add(AppSignUpCompleted(user)),
      expect: () => [AppAuthenticated(user)],
    );

    blocTest<AppBloc, AppState>(
      'emits [AppUnauthenticated] when AppLogoutRequested is added',
      build: AppBloc.new,
      act: (bloc) => bloc.add(AppLogoutRequested()),
      expect: () => [AppUnauthenticated()],
    );
  });
}
