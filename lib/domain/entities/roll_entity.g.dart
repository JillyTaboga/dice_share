// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roll_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RollEntity _$RollEntityFromJson(Map<String, dynamic> json) => RollEntity(
      guid: json['guid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      diceRolls: (json['diceRolls'] as List<dynamic>)
          .map((e) => DiceRollEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifier: json['modifier'] as int,
      lastRolls: (json['lastRolls'] as List<dynamic>)
          .map((e) => RollEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RollEntityToJson(RollEntity instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'createdAt': instance.createdAt.toIso8601String(),
      'diceRolls': instance.diceRolls.map((e) => e.toJson()).toList(),
      'modifier': instance.modifier,
      'lastRolls': instance.lastRolls.map((e) => e.toJson()).toList(),
    };
