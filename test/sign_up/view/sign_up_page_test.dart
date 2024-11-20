import 'package:api_models/api_models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/sign_up/sign_up.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class _FakeUser extends Fake implements User {}

void main() {
  group('SignUpPage', () {
    test(
      'is routable',
      () => expect(
        SignUpPage.route(),
        isRoute(whereName: equals(SignUpPage.routeName)),
      ),
    );

    testWidgets('renders SignUpView', (tester) async {
      await tester.pumpApp(
        Navigator(
          onGenerateRoute: (_) => SignUpPage.route(),
        ),
      );
      expect(find.byType(SignUpView), findsOneWidget);
    });
  });

  group('SignUpView', () {
    late AppBloc appBloc;
    late SignUpBloc signUpBloc;
    late User user;
    late Widget widgetToTest;

    setUp(() {
      appBloc = _MockAppBloc();
      signUpBloc = _MockSignUpBloc();
      user = _FakeUser();

      widgetToTest = BlocProvider.value(
        value: signUpBloc,
        child: SignUpView(),
      );
    });

    testWidgets(
      'adds AppSignUpCompleted to AppBloc when status is success',
      (tester) async {
        whenListen(
          signUpBloc,
          Stream.fromIterable([
            SignUpState(status: FormzSubmissionStatus.success, user: user),
          ]),
          initialState: SignUpState(),
        );

        await tester.pumpApp(
          widgetToTest,
          appBloc: appBloc,
        );

        verify(() => appBloc.add(AppSignUpCompleted(user)));
      },
    );

    testWidgets('renders dialog when status is failure', (tester) async {
      whenListen(
        signUpBloc,
        Stream.fromIterable([
          SignUpState(status: FormzSubmissionStatus.failure),
        ]),
        initialState: SignUpState(),
      );

      await tester.pumpApp(
        widgetToTest,
        appBloc: appBloc,
      );
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(
          CupertinoAlertDialog,
          tester.l10n.signUpPageFailureDialogTitle,
        ),
        findsOneWidget,
      );
    });
  });

  group('SignUpContent', () {
    late MockNavigator navigator;
    late SignUpBloc signUpBloc;
    late Widget widgetToTest;

    setUp(() {
      navigator = MockNavigator();
      signUpBloc = _MockSignUpBloc();

      when(navigator.canPop).thenReturn(true);
      when(() => navigator.push<void>(any())).thenAnswer((_) => Future.value());
      when(() => signUpBloc.state).thenReturn(SignUpState());

      widgetToTest = BlocProvider.value(
        value: signUpBloc,
        child: SignUpContent(),
      );
    });

    testWidgets(
      'adds SignUpUsernameChanged when username changes',
      (tester) async {
        await tester.pumpApp(widgetToTest);
        await tester.enterText(
          find.byType(CupertinoTextField).first,
          'username',
        );

        verify(() => signUpBloc.add(SignUpUsernameChanged('username')));
      },
    );

    testWidgets(
      'adds SignUpPasswordChanged when password changes',
      (tester) async {
        await tester.pumpApp(widgetToTest);
        await tester.enterText(
          find.byType(CupertinoTextField).last,
          'password',
        );

        verify(() => signUpBloc.add(SignUpPasswordChanged('password')));
      },
    );

    group('SubmitButton', () {
      testWidgets(
        'renders CupertinoActivityIndicator when status is in progress',
        (tester) async {
          when(() => signUpBloc.state).thenReturn(
            SignUpState(status: FormzSubmissionStatus.inProgress),
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
            tester.l10n.signUpPageSubmitButtonLabel,
          );

          expect(tester.widget<CupertinoButton>(finder).onPressed, isNull);
        },
      );

      testWidgets(
        'adds SignUpFormSubmitted when button is pressed',
        (tester) async {
          when(() => signUpBloc.state).thenReturn(
            SignUpState(username: 'username', password: 'password'),
          );

          await tester.pumpApp(widgetToTest);
          await tester.tap(
            find.widgetWithText(
              CupertinoButton,
              tester.l10n.signUpPageSubmitButtonLabel,
            ),
          );

          verify(() => signUpBloc.add(SignUpFormSubmitted())).called(1);
        },
      );
    });
  });
}
