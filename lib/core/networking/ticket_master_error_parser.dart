import 'package:event_ticket_booking/core/networking/api_error_model.dart';
import 'package:event_ticket_booking/core/networking/api_error_parser.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';

class TicketmasterErrorParser implements ApiErrorParser {
  @override
  AppError parse(dynamic responseData, int? statusCode) {
    if (responseData is Map<String, dynamic> && responseData['fault'] != null) {
      try {
        final error = ApiErrorModel.fromJson(responseData);

        return AppError(
          message:
              error.fault?.faultstring ??
              'Something went wrong. Please try again.',
          code:
              error.fault?.detail?.errorcode ??
              statusCode?.toString() ??
              'UNKNOWN_ERROR',
        );
      } catch (_) {
        // Fall through to status code handling
      }
    }

    return _fromStatusCode(statusCode);
  }

  AppError _fromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const AppError(
          message: 'Invalid request. Try changing your filters.',
          code: '400',
        );

      case 401:
        return const AppError(message: 'Invalid API key.', code: '401');

      case 404:
        return const AppError(
          message: 'The requested resource was not found.',
          code: '404',
        );

      case 429:
        return const AppError(
          message: 'Too many requests. Please wait a moment.',
          code: '429',
        );

      case 500:
      case 502:
      case 503:
        return AppError(
          message: 'The service is unavailable right now.',
          code: statusCode.toString(),
        );

      default:
        return AppError(
          message: 'Unexpected error. Please try again.',
          code: statusCode?.toString() ?? 'UNKNOWN_STATUS',
        );
    }
  }
}
