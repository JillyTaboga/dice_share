import 'package:dice_share/data/data_bases/dices_types.dart';
import 'package:dice_share/interface/screens/home_screen/home_screen_controller.dart';
import 'package:dice_share/interface/widgets/dice_widget.dart';
import 'package:dice_share/interface/widgets/share_roll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dicesInRoll =
        ref.watch(rollProvider).diceRolls.map((e) => e.dice).toList();
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: dicesInRoll
                          .map(
                            (e) => SizedBox(
                              width: 80,
                              child: DiceWidget(
                                dice: e,
                                onTap: () {
                                  ref.read(rollProvider.notifier).removeDice(
                                        dicesInRoll.indexOf(e),
                                      );
                                },
                              ),
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              ),
            ),
          ),
          const ActionBar(),
          const Expanded(
            flex: 1,
            child: DiceTray(),
          ),
        ],
      ),
    );
  }
}

class ActionBar extends ConsumerWidget {
  const ActionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final currentModifier = ref.watch(rollProvider).modifier;
    return Container(
      height: 60,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kElevationToShadow[3],
        border: const Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            constraints: const BoxConstraints(maxWidth: 600),
            width: double.maxFinite,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(rollProvider.notifier).removeModifier();
                  },
                  icon: const Icon(
                    Icons.remove,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Text(
                    currentModifier.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ref.read(rollProvider.notifier).addModifier();
                  },
                  icon: const Icon(
                    Icons.add,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    final roll = ref.read(rollProvider);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: SharedRoll(
                              roll: roll,
                            ),
                          );
                        });
                  },
                  label: const Text('Compartilhar'),
                  icon: const Icon(Icons.share),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiceTray extends ConsumerWidget {
  const DiceTray({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: kElevationToShadow[3],
        border: const Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.5,
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: dices
                  .map(
                    (e) => SizedBox(
                      height: constraints.maxHeight / 3,
                      width: constraints.maxHeight / 3,
                      child: DiceWidget(
                        dice: e,
                        onTap: () {
                          ref.read(rollProvider.notifier).addDice(e);
                        },
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
