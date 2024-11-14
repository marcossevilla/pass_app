import 'package:api_client/api_client.dart';
import 'package:api_models/api_models.dart';

/// {@template user_repository}
/// A repository to manage the user domain.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Signs up a new user.
  Future<User> signUp({
    required String username,
    required String password,
  }) async {
    try {
      final userId = await _apiClient.createUser(
        username: username,
        password: password,
      );
      final user = await _apiClient.findUserBy(id: userId);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  /// Signs in a user.
  Future<User> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final user = await _apiClient.signIn(
        username: username,
        password: password,
      );
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
