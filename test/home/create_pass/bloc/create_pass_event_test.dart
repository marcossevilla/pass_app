import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/home/create_pass/create_pass.dart';

void main() {
  group('CreatePassEvent', () {
    group('PassNameChanged', () {
      test('supports value comparisons', () {
        expect(PassNameChanged('name'), equals(PassNameChanged('name')));
      });
    });

    group('PassTitleChanged', () {
      test('supports value comparisons', () {
        expect(PassTitleChanged('title'), equals(PassTitleChanged('title')));
      });
    });

    group('PassCompanyChanged', () {
      test('supports value comparisons', () {
        expect(
          PassCompanyChanged('company'),
          equals(PassCompanyChanged('company')),
        );
      });
    });

    group('PassRequested', () {
      test('supports value comparisons', () {
        expect(
          PassRequested(userId: 'userId'),
          equals(PassRequested(userId: 'userId')),
        );
      });
    });
  });
}
