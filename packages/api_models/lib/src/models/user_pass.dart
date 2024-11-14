import 'dart:typed_data';

import 'package:api_models/api_models.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_pass.g.dart';

/// {@template user_pass}
/// A pass associated with a user.
/// {@endtemplate}
@JsonSerializable()
class UserPass extends Equatable {
  /// {@macro user_pass}
  const UserPass({
    required this.userId,
    required this.bytes,
  });

  /// Converts a [Map<String, dynamic>] to a [UserPass].
  factory UserPass.fromJson(Map<String, dynamic> json) =>
      _$UserPassFromJson(json);

  /// Converts a [UserPass] to a [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$UserPassToJson(this);

  /// The user id associated with the pass.
  final String userId;

  /// The pass file in bytes.
  @BytesConverter()
  final Uint8List bytes;

  @override
  List<Object> get props => [userId, bytes];
}
