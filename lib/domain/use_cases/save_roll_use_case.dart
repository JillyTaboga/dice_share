import 'package:dice_share/data/data_sources/abstracts/rolls_data_source.dart';
import 'package:dice_share/data/data_sources/implemented/rolls_hive_ds.dart';
import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final saveRollLocalUseCase = Provider<SaveRollLocalUserCase>((ref) {
  final rollsDataSource = ref.watch(localRollsDS);
  return SaveRollLocalUserCase(rollsDataSource: rollsDataSource);
});

class SaveRollLocalUserCase {
  final RollsDataSource _rollsDataSource;
  SaveRollLocalUserCase({
    required RollsDataSource rollsDataSource,
  }) : _rollsDataSource = rollsDataSource;

  Future<void> call(RollEntity roll) async {
    await _rollsDataSource.saveRoll(roll);
  }
}
