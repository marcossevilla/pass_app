import 'dart:io';
import 'dart:typed_data';

import 'package:api_models/api_models.dart';
import 'package:db_client/db_client.dart';
import 'package:passkit/passkit.dart';
import 'package:uuid/uuid.dart';

/// {@template pass_data_source}
/// A data source for managing [PkPass] objects.
/// {@endtemplate}
class PassDataSource {
  /// {@macro pass_data_source}
  PassDataSource({
    required DbClient dbClient,
    Uuid uuid = const Uuid(),
  })  : _uuid = uuid,
        _dbClient = dbClient;

  final Uuid _uuid;

  final DbClient _dbClient;

  /// Signs a new [PkPass] object given an unsigned pass, returning the pass
  /// file in bytes.
  Future<Uint8List> sign(
    PkPass unsignedPass, {
    required File passCertificate,
    required File privateKey,
  }) async {
    try {
      final unsignedPassWithSerial = unsignedPass.copyWith(
        pass: unsignedPass.pass.copyWith(
          serialNumber: '${unsignedPass.pass.serialNumber}_${_uuid.v4()}',
        ),
      );

      final binaryData = unsignedPassWithSerial.write(
        privateKeyPem: privateKey.readAsStringSync(),
        certificatePem: passCertificate.readAsStringSync(),
      );

      if (binaryData == null) {
        throw Exception('Failed to create pass');
      }

      return binaryData;
    } catch (e) {
      throw Exception('Error signing pass: $e');
    }
  }

  /// Creates a new [UserPass] object in the database, returning the pass ID.
  Future<String> create({
    required String userId,
    required Uint8List bytes,
  }) async {
    try {
      final id = await _dbClient.add(
        DataBox.passes,
        data: UserPass(userId: userId, bytes: bytes).toJson(),
      );
      return id;
    } catch (error) {
      throw Exception('Error adding pass to database: $error');
    }
  }

  /// Reads a single [PkPass] object.
  Future<Uint8List> read(String id) async {
    try {
      final record = _dbClient.get(DataBox.passes, id: id);
      final pass = UserPass.fromJson(record.data);
      return pass.bytes;
    } catch (error) {
      throw Exception('Error reading pass: $error');
    }
  }

  /// Reads a single [PkPass] object by give
  Future<List<Uint8List>> readByUserId(String userId) async {
    try {
      final records = _dbClient.getBy(
        DataBox.passes,
        fields: {'userId': userId},
      );

      if (records.isEmpty) return [];

      final passes = records
          .map((record) => UserPass.fromJson(record.data).bytes)
          .toList();

      return passes;
    } catch (error) {
      throw Exception('Error reading pass: $error');
    }
  }
}
