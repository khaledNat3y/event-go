import 'package:dio/dio.dart';
import 'package:event_ticket_booking/core/networking/api_constants.dart';
import 'package:event_ticket_booking/core/networking/api_error_handler.dart';
import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/api_service.dart';
import 'package:event_ticket_booking/core/networking/auth_error_parser.dart';
import 'package:event_ticket_booking/core/networking/dio_factory.dart';
import 'package:event_ticket_booking/features/register/data/models/register_request_model.dart';
import 'package:event_ticket_booking/features/register/data/models/register_response_model.dart';

class RegisterRepo {
  final ApiService _apiService;

  RegisterRepo(this._apiService);

  Future<ApiResult> register(RegisterRequestModel registerModel) async {
    try {
      final response = await _apiService.postRequest(
        endPoint: ApiConstants.registerEndPoint,
        body: registerModel.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        final data = RegisterResponseModel.fromJson(response.data);
        return Success(data);
      } else {
        return Error(
          ApiErrorHandler.handle(response, parser: AuthErrorParser()),
        );
      }
    } on DioException catch (e) {
      return Error(ApiErrorHandler.handle(e, parser: AuthErrorParser()));
    }
  }
}
