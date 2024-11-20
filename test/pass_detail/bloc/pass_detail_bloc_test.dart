import 'dart:typed_data';

import 'package:apple_passkit/apple_passkit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_app/pass_detail/pass_detail.dart';
import 'package:passkit/passkit.dart';

class _MockApplePassKit extends Mock implements ApplePassKit {}

class _FakePkPass extends Fake implements PkPass {
  @override
  Uint8List? get sourceData => Uint8List.fromList([1, 2, 3]);
}

void main() {
  group('PassDetailBloc', () {
    setUpAll(() {
      registerFallbackValue(Uint8List.fromList([1, 2, 3]));
    });

    late ApplePassKit passKit;
    late PkPass pass;

    setUp(() {
      passKit = _MockApplePassKit();
      pass = _FakePkPass();
    });

    test(
      'can instantiate',
      () => expect(PassDetailBloc(pass: pass), isA<PassDetailBloc>()),
    );

    group('PassDetailPassAdded', () {
      blocTest<PassDetailBloc, PassDetailState>(
        'emits added status when conditions are met',
        setUp: () {
          when(passKit.isPassLibraryAvailable).thenAnswer(
            (_) => Future.value(true),
          );
          when(passKit.canAddPasses).thenAnswer((_) => Future.value(true));
          when(() => passKit.addPass(any())).thenAnswer((_) => Future.value());
        },
        build: () => PassDetailBloc(pass: pass, passKit: passKit),
        act: (bloc) => bloc.add(PassDetailPassAdded(pass)),
        expect: () => [
          PassDetailState(
            pass: pass,
            status: PassDetailStatus.added,
          ),
        ],
        verify: (_) {
          verify(passKit.isPassLibraryAvailable).called(1);
          verify(passKit.canAddPasses).called(1);
          verify(() => passKit.addPass(pass.sourceData!)).called(1);
        },
      );

      blocTest<PassDetailBloc, PassDetailState>(
        'does not call addPass when passkit conditions are not met',
        setUp: () {
          when(passKit.isPassLibraryAvailable).thenAnswer(
            (_) => Future.value(false),
          );
          when(passKit.canAddPasses).thenAnswer((_) => Future.value(false));
        },
        build: () => PassDetailBloc(pass: pass, passKit: passKit),
        act: (bloc) => bloc.add(PassDetailPassAdded(pass)),
        expect: () => const <PassDetailState>[],
        verify: (_) {
          verify(passKit.isPassLibraryAvailable).called(1);
          verify(passKit.canAddPasses).called(1);
          verifyNever(() => passKit.addPass(any()));
        },
      );

      blocTest<PassDetailBloc, PassDetailState>(
        'emits failure status when addPass throws',
        setUp: () {
          when(passKit.isPassLibraryAvailable).thenAnswer(
            (_) => Future.value(true),
          );
          when(passKit.canAddPasses).thenAnswer((_) => Future.value(true));
          when(() => passKit.addPass(any())).thenThrow(Exception());
        },
        build: () => PassDetailBloc(pass: pass, passKit: passKit),
        act: (bloc) => bloc.add(PassDetailPassAdded(pass)),
        expect: () => [
          PassDetailState(
            pass: pass,
            status: PassDetailStatus.failure,
          ),
        ],
        verify: (_) {
          verify(passKit.isPassLibraryAvailable).called(1);
          verify(passKit.canAddPasses).called(1);
          verify(() => passKit.addPass(pass.sourceData!)).called(1);
        },
      );
    });
  });
}
