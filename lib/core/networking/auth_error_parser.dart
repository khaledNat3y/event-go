import 'package:event_ticket_booking/core/networking/api_error_model_route.dart';
import 'package:event_ticket_booking/core/networking/api_error_parser.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';

class AuthErrorParser implements ApiErrorParser {
  @override
  AppError parse(dynamic responseData, int? statusCode) {
    if (responseData is Map<String, dynamic>) {
      final error = ApiErrorModelRoute.fromJson(responseData);

      return AppError(
        message: error.message ?? 'Something went wrong.',
        code: error.statusMsg ?? statusCode?.toString() ?? 'UNKNOWN_ERROR',
      );
    }

    return AppError(
      message: 'Something went wrong. Please try again.',
      code: statusCode?.toString() ?? 'UNKNOWN_ERROR',
    );
  }
}
