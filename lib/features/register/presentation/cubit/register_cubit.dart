import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/features/register/data/models/register_request_model.dart';
import 'package:event_ticket_booking/features/register/data/repos/register_repo.dart';
import 'package:event_ticket_booking/features/register/presentation/cubit/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo _registerRepo;
  RegisterCubit({required this._registerRepo})
    : super(RegisterState(status: Status.initial));

  Future<void> register(RegisterRequestModel registerModel) async {
    emit(state.copyWith(status: Status.loading));
    final response = await _registerRepo.register(registerModel);
    switch (response) {
      case Success<dynamic>(data: final message):
        emit(state.copyWith(status: Status.success, message: message));
        break;
      case Error(error: final error):
        emit(state.copyWith(status: Status.error, message: error.message));
        break;
    }
  }
}
