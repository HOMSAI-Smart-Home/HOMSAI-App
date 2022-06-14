import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/crossconcern/helpers/models/forms/credentials/email.model.dart';

const validEmails = [
  // Prefixes
  "abc-d@mail.com",
  "abc.def@mail.com",
  "abc@mail.com",
  "abc_def@mail.com",

  // Domains
  "abc.def@mail.cc",
  "abc.def@mail-archive.com",
  "abc.def@mail.org",
  "abc.def@mail.com"
];

const invalidEmails = [
  // Prefixes
  "abc-@mail.com",
  "abc..def@mail.com",
  ".abc@mail.com",
  "abc#def@mail.com",

  // Domains
  "abc.def@mail.c",
  "abc.def@mail#archive.com",
  "abc.def@mail",
  "abc.def@mail..com"
];

void main() {
  group("Email", () {
    test('should be empty', () {
      expect(const Email.pure().value, '');
    });

    group("should be valid:", () {
      for (var email in validEmails) {
        test(email, () {
          final e = Email.pure(email);

          expect(e.valid, true);
        });
      }
    });

    group("should be invalid:", () {
      for (var email in invalidEmails) {
        test(email, () {
          final e = Email.pure(email);

          expect(e.valid, false);
        });
      }
    });
  });
}
