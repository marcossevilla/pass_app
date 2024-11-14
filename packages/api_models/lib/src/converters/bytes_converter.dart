import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

/// {@template bytes_converter}
/// Converts to and from [Uint8List] and [List]<[int]>.
/// {@endtemplate}
class BytesConverter implements JsonConverter<Uint8List, List<int>> {
  /// {@macro bytes_converter}
  const BytesConverter();

  @override
  Uint8List fromJson(List<int> json) => Uint8List.fromList(json);

  @override
  List<int> toJson(Uint8List object) => object.toList();
}
