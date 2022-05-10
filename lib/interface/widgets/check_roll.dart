import 'package:dice_share/domain/entities/roll_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

final barcodeProvider = StateProvider.autoDispose<String?>((ref) => null);

final checkRollProvider = StateProvider.autoDispose<RollCheckEntity?>((ref) {
  final code = ref.watch(barcodeProvider);
  if (code == null) {
    return null;
  } else {
    try {
      return RollCheckEntity.fromQr(code);
    } catch (e) {
      return null;
    }
  }
});

class CheckRollWidget extends ConsumerWidget {
  const CheckRollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final check = ref.watch(checkRollProvider);
    final hasCheck = check != null;
    return Card(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        child: hasCheck
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Rolagem em ${DateFormat('dd/MM/yy HH:mm:ss').format(check.createdAt)}'),
                  Text(
                      'Dados: ${check.rollsValues.map((e) => e.toString()).join(' + ')}'),
                  Text('Modificador: ${check.modifier}'),
                  Text('Total: ${check.total}'),
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(
                width: 200,
                height: 200,
                child: MobileScanner(
                  onDetect: ((barcode, args) {
                    ref.read(barcodeProvider.notifier).state = barcode.rawValue;
                  }),
                ),
              ),
      ),
    );
  }
}
