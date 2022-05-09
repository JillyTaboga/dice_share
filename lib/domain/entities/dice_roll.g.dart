// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice_roll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiceRollEntity _$DiceRollEntityFromJson(Map<String, dynamic> json) =>
    DiceRollEntity(
      guid: json['guid'] as String,
      dice: DiceEntity.fromJson(json['dice'] as Map<String, dynamic>),
      rolledSide:
          DiceSideEntity.fromJson(json['rolledSide'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DiceRollEntityToJson(DiceRollEntity instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'dice': instance.dice.toJson(),
      'rolledSide': instance.rolledSide.toJson(),
    };
