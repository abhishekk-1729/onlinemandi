import 'package:flutter_test/flutter_test.dart';
import 'package:onlinemandi/core/utils/helpers.dart';

void main() {
  group('Helpers', () {
    test('formatDate formats date correctly', () {
      final date = DateTime(2024, 1, 15);
      expect(Helpers.formatDate(date), '15/1/2024');
    });

    test('isValidEmail validates email correctly', () {
      expect(Helpers.isValidEmail('test@example.com'), true);
      expect(Helpers.isValidEmail('invalid-email'), false);
    });
  });
}

