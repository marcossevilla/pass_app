import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/l10n/l10n.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockPassRepository extends Mock implements PassRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    AppBloc? appBloc,
    UserRepository? userRepository,
    PassRepository? passRepository,
    MockNavigator? navigator,
  }) async {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(
            value: userRepository ?? MockUserRepository(),
          ),
          RepositoryProvider.value(
            value: passRepository ?? MockPassRepository(),
          ),
        ],
        child: BlocProvider.value(
          value: appBloc ?? MockAppBloc(),
          child: CupertinoApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: navigator == null
                ? widget
                : MockNavigatorProvider(navigator: navigator, child: widget),
          ),
        ),
      ),
    );
  }
}
