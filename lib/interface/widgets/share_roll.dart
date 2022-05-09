import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:dice_share/interface/widgets/dice_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

const double _shareWidth = 320;

class LastRollCard extends StatelessWidget {
  const LastRollCard({
    Key? key,
    required this.roll,
  }) : super(key: key);

  final RollEntity roll;
  String get modifierSignal => roll.modifier >= 0 ? '+ ' : '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('dd/MM/yy HH:mm:ss').format(roll.createdAt),
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: roll.diceRolls
                      .map(
                        (e) => SizedBox.square(
                          dimension: 22,
                          child: DiceContainer(
                            sides: sidesToPolygon[e.dice.sides.length] ?? 4,
                            color: diceColor(e.dice),
                            child: Center(
                              child: Text(
                                e.value.toString(),
                                style: const TextStyle(fontSize: 9),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )),
              Text(modifierSignal + roll.modifier.toString()),
              const Text(' = '),
              Text(roll.total.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class SharedRoll extends StatelessWidget {
  const SharedRoll({
    Key? key,
    required this.roll,
    this.looked = false,
  }) : super(key: key);

  final RollEntity roll;
  String get modifierSignal => roll.modifier >= 0 ? '+ ' : '';
  final bool looked;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: _shareWidth,
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
            if (looked)
              const Text(
                'Essa rolagem foi vista antes de ser compartilhada.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                ),
              ),
            const Text('Últimas rolagens:'),
            if (roll.lastRolls.isEmpty) ...[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Esse usuário não realizou nenhuma rolagem ainda',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              QrCodeRoll(qrCodeRollData: roll.qrInfo()),
            ],
            if (roll.lastRolls.isNotEmpty)
              Row(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: roll.lastRolls
                          .map(
                            (e) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 0.5,
                                ),
                              ),
                              child: LastRollCard(
                                roll: e,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: QrCodeRoll(
                      qrCodeRollData: roll.qrInfo(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class QrCodeRoll extends StatelessWidget {
  const QrCodeRoll({
    Key? key,
    required this.qrCodeRollData,
  }) : super(key: key);

  final String qrCodeRollData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: 120,
      child: Center(
        child: QrImage(
          data: qrCodeRollData,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
