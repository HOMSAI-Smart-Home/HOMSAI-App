import 'dart:math';
import 'dart:typed_data';

extension IPv4 on String {
  static String parse(int value) {
    Uint8List int32bytes(int value) =>
        Uint8List(4)..buffer.asInt32List()[0] = value;

    return int32bytes(value).reversed.toList().join('.');
  }

  int parseIPv4Address() {
    final iplist = Uri.parseIPv4Address(this);
    return iplist.asMap().entries.map((entry) {
      return entry.value * pow(256, iplist.length - entry.key - 1);
    }).reduce((prev, curr) {
      return prev + curr;
    }).toInt();
  }
}
