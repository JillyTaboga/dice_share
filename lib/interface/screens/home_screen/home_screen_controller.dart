import 'package:dice_share/domain/entities/dice_entity.dart';
import 'package:dice_share/domain/entities/dice_roll.dart';
import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final rollProvider =
    StateNotifierProvider<RollNotifier, RollEntity>((ref) => RollNotifier());

class RollNotifier extends StateNotifier<RollEntity> {
  RollNotifier()
      : super(
          RollEntity(
            guid: const Uuid().v4(),
            diceRolls: [],
            createdAt: DateTime.now(),
            modifier: 0,
            lastRolls: [],
          ),
        );

  addDice(DiceEntity dice) {
    state = state.copyWith(
      diceRolls: state.diceRolls
        ..add(
          DiceRollEntity.fromDice(dice),
        ),
    );
  }

  removeDice(int index) {
    var oldRolls = [...state.diceRolls];
    oldRolls.removeAt(index);
    state = state.copyWith(
      diceRolls: oldRolls,
    );
  }

  addModifier(int modifier) {
    state = state.copyWith(
      modifier: state.modifier + 1,
    );
  }

  removeModifier() {
    state = state.copyWith(
      modifier: state.modifier - 1,
    );
  }
}
