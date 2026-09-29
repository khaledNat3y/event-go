import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';
import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:event_ticket_booking/features/home/data/models/events_response.dart';
import 'package:event_ticket_booking/features/home/data/repos/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;
  HomeCubit({required this.repo}) : super(HomeInitial());

  Future<void> getEvents() async {
    emit(EventsLoading());
    final events = await repo.getEvents();
    switch (events) {
      case Success<dynamic>(data: final data):
        final eventData = data as EventsResponse;
        emit(EventsSuccess(eventsList: eventData.events));
        break;
      case Error<dynamic>(error: final error):
        final appError = error as AppError;
        emit(EventsFailure(message: appError.message, code: appError.code));
        break;
    }
  }
}
