import 'dart:io';

import 'package:dice_share/domain/entities/dice_entity.dart';
import 'package:dice_share/domain/entities/dice_roll.dart';
import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:dice_share/domain/use_cases/get_rolls_use_case.dart';
import 'package:dice_share/domain/use_cases/save_roll_use_case.dart';
import 'package:dice_share/interface/widgets/share_roll.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

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
            lastRolls: lastRolls,
          ),
        );

  final List<RollEntity> lastRolls;

  clear() {
    state = RollEntity(
      guid: const Uuid().v4(),
      diceRolls: [],
      createdAt: DateTime.now(),
      modifier: 0,
      lastRolls: [],
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
  final _getRollsUseCase = ref.watch(getRollsUseCase);
  final _saveRollUseCase = ref.watch(saveRollLocalUseCase);
  return LastRollsNotifier(
    _getRollsUseCase,
    _saveRollUseCase,
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

  saveRoll(RollEntity currentRoll) async {
    _setLoading();
    await _saveRollLocalUserCase.call(currentRoll);
    await shareRoll(currentRoll);
    await getRolls();
  }

  shareRoll(
    RollEntity roll, {
    bool looked = false,
  }) async {
    final screenCotroller = ScreenshotController();
    _setLoading();
    final imageData = await screenCotroller.captureFromWidget(
      SharedRoll(
        roll: roll,
        looked: looked,
      ),
    );
    final directory = (await getApplicationDocumentsDirectory()).path;
    final file = File('$directory/${roll.guid}.png');
    await file.writeAsBytes(imageData);
    await Share.shareFilesWithResult(
      [file.path],
    );
    _setLoaded();
  }
}

final homeLoadigProvider = StateProvider<bool>((ref) => false);
