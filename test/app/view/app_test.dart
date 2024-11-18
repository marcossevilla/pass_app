import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/home/passes.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:user_repository/user_repository.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _MockPassRepository extends Mock implements PassRepository {}

void main() {
  group('App', () {
    late UserRepository userRepository;
    late PassRepository passRepository;

    setUp(() {
      userRepository = _MockUserRepository();
      passRepository = _MockPassRepository();
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          userRepository: userRepository,
          passRepository: passRepository,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
