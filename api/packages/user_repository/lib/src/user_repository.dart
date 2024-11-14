import 'dart:convert';

import 'package:api_models/api_models.dart';
import 'package:crypto/crypto.dart';
import 'package:db_client/db_client.dart';

/// {@template user_repository}
/// Repository which manages users.
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  UserRepository({required DbClient dbClient}) : _dbClient = dbClient;

  static const _box = DataBox.users;

  final DbClient _dbClient;

  String _hashValue(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  /// Checks in the database for a user with the given [username] and
  /// [password].
  ///
  /// The received password should be in plain text, and will be hashed, so it
  /// can be compared to the stored password hash.
  Future<User?> userFromCredentials(String username, String password) async {
    try {
      final hashedPassword = _hashValue(password);
      final records = _dbClient.getBy(
        _box,
        fields: {
          'username': username,
          'password': hashedPassword,
        },
      );
      final users = records.map((record) => User.fromJson(record.data));
      return users.firstOrNull;
    } catch (_) {
      return null;
    }
  }

  /// Returns the user with the given [id].
  Future<User?> userFromId(String id) async {
    try {
      final user = _dbClient.get(_box, id: id);
      return User.fromJson(user.data);
    } catch (_) {
      return null;
    }
  }

  /// Creates a new user with the given [username] and [password]
  /// (in raw format).
  Future<String> createUser({
    required String username,
    required String password,
  }) async {
    try {
      final user = {
        'username': username,
        'password': _hashValue(password),
      };

      final id = await _dbClient.add(_box, data: user);

      await _dbClient.update(
        _box,
        record: DbEntityRecord(
          id: id,
          data: user..addEntries([MapEntry('id', id)]),
        ),
      );

      return id;
    } catch (error) {
      throw Exception('Error creating user: $error');
    }
  }
}
