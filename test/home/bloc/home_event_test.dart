import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/home/home.dart';

void main() {
  group('HomeEvent', () {
    group('HomePassesRequested', () {
      test('support value comparisons', () {
        expect(
          HomePassesRequested('userId'),
          HomePassesRequested('userId'),
        );
      });
    });
  });
}
