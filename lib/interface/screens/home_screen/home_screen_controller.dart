import 'dart:io';

import 'package:dice_share/domain/entities/dice_entity.dart';
import 'package:dice_share/domain/entities/dice_roll.dart';
import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:dice_share/domain/use_cases/get_rolls_use_case.dart';
import 'package:dice_share/domain/use_cases/save_roll_use_case.dart';
import 'package:dice_share/interface/widgets/share_roll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

final shareLoadingProvider = StateProvider<bool>((ref) => false);

final rollProvider = StateNotifierProvider<RollNotifier, RollEntity>((ref) {
  final lastRolls = ref.watch(lastsRollsProvider);
  return RollNotifier(
    lastRolls: lastRolls,
  );
});

class RollNotifier extends StateNotifier<RollEntity> {
  RollNotifier({
    required this.lastRolls,
  }) : super(
          RollEntity(
            guid: const Uuid().v4(),
            diceRolls: [],
            createdAt: DateTime.now(),
            modifier: 0,
            lastRolls:
                lastRolls.getRange(0, lastRolls.length.clamp(0, 3)).toList(),
          ),
        );

  final List<RollEntity> lastRolls;

  clear() {
    state = RollEntity(
      guid: const Uuid().v4(),
      diceRolls: [],
      createdAt: DateTime.now(),
      modifier: 0,
      lastRolls: lastRolls.getRange(0, lastRolls.length.clamp(0, 3)).toList(),
    );
  }

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

final lastsRollsProvider =
    StateNotifierProvider<LastRollsNotifier, List<RollEntity>>((ref) {
  final getRollsUseCaseLocal = ref.watch(getRollsUseCase);
  final saveRollUseCase = ref.watch(saveRollLocalUseCase);
  return LastRollsNotifier(
    getRollsUseCaseLocal,
    saveRollUseCase,
    ref,
  );
});

class LastRollsNotifier extends StateNotifier<List<RollEntity>> {
  LastRollsNotifier(
    GetRollsUseCase getRollsUseCase,
    SaveRollLocalUserCase saveRollLocalUserCase,
    Ref ref,
  )   : _getRollsUseCase = getRollsUseCase,
        _saveRollLocalUserCase = saveRollLocalUserCase,
        _ref = ref,
        super([]) {
    getRolls();
  }

  _setLoading() {
    _ref.read(homeLoadigProvider.notifier).state = true;
  }

  _setLoaded() {
    _ref.read(homeLoadigProvider.notifier).state = false;
  }

  final GetRollsUseCase _getRollsUseCase;
  final SaveRollLocalUserCase _saveRollLocalUserCase;
  final Ref _ref;

  getRolls() async {
    _setLoading();
    state = await _getRollsUseCase();
    _setLoaded();
  }

  saveRoll(
    RollEntity currentRoll, {
    required BuildContext context,
  }) async {
    _setLoading();
    await _saveRollLocalUserCase.call(currentRoll);
    await shareRoll(
      currentRoll,
      context: context,
    );
    await getRolls();
  }

  shareRoll(
    RollEntity roll, {
    bool looked = false,
    required BuildContext context,
  }) async {
    final screenCotroller = ScreenshotController();
    _setLoading();
    showDialog(
        context: context,
        builder: (context) {
          try {
            return Dialog(
              child: Screenshot(
                controller: screenCotroller,
                child: SharedRoll(
                  roll: roll,
                  looked: looked,
                ),
              ),
            );
          } catch (e) {
            return Dialog(
              child: Text(e.toString()),
            );
          }
        });
    _ref.read(shareLoadingProvider.notifier).state = true;
    final directory = (await getApplicationDocumentsDirectory()).path;
    final imageData = await screenCotroller.captureAndSave(
      directory,
      fileName: 'diceshare.png',
      delay: const Duration(seconds: 1),
    );
    if (imageData != null) {
      await Share.shareFilesWithResult(
        [imageData],
      );
      final file = File(imageData);
      await file.delete();
    }
    _ref.read(shareLoadingProvider.notifier).state = false;
    _setLoaded();
  }
}

final homeLoadigProvider = StateProvider<bool>((ref) => false);
