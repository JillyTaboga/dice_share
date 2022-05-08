import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:flutter/material.dart';

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
      height: 120,
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Wrap(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$modifierSignal${roll.modifier.toString()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              ' = ${roll.total.toString()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
