// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceEntity _$DiceEntityFromJson(Map<String, dynamic> json) => DiceEntity(
      guid: json['guid'] as String,
      name: json['name'] as String,
      sides: (json['sides'] as List<dynamic>)
          .map((e) => DiceSideEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DiceEntityToJson(DiceEntity instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'name': instance.name,
      'sides': instance.sides,
    };

DiceSideEntity _$DiceSideEntityFromJson(Map<String, dynamic> json) =>
    DiceSideEntity(
      label: json['label'] as String,
      value: json['value'] as int,
    );

Map<String, dynamic> _$DiceSideEntityToJson(DiceSideEntity instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
    };
