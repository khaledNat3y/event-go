import 'package:event_ticket_booking/core/networking/app_error.dart';

abstract interface class ApiErrorParser {
  AppError parse(dynamic responseData, int? statusCode);
}
