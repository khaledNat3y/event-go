import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiResult', () {
    test('Success holds data', () {
      final result = Success<int>(42);

      expect(result, isA<Success<int>>());
      expect(result.data, 42);
    });

    test('Error holds an error payload', () {
      final result = Error<String>('failure');

      expect(result, isA<Error<String>>());
      expect(result.error, 'failure');
    });

    test('supports exhaustive pattern matching', () {
      List<String> handle<T>(ApiResult<T> result) {
        return switch (result) {
          Success<T>(data: final data) => ['success', '$data'],
          Error<T>(error: final error) => ['error', '$error'],
        };
      }

      expect(handle(Success<int>(7)), ['success', '7']);
      expect(handle(Error<String>('bad')), ['error', 'bad']);
    });
  });
}