import 'package:db_client/db_client.dart';
import 'package:hive_ce/hive.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// An enum representing the boxes in the database.
enum DataBox {
  /// The users box.
  users,

  /// The passes box.
  passes,
}

/// {@template db_client}
/// A client to interact with the database.
/// {@endtemplate}
class DbClient {
  /// {@macro db_client}
  DbClient({
    required Box<DbEntityRecord> usersBox,
    required Box<DbEntityRecord> passesBox,
    Uuid uuid = const Uuid(),
  })  : _uuid = uuid,
        _usersBox = usersBox,
        _passesBox = passesBox;

  final Uuid _uuid;
  final Box<DbEntityRecord> _usersBox;
  final Box<DbEntityRecord> _passesBox;

  /// Internal method to resolve which box to interact with.
  @internal
  Box<DbEntityRecord> resolveBox(DataBox box) {
    return switch (box) {
      DataBox.users => _usersBox,
      DataBox.passes => _passesBox,
    };
  }

  /// Adds a new entry to the given [dataBox], returning the generated id.
  Future<String> add(
    DataBox dataBox, {
    required Map<String, dynamic> data,
  }) async {
    try {
      final id = _uuid.v4().replaceAll('-', '');
      final box = resolveBox(dataBox);
      await box.put(id, DbEntityRecord(id: id, data: data));
      return id;
    } catch (error, stackTrace) {
      throw Exception('Error adding entry: $error\n$stackTrace');
    }
  }

  /// Returns the entry with the given [id] from the given [dataBox].
  DbEntityRecord get(DataBox dataBox, {required String id}) {
    try {
      final box = resolveBox(dataBox);
      final data = box.get(id);

      if (data == null) throw Exception('Entry not found');

      return data;
    } catch (error, stackTrace) {
      throw Exception('Error getting entry: $error\n$stackTrace');
    }
  }

  /// Returns the entry with the given [fields] from the given [dataBox].
  List<DbEntityRecord> getBy(
    DataBox dataBox, {
    required Map<String, dynamic> fields,
  }) {
    try {
      final box = resolveBox(dataBox);
      final entries = box.values.where(
        (value) => fields.entries.every(
          (field) => value.data[field.key] == field.value,
        ),
      );
      return entries.toList();
    } catch (error, stackTrace) {
      throw Exception('Error getting entry: $error\n$stackTrace');
    }
  }

  /// Updates the entry with the given [record] in the given [dataBox].
  Future<void> update(
    DataBox dataBox, {
    required DbEntityRecord record,
  }) async {
    try {
      final box = resolveBox(dataBox);
      await box.put(record.id, record);
    } catch (error, stackTrace) {
      throw Exception('Error updating entry: $error\n$stackTrace');
    }
  }
}
