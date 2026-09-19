import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_ticket_booking/core/networking/api_error_parser.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static AppError handle(Object error, {required ApiErrorParser parser}) {
    if (error is DioException) {
      return _fromDioException(error, parser);
    }

    if (error is SocketException) {
      return const AppError(
        message: 'No internet connection. Check your network and try again.',
        code: 'NETWORK_ERROR',
      );
    }

    return const AppError(
      message: 'Something went wrong. Please try again.',
      code: 'UNKNOWN_ERROR',
    );
  }

  static AppError _fromDioException(
    DioException exception,
    ApiErrorParser parser,
  ) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppError(
          message: 'The request timed out. Please try again.',
          code: 'TIMEOUT',
        );

      case DioExceptionType.connectionError:
        return const AppError(
          message: 'No internet connection. Check your network and try again.',
          code: 'NETWORK_ERROR',
        );

      case DioExceptionType.cancel:
        return const AppError(
          message: 'The request was cancelled.',
          code: 'REQUEST_CANCELLED',
        );

      case DioExceptionType.badCertificate:
        return const AppError(
          message: 'Insecure connection.',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.badResponse:
        return parser.parse(
          exception.response?.data,
          exception.response?.statusCode,
        );

      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return const AppError(
          message: 'Something went wrong. Please try again.',
          code: 'UNKNOWN_ERROR',
        );
    }
  }
}
