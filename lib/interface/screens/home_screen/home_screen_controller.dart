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

  roll() {
    final newRoll = state.copyWith(
      guid: const Uuid().v4(),
      createdAt: DateTime.now(),
      diceRolls: state.diceRolls
          .map(
            (e) => DiceRollEntity.fromDice(e.dice),
          )
          .toList(),
    );

    state = newRoll;
  }

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

  addModifier() {
    state = state.copyWith(
      modifier: (state.modifier + 1),
    );
  }

  removeModifier() {
    state = state.copyWith(
      modifier: (state.modifier - 1),
    );
  }
}
