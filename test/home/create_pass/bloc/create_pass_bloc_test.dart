// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:passkit/passkit.dart';

class _MockPassRepository extends Mock implements PassRepository {}

class _FakePkPass extends Fake implements PkPass {}

class _FakePassData extends Fake implements PassData {}

void main() {
  group('CreatePassBloc', () {
    setUpAll(() {
      registerFallbackValue(_FakePassData());
    });

    late PassRepository passRepository;

    setUp(() {
      passRepository = _MockPassRepository();
    });

    group('PassNameChanged', () {
      blocTest<CreatePassBloc, CreatePassState>(
        'emits [CreatePassState] with name when added',
        build: () => CreatePassBloc(
          passRepository: passRepository,
        ),
        act: (bloc) => bloc.add(PassNameChanged('name')),
        expect: () => [CreatePassState(name: 'name')],
      );
    });

    group('PassTitleChanged', () {
      blocTest<CreatePassBloc, CreatePassState>(
        'emits [CreatePassState] with title when added',
        build: () => CreatePassBloc(
          passRepository: passRepository,
        ),
        act: (bloc) => bloc.add(PassTitleChanged('title')),
        expect: () => [CreatePassState(title: 'title')],
      );
    });

    group('PassCompanyChanged', () {
      blocTest<CreatePassBloc, CreatePassState>(
        'emits [CreatePassState] with company when added',
        build: () => CreatePassBloc(
          passRepository: passRepository,
        ),
        act: (bloc) => bloc.add(PassCompanyChanged('company')),
        expect: () => [CreatePassState(company: 'company')],
      );
    });

    group('PassRequested', () {
      blocTest<CreatePassBloc, CreatePassState>(
        'emits [inProgress, success] when repository returns pass',
        setUp: () {
          when(
            () => passRepository.create(
              userId: any(named: 'userId'),
              passData: any(named: 'passData'),
            ),
          ).thenAnswer((_) => Future.value(_FakePkPass()));
        },
        build: () => CreatePassBloc(
          passRepository: passRepository,
        ),
        act: (bloc) => bloc.add(PassRequested(userId: 'userId')),
        expect: () => [
          CreatePassState(status: FormzSubmissionStatus.inProgress),
          isA<CreatePassState>()
              .having(
                (state) => state.status,
                'status',
                equals(FormzSubmissionStatus.success),
              )
              .having(
                (state) => state.pass,
                'pass',
                isA<PkPass>(),
              ),
        ],
      );
    });

    blocTest<CreatePassBloc, CreatePassState>(
      'emits [inProgress, failure] when repository fails',
      setUp: () {
        when(
          () => passRepository.create(
            userId: any(named: 'userId'),
            passData: any(named: 'passData'),
          ),
        ).thenThrow(Exception());
      },
      build: () => CreatePassBloc(
        passRepository: passRepository,
      ),
      act: (bloc) => bloc.add(PassRequested(userId: 'userId')),
      expect: () => [
        CreatePassState(status: FormzSubmissionStatus.inProgress),
        CreatePassState(status: FormzSubmissionStatus.failure),
      ],
    );
  });
}
