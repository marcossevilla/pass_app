import 'package:api_client/api_client.dart';

/// {@template pass_repository}
/// A repository to manage passes domain.
/// {@endtemplate}
class PassRepository {
  /// {@macro pass_repository}
  const PassRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Creates a new pass.
  Future<PkPass> create({
    required String userId,
    required PassData passData,
  }) async {
    try {
      final passId = await _apiClient.createPass(
        userId: userId,
        passData: passData,
      );
      final createdPass = await _apiClient.getPassById(id: passId);
      return createdPass;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets all passes given a [userId].
  Future<List<PkPass>> getPassesForUser({required String userId}) async {
    try {
      final passes = await _apiClient.getPassesForUser(userId: userId);
      return passes;
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a single pass.
  Future<PkPass> get(String id) async {
    try {
      final pass = await _apiClient.getPassById(id: id);
      return pass;
    } catch (e) {
      rethrow;
    }
  }
}
