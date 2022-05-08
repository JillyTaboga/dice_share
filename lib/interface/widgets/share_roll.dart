import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:dice_share/interface/widgets/dice_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SharedRoll extends StatelessWidget {
  const SharedRoll({
    Key? key,
    required this.roll,
  }) : super(key: key);

  final RollEntity roll;
  String get modifierSignal => roll.modifier >= 0 ? '+ ' : '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Rolagem em ${DateFormat('dd/MM/yy HH:mm:ss').format(roll.createdAt)}'),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: roll.diceRolls.map(
                    (e) {
                      const size = 250 / 5;
                      return SizedBox.square(
                        dimension: size,
                        child: DiceResulWidget(
                          diceRoll: e,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Modificador:'),
                  Text(
                    '$modifierSignal${roll.modifier.toString()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Text(' = '),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Total:'),
                  Text(
                    roll.total.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
