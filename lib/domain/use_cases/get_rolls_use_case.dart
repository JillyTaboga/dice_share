import 'package:dice_share/data/data_sources/abstracts/rolls_data_source.dart';
import 'package:dice_share/data/data_sources/implemented/rolls_hive_ds.dart';
import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getRollsUseCase = Provider<GetRollsUseCase>((ref) {
  final rollsDataSource = ref.watch(localRollsDS);
  return GetRollsUseCase(dataSource: rollsDataSource);
});

class GetRollsUseCase {
  final RollsDataSource _dataSource;
  GetRollsUseCase({
    required RollsDataSource dataSource,
  }) : _dataSource = dataSource;

  Future<List<RollEntity>> call() async {
    return await _dataSource.getRolls();
  }
}
