import 'package:event_ticket_booking/core/networking/api_error_model.dart';
import 'package:event_ticket_booking/core/networking/auth_error_parser.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';
import 'package:event_ticket_booking/core/networking/ticket_master_error_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TicketmasterErrorParser', () {
    final parser = TicketmasterErrorParser();

    test('parses fault payload from the response body', () {
      final error = parser.parse({
        'fault': {
          'faultstring': 'Something is broken',
          'detail': {'errorcode': '9002'},
        },
      }, 400);

      expect(error.message, 'Something is broken');
      expect(error.code, '9002');
    });

    test('falls back to faultstring without detail', () {
      final error = parser.parse({
        'fault': {'faultstring': 'Bad stuff'},
      }, 500);

      expect(error.message, 'Bad stuff');
      expect(error.code, '500');
    });

    test('falls back to generic message when fault fields missing', () {
      final error = parser.parse({
        'fault': <String, dynamic>{},
      }, 429);

      expect(error.message, 'Something went wrong. Please try again.');
      expect(error.code, '429');
    });

    test('maps 400 status code', () {
      final error = parser.parse('plain text', 400);

      expect(error.message, 'Invalid request. Try changing your filters.');
      expect(error.code, '400');
    });

    test('maps 401 status code', () {
      final error = parser.parse(null, 401);

      expect(error.message, 'Invalid API key.');
      expect(error.code, '401');
    });

    test('maps 404 status code', () {
      final error = parser.parse(null, 404);

      expect(error.message, 'The requested resource was not found.');
      expect(error.code, '404');
    });

    test('maps 429 status code', () {
      final error = parser.parse(null, 429);

      expect(error.message, 'Too many requests. Please wait a moment.');
      expect(error.code, '429');
    });

    test('maps 5xx status codes', () {
      for (final code in [500, 502, 503]) {
        final error = parser.parse(null, code);

        expect(error.message, 'The service is unavailable right now.');
        expect(error.code, '$code');
      }
    });

    test('maps unexpected status codes to a generic message', () {
      final error = parser.parse(null, 418);

      expect(error.message, 'Unexpected error. Please try again.');
      expect(error.code, '418');
    });

    test('maps unknown status to UNKNOWN_STATUS', () {
      final error = parser.parse(null, null);

      expect(error.message, 'Unexpected error. Please try again.');
      expect(error.code, 'UNKNOWN_STATUS');
    });

    test('returns AppError', () {
      expect(parser.parse(null, 400), isA<AppError>());
    });
  });

  group('AuthErrorParser', () {
    final parser = AuthErrorParser();

    test('parses message and statusMsg from a map payload', () {
      final error = parser.parse({
        'statusMsg': 'fail',
        'message': 'Email already exists',
      }, 409);

      expect(error.message, 'Email already exists');
      expect(error.code, 'fail');
    });

    test('falls back to status code when statusMsg missing', () {
      final error = parser.parse({'message': 'nope'}, 400);

      expect(error.message, 'nope');
      expect(error.code, '400');
    });

    test('uses defaults when payload is not a map', () {
      final error = parser.parse('unexpected', 500);

      expect(error.message, 'Something went wrong. Please try again.');
      expect(error.code, '500');
    });

    test('uses defaults when payload is null', () {
      final error = parser.parse(null, 500);

      expect(error.message, 'Something went wrong. Please try again.');
      expect(error.code, '500');
    });

    test('uses UNKNOWN_ERROR when status code is missing', () {
      final error = parser.parse(null, null);

      expect(error.message, 'Something went wrong. Please try again.');
      expect(error.code, 'UNKNOWN_ERROR');
    });

    test('returns AppError', () {
      expect(parser.parse({'message': 'x'}, 400), isA<AppError>());
    });
  });

  group('ApiErrorModel fixtures', () {
    test('ApiErrorModel.fromJson parses fault detail', () {
      final model = ApiErrorModel.fromJson({
        'fault': {
          'faultstring': 'boom',
          'detail': {'errorcode': '1001'},
        },
      });

      expect(model.fault?.faultstring, 'boom');
      expect(model.fault?.detail?.errorcode, '1001');
    });

    test('ApiErrorModel.fromJson handles null fault', () {
      final model = ApiErrorModel.fromJson({});

      expect(model.fault, isNull);
    });
  });
}