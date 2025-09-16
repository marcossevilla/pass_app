import 'package:api_client/api_client.dart';
import 'package:pass_app/app/app.dart';
import 'package:pass_app/bootstrap.dart';
import 'package:pass_repository/pass_repository.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  await bootstrap(() {
    final apiClient = ApiClient(host: 'localhost:8080');
    final userRepository = UserRepository(apiClient: apiClient);
    final passRepository = PassRepository(apiClient: apiClient);

    return App(
      userRepository: userRepository,
      passRepository: passRepository,
    );
  });
}
