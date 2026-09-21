import 'dart:io';

import 'package:event_ticket_booking/core/networking/api_error_handler.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';
import 'package:event_ticket_booking/core/networking/auth_error_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiErrorHandler.handle', () {
    final parser = AuthErrorParser();

    test('maps a DioException connection timeout', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.connectionTimeout,
          requestOptions: RequestOptions(path: '/test'),
        ),
        parser: parser,
      );

      expect(error.message, 'The request timed out. Please try again.');
      expect(error.code, 'TIMEOUT');
    });

    test('maps a DioException send timeout', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.sendTimeout,
          requestOptions: RequestOptions(path: '/test'),
        ),
        parser: parser,
      );

      expect(error.message, 'The request timed out. Please try again.');
      expect(error.code, 'TIMEOUT');
    });

    test('maps a DioException receive timeout', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: '/test'),
        ),
        parser: parser,
      );

      expect(error.message, 'The request timed out. Please try again.');
      expect(error.code, 'TIMEOUT');
    });

    test('maps a DioException connection error', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: '/test'),
        ),
        parser: parser,
      );

      expect(
        error.message,
        'No internet connection. Check your network and try again.',
      );
      expect(error.code, 'NETWORK_ERROR');
    });

    test('maps a DioException cancel', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.cancel,
          requestOptions: RequestOptions(path: '/test'),
        ),
        parser: parser,
      );

      expect(error.message, 'The request was cancelled.');
      expect(error.code, 'REQUEST_CANCELLED');
    });

    test('maps a DioException bad certificate', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.badCertificate,
          requestOptions: RequestOptions(path: '/test'),
        ),
        parser: parser,
      );

      expect(error.message, 'Insecure connection.');
      expect(error.code, 'BAD_CERTIFICATE');
    });

    test('maps an unknown DioException', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(path: '/test'),
        ),
        parser: parser,
      );

      expect(error.message, 'Something went wrong. Please try again.');
      expect(error.code, 'UNKNOWN_ERROR');
    });

    test('delegates bad response bodies to the parser', () {
      final error = ApiErrorHandler.handle(
        DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 409,
            data: {'message': 'Email already exists', 'statusMsg': 'fail'},
          ),
        ),
        parser: parser,
      );

      expect(error.message, 'Email already exists');
      expect(error.code, 'fail');
    });

    test('maps a SocketException to a network error', () {
      final error = ApiErrorHandler.handle(
        const SocketException('Connection refused'),
        parser: parser,
      );

      expect(
        error.message,
        'No internet connection. Check your network and try again.',
      );
      expect(error.code, 'NETWORK_ERROR');
    });

    test('maps any other error to a generic message', () {
      final error = ApiErrorHandler.handle(
        Exception('something broke'),
        parser: parser,
      );

      expect(error.message, 'Something went wrong. Please try again.');
      expect(error.code, 'UNKNOWN_ERROR');
    });

    test('always returns an AppError', () {
      final error = ApiErrorHandler.handle(
        'a plain string error',
        parser: parser,
      );

      expect(error, isA<AppError>());
    });
  });
}