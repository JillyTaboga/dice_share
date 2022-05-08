import 'package:dice_share/data/data_bases/dices_types.dart';
import 'package:dice_share/interface/screens/home_screen/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dicesInRoll =
        ref.watch(rollProvider).diceRolls.map((e) => e.dice).toList();
    return Scaffold(
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
                            (e) => Container(
                              clipBehavior: Clip.antiAlias,
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => ref
                                      .read(rollProvider.notifier)
                                      .removeDice(dicesInRoll.indexOf(e)),
                                  child: SizedBox.expand(
                                    child: Center(
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
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
          Expanded(
            flex: 1,
            child: Container(
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
                            (e) => Container(
                              clipBehavior: Clip.antiAlias,
                              alignment: Alignment.center,
                              height: constraints.maxHeight / 3,
                              width: constraints.maxHeight / 3,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: SizedBox.expand(
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(rollProvider.notifier)
                                          .addDice(e);
                                    },
                                    child: Center(
                                      child: Text(
                                        e.name,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
