import 'package:dice_share/domain/entities/dice_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'dice_roll.g.dart';

@JsonSerializable()
class DiceRollEntity {
  final String guid;
  final DiceEntity dice;
  final DiceSideEntity rolledSide;

  const DiceRollEntity({
    required this.guid,
    required this.dice,
    required this.rolledSide,
  });

  factory DiceRollEntity.fromDice(DiceEntity dice) {
    return DiceRollEntity(
      guid: const Uuid().v4(),
      dice: dice,
      rolledSide: dice.roll,
    );
  }

  int get value => rolledSide.value;

  factory DiceRollEntity.fromJson(Map<String, dynamic> json) =>
      _$DiceRollEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DiceRollEntityToJson(this);
}
