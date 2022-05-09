import 'package:dice_share/domain/entities/roll_entity.dart';

abstract class RollsDataSource {
  Future<List<RollEntity>> getRolls();
  Future saveRoll(RollEntity roll);
}
