import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/crossconcern/helpers/models/forms/url.model.dart';

const validUrls = [
  "website.com",
  "www.website.com",
  "http://website.com",
  "https://website.com",
  "http://123.123.123.123",
  "http://123.123.123.123:1234",
  "https://123.123.123.123",
];

const invalidUrls = [
  "http://256.123.123.123:1212",
  "htp://123.123.123.123:1234",
  "http:/123.123.123.123:1234",
  "http://123.123.123",
  "http://-error-.invalid/",
  "http://-a.b.co",
  "http://a.b-.co",
];

void main() {
  group("URL", () {
    test('should be empty', () {
      expect(const Url.pure().value, '');
    });

    group("should be valid:", () {
      for (var url in validUrls) {
        test(url, () {
          final e = Url.pure(url);

          expect(e.valid, true);
        });
      }
    });

    group("should be invalid:", () {
      for (var url in invalidUrls) {
        test(url, () {
          final e = Url.pure(url);

          expect(e.valid, false);
        });
      }
    });
  });
}
