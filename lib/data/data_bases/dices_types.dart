import 'package:dice_share/domain/entities/dice_entity.dart';
import 'package:uuid/uuid.dart';

final List<DiceEntity> dices = [
  DiceEntity.fromSides(4),
  DiceEntity.fromSides(6),
  DiceEntity.fromSides(10),
  DiceEntity.fromSides(12),
  DiceEntity.fromSides(20),
  DiceEntity.fromSides(100),
  DiceEntity(
    guid: const Uuid().v4(),
    name: 'Fudge',
    sides: [
      const DiceSideEntity(label: '', value: 0),
      const DiceSideEntity(label: '-', value: -1),
      const DiceSideEntity(label: '+', value: 1),
    ],
  ),
];
