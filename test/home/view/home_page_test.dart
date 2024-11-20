import 'package:api_models/api_models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';
import 'package:pass_app/home/home.dart';
import 'package:pass_app/pass_detail/pass_detail.dart';
import 'package:passkit/passkit.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockHomeBloc extends MockBloc<HomeEvent, HomeState>
    implements HomeBloc {}

class _MockCreatePassBloc extends MockBloc<CreatePassEvent, CreatePassState>
    implements CreatePassBloc {}

class _FakeUser extends Fake implements User {
  @override
  String get id => 'fake-id';
}

class _FakePkPass extends Fake implements PkPass {
  @override
  PassData get pass => _FakePassData();
}

class _FakePassData extends Fake implements PassData {
  @override
  PassStructure? get eventTicket => _FakePassStructure();
}

class _FakePassStructure extends Fake implements PassStructure {
  @override
  List<FieldDict>? get auxiliaryFields {
    return [FieldDict(value: 1, key: '1'), FieldDict(value: 2, key: '2')];
  }
}

void main() {
  group('HomePage', () {
    late AppBloc appBloc;
    late Widget widgetToTest;

    setUp(() {
      appBloc = _MockAppBloc();

      when(() => appBloc.state).thenReturn(AppAuthenticated(_FakeUser()));

      widgetToTest = HomePage();
    });

    test(
      'page returns a CupertinoPage',
      () => expect(HomePage.page(), isA<CupertinoPage<void>>()),
    );

    testWidgets('renders HomeView', (tester) async {
      await tester.pumpApp(
        widgetToTest,
        appBloc: appBloc,
      );
      expect(find.byType(HomeView), findsOneWidget);
    });
  });

  group('HomeView', () {
    late AppBloc appBloc;
    late HomeBloc homeBloc;
    late CreatePassBloc createPassBloc;
    late Widget widgetToTest;

    setUp(() {
      appBloc = _MockAppBloc();
      homeBloc = _MockHomeBloc();
      createPassBloc = _MockCreatePassBloc();

      when(() => appBloc.state).thenReturn(AppAuthenticated(_FakeUser()));
      when(() => homeBloc.state).thenReturn(HomeState());
      when(() => createPassBloc.state).thenReturn(CreatePassState());

      widgetToTest = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: homeBloc),
          BlocProvider.value(value: createPassBloc),
        ],
        child: HomeView(),
      );
    });

    testWidgets('renders HomeContent', (tester) async {
      await tester.pumpApp(
        widgetToTest,
        appBloc: appBloc,
      );
      expect(find.byType(HomeContent), findsOneWidget);
    });

    testWidgets(
      'adds HomePassesRequested when pass changes and is not null',
      (tester) async {
        whenListen(
          createPassBloc,
          Stream.fromIterable([CreatePassState(pass: _FakePkPass())]),
        );

        await tester.pumpApp(
          widgetToTest,
          appBloc: appBloc,
        );

        verify(() => homeBloc.add(HomePassesRequested('fake-id'))).called(1);
      },
    );
  });

  group('HomeContent', () {
    late AppBloc appBloc;
    late HomeBloc homeBloc;
    late CreatePassBloc createPassBloc;
    late MockNavigator navigator;
    late Widget widgetToTest;

    setUp(() {
      appBloc = _MockAppBloc();
      homeBloc = _MockHomeBloc();
      createPassBloc = _MockCreatePassBloc();
      navigator = MockNavigator();

      when(() => appBloc.state).thenReturn(AppAuthenticated(_FakeUser()));
      when(() => homeBloc.state).thenReturn(HomeState());
      when(() => createPassBloc.state).thenReturn(CreatePassState());
      when(navigator.canPop).thenReturn(true);
      when(() => navigator.push<void>(any())).thenAnswer((_) => Future.value());

      widgetToTest = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: homeBloc),
          BlocProvider.value(value: createPassBloc),
        ],
        child: HomeContent(),
      );
    });

    testWidgets(
      'renders CreatePassSheet when tapping on add button',
      (tester) async {
        await tester.pumpApp(
          widgetToTest,
          appBloc: appBloc,
          navigator: navigator,
        );
        await tester.tap(find.byIcon(CupertinoIcons.add));

        verify(
          () => navigator.push<void>(
            any(
              that: isRoute<void>(
                whereName: equals(CreatePassSheet.routeName),
              ),
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'renders generic error text when status is failure',
      (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(
            status: HomeStatus.failure,
          ),
        );

        await tester.pumpApp(
          widgetToTest,
          appBloc: appBloc,
        );

        expect(find.text(tester.l10n.genericFailureText), findsOneWidget);
      },
    );

    group('PassList', () {
      testWidgets('renders no passes message', (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(
            passes: [],
            status: HomeStatus.success,
          ),
        );

        await tester.pumpApp(
          widgetToTest,
          appBloc: appBloc,
        );

        expect(find.text('You do not have passes yet...'), findsOneWidget);
        expect(find.byType(CupertinoListTile), findsNothing);
      });

      testWidgets('renders correct amount of tiles', (tester) async {
        when(() => homeBloc.state).thenReturn(
          HomeState(
            passes: [_FakePkPass(), _FakePkPass()],
            status: HomeStatus.success,
          ),
        );

        await tester.pumpApp(
          widgetToTest,
          appBloc: appBloc,
        );

        expect(
          find.byType(CupertinoListTile),
          findsNWidgets(homeBloc.state.passes.length),
        );
      });

      testWidgets(
        'navigates to PassDetailPage when tapping a tile',
        (tester) async {
          when(() => homeBloc.state).thenReturn(
            HomeState(
              passes: [_FakePkPass(), _FakePkPass()],
              status: HomeStatus.success,
            ),
          );

          await tester.pumpApp(
            widgetToTest,
            appBloc: appBloc,
            navigator: navigator,
          );
          await tester.tap(find.byType(CupertinoListTile).first);

          verify(
            () => navigator.push<void>(
              any(
                that: isRoute<void>(
                  whereName: equals(PassDetailPage.routeName),
                ),
              ),
            ),
          ).called(1);
        },
      );
    });
  });
}
