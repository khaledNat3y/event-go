import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';
import 'package:event_ticket_booking/features/login/data/models/login_request_model.dart';
import 'package:event_ticket_booking/features/login/data/models/login_response_model.dart';
import 'package:event_ticket_booking/features/login/data/repos/login_repo.dart';
import 'package:event_ticket_booking/features/login/presentation/cubit/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  LoginCubit({required this._loginRepo})
    : super(LoginState(status: Status.initial));

  Future<void> login(LoginRequestModel loginModel) async {
    emit(state.copyWith(status: Status.loading));
    final response = await _loginRepo.login(loginModel);
    switch (response) {
      case Success<dynamic>(data: final data):
        final loginData = data as LoginResponseModel;
        emit(
          state.copyWith(
            status: Status.success,
            message: loginData.message ?? 'Login successful',
          ),
        );
        break;
      case Error(error: final error):
        final appError = error as AppError;
        emit(state.copyWith(status: Status.error, message: appError.message));
        break;
    }
  }
}