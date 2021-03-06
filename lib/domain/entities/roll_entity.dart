import 'package:dice_share/domain/entities/dice_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'dice_roll.dart';

part 'roll_entity.g.dart';

@JsonSerializable()
class RollEntity {
  final String guid;
  final DateTime createdAt;
  final List<DiceRollEntity> diceRolls;
  final int modifier;
  final List<RollEntity> lastRolls;
  RollEntity({
    required this.guid,
    required this.createdAt,
    required this.diceRolls,
    required this.modifier,
    required this.lastRolls,
  });

  factory RollEntity.fromDices({
    required List<DiceEntity> dices,
    required List<RollEntity> lastRolls,
    int modifier = 0,
  }) {
    final diceRolls = dices.map((e) => DiceRollEntity.fromDice(e)).toList();
    return RollEntity(
      guid: const Uuid().v4(),
      createdAt: DateTime.now(),
      diceRolls: diceRolls,
      modifier: modifier,
      lastRolls: lastRolls,
    );
  }

  int get total {
    return diceRolls.fold<int>(0, (total, roll) => total + roll.value) +
        modifier;
  }

  factory RollEntity.fromJson(Map<String, dynamic> json) =>
      _$RollEntityFromJson(json);
  Map<String, dynamic> toJson() => _$RollEntityToJson(this);

  RollEntity copyWith({
    String? guid,
    DateTime? createdAt,
    List<DiceRollEntity>? diceRolls,
    int? modifier,
    List<RollEntity>? lastRolls,
  }) {
    return RollEntity(
      guid: guid ?? this.guid,
      createdAt: createdAt ?? this.createdAt,
      diceRolls: diceRolls ?? this.diceRolls,
      modifier: modifier ?? this.modifier,
      lastRolls: lastRolls ?? this.lastRolls,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RollEntity &&
        other.guid == guid &&
        other.createdAt == createdAt &&
        other.modifier == modifier;
  }

  @override
  int get hashCode {
    return guid.hashCode ^
        createdAt.hashCode ^
        diceRolls.hashCode ^
        modifier.hashCode ^
        lastRolls.hashCode;
  }
}
