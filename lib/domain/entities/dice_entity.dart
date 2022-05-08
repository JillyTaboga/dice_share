import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'dice_entity.g.dart';

@JsonSerializable()
class DiceEntity {
  final String guid;
  final String name;
  final List<DiceSideEntity> sides;

  DiceSideEntity get roll {
    return sides[Random().nextInt(sides.length)];
  }

  const DiceEntity({
    required this.guid,
    required this.name,
    required this.sides,
  });

  factory DiceEntity.fromSides(int sides) {
    return DiceEntity(
      guid: const Uuid().v4(),
      name: 'd${sides.toStringAsFixed(0)}',
      sides: List.generate(
        sides,
        (index) => DiceSideEntity.fromNumber(index + 1),
      ),
    );
  }

  factory DiceEntity.fromJson(Map<String, dynamic> json) =>
      _$DiceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DiceEntityToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiceEntity &&
        other.guid == guid &&
        other.name == name &&
        listEquals(other.sides, sides);
  }

  @override
  int get hashCode => guid.hashCode ^ name.hashCode ^ sides.hashCode;
}

@JsonSerializable()
class DiceSideEntity {
  final String label;
  final int value;
  const DiceSideEntity({
    required this.label,
    required this.value,
  });

  factory DiceSideEntity.fromNumber(int value) {
    return DiceSideEntity(
      label: value.toString(),
      value: value,
    );
  }

  factory DiceSideEntity.fromJson(Map<String, dynamic> json) =>
      _$DiceSideEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DiceSideEntityToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiceSideEntity &&
        other.label == label &&
        other.value == value;
  }

  @override
  int get hashCode => label.hashCode ^ value.hashCode;
}
