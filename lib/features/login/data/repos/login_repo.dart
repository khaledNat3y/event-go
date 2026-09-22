import 'package:dio/dio.dart';
import 'package:event_ticket_booking/core/helper/app_constants.dart';
import 'package:event_ticket_booking/core/helper/shared_pref_helper.dart';
import 'package:event_ticket_booking/core/networking/api_constants.dart';
import 'package:event_ticket_booking/core/networking/api_error_handler.dart';
import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/api_service.dart';
import 'package:event_ticket_booking/core/networking/auth_error_parser.dart';
import 'package:event_ticket_booking/features/login/data/models/login_request_model.dart';
import 'package:event_ticket_booking/features/login/data/models/login_response_model.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<ApiResult> login(LoginRequestModel loginModel) async {
    try {
      final response = await _apiService.postRequest(
        endPoint: ApiConstants.loginEndPoint,
        body: loginModel.toJson(),
      );
      if (response.statusCode! >= 200 && response.statusCode! < 400) {
        final data = LoginResponseModel.fromJson(response.data);
        // NOTE: I Think we don't need to save token in login because i save it when user register new account.
        // await SharedPrefHelper.setSecuredString(
        //   AppConstants.tokenKey,
        //   data.token!,
        // );
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
