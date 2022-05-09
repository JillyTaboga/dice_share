import 'dart:convert';

import 'package:dice_share/data/data_sources/abstracts/rolls_data_source.dart';
import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final localRollsDS = Provider<RollsDataSource>((ref) => RollsHiveDS());

class RollsHiveDS extends RollsDataSource {
  Future<Box> get openBox async {
    return await Hive.openBox('rolls');
  }

  @override
  Future<List<RollEntity>> getRolls() async {
    final rollsBox = await openBox;
    final listToCast = (rollsBox.values.toList());
    final list = listToCast.map((e) => jsonDecode(e)).toList();
    List<RollEntity> rolls = [];
    if (list.isNotEmpty) {
      final lastFive = list
          .getRange((list.length - 6).clamp(0, list.length), list.length)
          .toList();
      rolls = lastFive.map((e) => RollEntity.fromJson(e)).toList();
      rolls.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return rolls;
  }

  @override
  Future<void> saveRoll(RollEntity roll) async {
    final rollsBox = await openBox;
    final value = roll.toJson();
    rollsBox.add(jsonEncode(value));
  }
}
