import 'package:hive_ce/hive.dart';
import 'package:db_client/src/models/db_entity_record.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    registerAdapter(DbEntityRecordAdapter());
  }
}
