import 'package:dice_share/data/data_bases/dices_types.dart';
import 'package:dice_share/interface/screens/home_screen/home_screen_controller.dart';
import 'package:dice_share/interface/widgets/dice_widget.dart';
import 'package:dice_share/interface/widgets/share_roll.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dicesInRoll =
        ref.watch(rollProvider).diceRolls.map((e) => e.dice).toList();
    final loading = ref.watch(homeLoadigProvider);
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
          const LastRolls(),
          if (loading)
            const LinearProgressIndicator(
              minHeight: 5,
            ),
          if (!loading)
            const SizedBox(
              height: 5,
              width: double.infinity,
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
    final hasRoll = ref.watch(rollProvider).diceRolls.isNotEmpty;
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
                  onPressed: hasRoll
                      ? () {
                          ref.read(rollProvider.notifier).roll();
                          final roll = ref.read(rollProvider);
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: SharedRoll(
                                roll: roll,
                              ),
                            ),
                          );
                          // ref.read(lastsRollsProvider.notifier).saveRoll(roll);
                          // ref.read(rollProvider.notifier).clear();
                        }
                      : null,
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

final _scrollController =
    Provider.autoDispose<ScrollController>((ref) => ScrollController());

class LastRolls extends ConsumerWidget {
  const LastRolls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastRolls = ref.watch(lastsRollsProvider);
    final scrollController = ref.watch(_scrollController);
    return lastRolls.isEmpty
        ? const SizedBox(
            height: 60,
          )
        : Listener(
            onPointerSignal: (signal) {
              if (signal is PointerScrollEvent) {
                if (signal.scrollDelta.dy > 0) {
                  scrollController.animateTo(
                    scrollController.offset + signal.scrollDelta.dy,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                  );
                } else {
                  scrollController.animateTo(
                    scrollController.offset + signal.scrollDelta.dy,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            child: SizedBox(
              height: 60,
              width: double.maxFinite,
              child: ListView.builder(
                reverse: true,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: lastRolls.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final roll = lastRolls[index];
                  return SizedBox(
                    width: 200,
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          ref.read(lastsRollsProvider.notifier).shareRoll(
                                roll,
                                looked: true,
                              );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LastRollCard(
                            roll: roll,
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
        color: Colors.grey.shade200,
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
