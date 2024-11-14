// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_pass.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPass _$UserPassFromJson(Map<String, dynamic> json) => UserPass(
      userId: json['userId'] as String,
      bytes: const BytesConverter().fromJson(json['bytes'] as List<int>),
    );

Map<String, dynamic> _$UserPassToJson(UserPass instance) => <String, dynamic>{
      'userId': instance.userId,
      'bytes': const BytesConverter().toJson(instance.bytes),
    };
