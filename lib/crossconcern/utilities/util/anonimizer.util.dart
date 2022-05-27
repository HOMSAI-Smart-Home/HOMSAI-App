import 'package:uuid/uuid.dart';

class Anonymizer {
  final Uuid uuid = const Uuid();
  final Map<String, String> _decipher = {};
  final Map<String, String> _cipher = {};

  String? decipher(String key) {
    return _decipher[key];
  }

  String? cipher(String plain) {
    return _cipher.putIfAbsent(plain, () {
      final key = uuid.v4();
      _decipher[key] = plain;
      return key;
    });
  }

  List<String> cipherAll(List<String> plains) {
    return plains.map((plain) => cipher(plain)).whereType<String>().toList();
  }

  List<String> decipherAll(List<String> keys) {
    return keys.map((key) => decipher(key)).whereType<String>().toList();
  }
}
