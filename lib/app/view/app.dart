import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/l10n/l10n.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({
    required UserRepository userRepository,
    required PassRepository passRepository,
    super.key,
  })  : _userRepository = userRepository,
        _passRepository = passRepository;

  final UserRepository _userRepository;
  final PassRepository _passRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _userRepository),
        RepositoryProvider.value(value: _passRepository),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  @visibleForTesting
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => FlowBuilder(
          state: state,
          onGeneratePages: onGenerateAppPages,
        ),
      ),
    );
  }
}
