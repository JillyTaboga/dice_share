// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roll_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RollCheckEntity _$RollCheckEntityFromJson(Map<String, dynamic> json) =>
    RollCheckEntity(
      guid: json['guid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      rollsValues:
          (json['rollsValues'] as List<dynamic>).map((e) => e as int).toList(),
      modifier: json['modifier'] as int,
    );

Map<String, dynamic> _$RollCheckEntityToJson(RollCheckEntity instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'createdAt': instance.createdAt.toIso8601String(),
      'rollsValues': instance.rollsValues,
      'modifier': instance.modifier,
    };
