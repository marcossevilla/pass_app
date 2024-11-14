import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';

part 'db_entity_record.g.dart';

/// {@template db_entity_record}
/// A model representing a record in an entity.
/// {@endtemplate}
@HiveType(typeId: 0)
class DbEntityRecord extends HiveObject with EquatableMixin {
  /// {@macro db_entity_record}
  DbEntityRecord({
    required this.id,
    this.data = const {},
  });

  /// The record identifier.
  @HiveField(0)
  final String id;

  /// The record data.
  @HiveField(1)
  final Map<String, dynamic> data;

  @override
  List<Object> get props => [id, data];
}
