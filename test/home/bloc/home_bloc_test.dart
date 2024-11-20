import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_app/home/home.dart';
import 'package:pass_repository/pass_repository.dart';

class _MockPassRepository extends Mock implements PassRepository {}

class _FakePkPass extends Fake implements PkPass {}

void main() {
  group('HomeBloc', () {
    late PassRepository passRepository;
    late PkPass pass;

    setUp(() {
      passRepository = _MockPassRepository();
      pass = _FakePkPass();
    });

    group('HomePassesRequested', () {
      blocTest<HomeBloc, HomeState>(
        'emits [loading, success] when repository completes correctly',
        setUp: () {
          when(
            () => passRepository.getPassesForUser(userId: 'userId'),
          ).thenAnswer((_) async => [pass]);
        },
        build: () => HomeBloc(
          passRepository: passRepository,
        ),
        act: (bloc) => bloc.add(HomePassesRequested('userId')),
        expect: () => [
          HomeState(status: HomeStatus.loading),
          HomeState(status: HomeStatus.success, passes: [pass]),
        ],
      );

      blocTest<HomeBloc, HomeState>(
        'emits [loading, success] when repository completes correctly',
        setUp: () {
          when(
            () => passRepository.getPassesForUser(userId: 'userId'),
          ).thenThrow(Exception());
        },
        build: () => HomeBloc(
          passRepository: passRepository,
        ),
        act: (bloc) => bloc.add(HomePassesRequested('userId')),
        expect: () => [
          HomeState(status: HomeStatus.loading),
          HomeState(status: HomeStatus.failure),
        ],
      );
    });
  });
}
