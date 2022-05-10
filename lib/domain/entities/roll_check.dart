import 'dart:convert';

import 'package:dice_share/domain/entities/roll_entity.dart';
import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roll_check.g.dart';

@JsonSerializable()
class RollCheckEntity {
  final String guid;
  final DateTime createdAt;
  final List<int> rollsValues;
  final int modifier;
  RollCheckEntity({
    required this.guid,
    required this.createdAt,
    required this.rollsValues,
    required this.modifier,
  });

  int get total {
    return rollsValues.fold<int>(0, (total, roll) => total + roll) + modifier;
  }

  factory RollCheckEntity.fromRoll(RollEntity roll) {
    return RollCheckEntity(
      guid: roll.guid,
      createdAt: roll.createdAt,
      rollsValues: roll.diceRolls.map((e) => e.value).toList(),
      modifier: roll.modifier,
    );
  }

  String qrInfo() {
    final map = toJson();
    final json = jsonEncode(map);
    final base64 = base64Encode(utf8.encode(json));
    final key = Key.fromUtf8(const String.fromEnvironment('QRKEY'));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    return encrypter.encrypt(base64, iv: iv).base64;
  }

  factory RollCheckEntity.fromQr(String qrCode) {
    final key = Key.fromUtf8(const String.fromEnvironment('QRKEY'));
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    final base64 = encrypter.decrypt64(qrCode, iv: iv);
    final json = utf8.decode(base64Decode(base64));
    final object = jsonDecode(json);
    return RollCheckEntity.fromJson(object);
  }

  Map<String, dynamic> toJson() => _$RollCheckEntityToJson(this);
  factory RollCheckEntity.fromJson(Map<String, dynamic> json) =>
      _$RollCheckEntityFromJson(json);
}
