import 'package:dice_share/domain/entities/dice_entity.dart';
import 'package:dice_share/domain/entities/dice_roll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon_clipper/flutter_polygon_clipper.dart';

class DiceResulWidget extends StatelessWidget {
  const DiceResulWidget({
    Key? key,
    required this.diceRoll,
  }) : super(key: key);

  final DiceRollEntity diceRoll;

  @override
  Widget build(BuildContext context) {
    return DiceContainer(
      color: _diceColor(diceRoll.dice),
      sides: _sidesToPolygon[diceRoll.dice.sides.length] ?? 4,
      child: Center(
        child: Text(
          diceRoll.rolledSide.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class DiceWidget extends StatelessWidget {
  const DiceWidget({
    Key? key,
    required this.dice,
    this.onTap,
  }) : super(key: key);

  final DiceEntity dice;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return DiceContainer(
      sides: _sidesToPolygon[dice.sides.length] ?? 4,
      color: _diceColor(dice),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: SizedBox.expand(
            child: Center(
              child: Text(
                dice.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DiceContainer extends StatelessWidget {
  const DiceContainer({
    Key? key,
    required this.sides,
    required this.color,
    required this.child,
  }) : super(key: key);

  final int sides;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FlutterClipPolygon(
      sides: sides,
      borderRadius: 8,
      boxShadows: [
        PolygonBoxShadow(
          elevation: 3,
          color: Colors.black,
        ),
      ],
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            stops: const [0.05, 0.9, 1],
            radius: 1.2,
            colors: [
              Colors.white,
              color,
              Colors.grey.shade400,
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}

Color _diceColor(DiceEntity dice) {
  switch (dice.name) {
    case 'd4':
      return Colors.green;
    case 'd6':
      return Colors.blue;
    case 'd8':
      return Colors.purple;
    case 'd10':
      return Colors.pinkAccent;
    case 'd12':
      return Colors.red;
    case 'd20':
      return Colors.orange;
    case 'Fudge':
      return Colors.deepPurple;
    default:
      return Colors.grey;
  }
}

const Map<int, int> _sidesToPolygon = {
  4: 3,
  6: 4,
  8: 5,
  10: 6,
  12: 8,
  20: 6,
  100: 12,
};
