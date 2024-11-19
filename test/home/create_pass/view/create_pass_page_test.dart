// ignore_for_file: prefer_const_constructors

import 'package:api_models/api_models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';

import '../../../helpers/helpers.dart';

class _MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class _MockCreatePassBloc extends MockBloc<CreatePassEvent, CreatePassState>
    implements CreatePassBloc {}

class _FakeUser extends Fake implements User {
  @override
  String get id => 'id';
}

void main() {
  group('CreatePassPage', () {
    late AppBloc appBloc;
    late CreatePassBloc createPassBloc;
    late Widget widgetToTest;

    setUp(() {
      appBloc = _MockAppBloc();
      createPassBloc = _MockCreatePassBloc();

      when(() => appBloc.state).thenReturn(AppUnauthenticated());
      when(() => createPassBloc.state).thenReturn(CreatePassState());

      widgetToTest = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appBloc),
          BlocProvider.value(value: createPassBloc),
        ],
        child: CreatePassPage(),
      );
    });

    testWidgets(
      'adds PassNameChanged when editing name field',
      (tester) async {
        await tester.pumpApp(widgetToTest);
        await tester.enterText(
          find.widgetWithText(CupertinoTextField, 'Your name'),
          'name',
        );

        verify(() => createPassBloc.add(PassNameChanged('name'))).called(1);
      },
    );

    testWidgets(
      'adds PassTitleChanged when editing name field',
      (tester) async {
        await tester.pumpApp(widgetToTest);
        await tester.enterText(
          find.widgetWithText(CupertinoTextField, 'Your job title'),
          'title',
        );

        verify(() => createPassBloc.add(PassTitleChanged('title'))).called(1);
      },
    );

    testWidgets(
      'adds PassCompanyChanged when editing name field',
      (tester) async {
        await tester.pumpApp(widgetToTest);
        await tester.enterText(
          find.widgetWithText(CupertinoTextField, 'Your company'),
          'company',
        );

        verify(
          () => createPassBloc.add(PassCompanyChanged('company')),
        ).called(1);
      },
    );

    group('SubmitButton', () {
      testWidgets(
        'renders activity indicator when create pass status is in progress',
        (tester) async {
          when(() => createPassBloc.state).thenReturn(
            CreatePassState(status: FormzSubmissionStatus.inProgress),
          );

          await tester.pumpApp(widgetToTest);

          expect(find.byType(CupertinoActivityIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'renders disabled button when user id is null',
        (tester) async {
          await tester.pumpApp(widgetToTest);

          expect(
            tester
                .widget<CupertinoButton>(find.byType(CupertinoButton))
                .onPressed,
            isNull,
          );
        },
      );

      testWidgets(
        'adds PassRequested when tapped and user id is not null',
        (tester) async {
          when(() => appBloc.state).thenReturn(AppAuthenticated(_FakeUser()));
          when(() => createPassBloc.state).thenReturn(
            CreatePassState(
              name: 'name',
              title: 'title',
              company: 'company',
            ),
          );

          await tester.pumpApp(widgetToTest);
          await tester.tap(find.byType(CupertinoButton));

          verify(
            () => createPassBloc.add(PassRequested(userId: 'id')),
          ).called(1);
        },
      );
    });
  });
}
