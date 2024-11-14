import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// {@template user}
/// A user.
/// {@endtemplate}
@JsonSerializable()
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    required this.username,
    required this.password,
  });

  /// Converts a [Map<String, dynamic>] to a [User].
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts a [User] to a [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// The user's identifier.
  final String id;

  /// The user's username.
  final String username;

  /// The user's password, in a hashed form.
  final String password;

  @override
  List<Object?> get props => [id, username, password];
}
