import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/home/bloc/home_bloc.dart';

void main() {
  group('HomeState', () {
    group('copyWith', () {
      test(
        'returns same object when no arguments are passed',
        () => expect(HomeState().copyWith(), HomeState()),
      );

      test(
        'returns object with updated status when status is passed',
        () => expect(
          HomeState().copyWith(status: HomeStatus.loading),
          HomeState(status: HomeStatus.loading),
        ),
      );
    });
  });
}
