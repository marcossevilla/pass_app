import 'package:api_models/api_models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/sign_in/sign_in.dart';
import 'package:pass_app/sign_up/sign_up.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}

class _FakeUser extends Fake implements User {}

void main() {
  group('SignInPage', () {
    test(
      'page returns a CupertinoPage',
      () => expect(SignInPage.page(), isA<CupertinoPage<void>>()),
    );

    testWidgets('renders SignInView', (tester) async {
      await tester.pumpApp(SignInPage());
      expect(find.byType(SignInView), findsOneWidget);
    });
  });

  group('SignInView', () {
    late AppBloc appBloc;
    late SignInBloc signInBloc;
    late User user;
    late Widget widgetToTest;

    setUp(() {
      appBloc = _MockAppBloc();
      signInBloc = _MockSignInBloc();
      user = _FakeUser();

      widgetToTest = BlocProvider.value(
        value: signInBloc,
        child: SignInView(),
      );
    });

    testWidgets(
      'adds AppUserSignedIn to AppBloc when status is success',
      (tester) async {
        whenListen(
          signInBloc,
          Stream.fromIterable([
            SignInState(status: FormzSubmissionStatus.success, user: user),
          ]),
          initialState: SignInState(),
        );

        await tester.pumpApp(
          widgetToTest,
          appBloc: appBloc,
        );

        verify(() => appBloc.add(AppUserSignedIn(user)));
      },
    );

    testWidgets('renders dialog when status is failure', (tester) async {
      whenListen(
        signInBloc,
        Stream.fromIterable([
          SignInState(status: FormzSubmissionStatus.failure),
        ]),
        initialState: SignInState(),
      );

      await tester.pumpApp(
        widgetToTest,
        appBloc: appBloc,
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(
          CupertinoAlertDialog,
          tester.l10n.signInPageFailureDialogTitle,
        ),
        findsOneWidget,
      );
    });
  });

  group('SignInContent', () {
    late MockNavigator navigator;
    late SignInBloc signInBloc;
    late Widget widgetToTest;

    setUp(() {
      navigator = MockNavigator();
      signInBloc = _MockSignInBloc();

      when(navigator.canPop).thenReturn(true);
      when(() => navigator.push<void>(any())).thenAnswer((_) => Future.value());
      when(() => signInBloc.state).thenReturn(SignInState());

      widgetToTest = BlocProvider.value(
        value: signInBloc,
        child: SignInContent(),
      );
    });

    testWidgets(
      'adds SignInUsernameChanged when username changes',
      (tester) async {
        await tester.pumpApp(widgetToTest);
        await tester.enterText(
          find.byType(CupertinoTextField).first,
          'username',
        );

        verify(() => signInBloc.add(SignInUsernameChanged('username')));
      },
    );

    testWidgets(
      'adds SignInPasswordChanged when password changes',
      (tester) async {
        await tester.pumpApp(widgetToTest);
        await tester.enterText(
          find.byType(CupertinoTextField).last,
          'password',
        );

        verify(() => signInBloc.add(SignInPasswordChanged('password')));
      },
    );

    testWidgets(
      'navigates to SignUpPage when SignUpButton is pressed',
      (tester) async {
        await tester.pumpApp(
          widgetToTest,
          navigator: navigator,
        );
        await tester.tap(
          find.widgetWithText(
            CupertinoButton,
            tester.l10n.signInPageCreateAccountButtonLabel,
          ),
        );

        verify(
          () => navigator.push<void>(
            any(
              that: isRoute<void>(
                whereName: equals(SignUpPage.routeName),
              ),
            ),
          ),
        ).called(1);
      },
    );

    group('SubmitButton', () {
      testWidgets(
        'renders CupertinoActivityIndicator when status is in progress',
        (tester) async {
          when(() => signInBloc.state).thenReturn(
            SignInState(status: FormzSubmissionStatus.inProgress),
          );

          await tester.pumpApp(widgetToTest);

          expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'renders disabled button when form is invalid',
        (tester) async {
          await tester.pumpApp(widgetToTest);

          final finder = find.widgetWithText(
            CupertinoButton,
            tester.l10n.signInPageSubmitButtonLabel,
          );

          expect(tester.widget<CupertinoButton>(finder).onPressed, isNull);
        },
      );

      testWidgets(
        'adds SignInFormSubmitted when button is pressed',
        (tester) async {
          when(() => signInBloc.state).thenReturn(
            SignInState(username: 'username', password: 'password'),
          );

          await tester.pumpApp(widgetToTest);
          await tester.tap(
            find.widgetWithText(
              CupertinoButton,
              tester.l10n.signInPageSubmitButtonLabel,
            ),
          );

          verify(() => signInBloc.add(SignInFormSubmitted())).called(1);
        },
      );
    });
  });
}
