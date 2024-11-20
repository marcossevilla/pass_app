import 'package:api_models/api_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_app/app/app.dart';

class _FakeUser extends Fake implements User {}

void main() {
  group('AppEvent', () {
    late User user;

    setUp(() {
      user = _FakeUser();
    });

    group('AppLogoutRequested', () {
      test('supports value equality', () {
        expect(AppLogoutRequested(), AppLogoutRequested());
      });
    });

    group('AppSignUpCompleted', () {
      test('supports value equality', () {
        expect(AppSignUpCompleted(user), AppSignUpCompleted(user));
      });
    });

    group('AppUserSignedIn', () {
      test('supports value equality', () {
        expect(AppUserSignedIn(user), AppUserSignedIn(user));
      });
    });
  });
}
