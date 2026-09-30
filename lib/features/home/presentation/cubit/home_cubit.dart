import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/app_error.dart';
import 'package:event_ticket_booking/features/home/data/models/event_model.dart';
import 'package:event_ticket_booking/features/home/data/models/events_response.dart';
import 'package:event_ticket_booking/features/home/data/models/pagination_model.dart';
import 'package:event_ticket_booking/features/home/data/repos/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo repo;
  final List<EventModel> newListOfEvents = [];
  bool _isFetching = false;

  HomeCubit({required this.repo}) : super(HomeInitial());

  /// [pageNumber] == 0 is treated as a refresh: the accumulated list is
  /// cleared and the full screen loader is shown.
  Future<void> getEvents({int pageNumber = 0}) async {
    if (_isFetching) return;

    final isRefresh = pageNumber == 0;
    if (!isRefresh && !_hasNextPage) return;

    _isFetching = true;

    if (isRefresh) {
      newListOfEvents.clear();
      emit(EventsLoading());
    } else {
      _emitCurrent(isLoadingMore: true, loadMoreError: null);
    }

    final events = await repo.getEvents(page: pageNumber);
    _isFetching = false;

    switch (events) {
      case Success<dynamic>(data: final data):
        final eventData = data as EventsResponse;
        newListOfEvents.addAll(eventData.events);

        emit(
          EventsSuccess(
            eventsList: List.unmodifiable(newListOfEvents),
            paginationModel: eventData.page,
          ),
        );
        break;
      case Error<dynamic>(error: final error):
        final appError = error as AppError;
        if (newListOfEvents.isEmpty) {
          emit(EventsFailure(message: appError.message, code: appError.code));
        } else {
          _emitCurrent(isLoadingMore: false, loadMoreError: appError.message);
        }
        break;
    }
  }

  /// Appends the next page without tearing down the currently rendered list.
  Future<void> loadMore() => getEvents(pageNumber: _nextPage);

  bool get _hasNextPage => switch (state) {
    EventsSuccess(:final hasNextPage) => hasNextPage,
    _ => false,
  };

  int get _nextPage => switch (state) {
    EventsSuccess(:final paginationModel) => paginationModel.number + 1,
    _ => 1,
  };

  void _emitCurrent({required bool isLoadingMore, String? loadMoreError}) {
    final current = state;
    if (current is! EventsSuccess) return;
    emit(
      current.copyWith(
        isLoadingMore: isLoadingMore,
        loadMoreError: loadMoreError,
      ),
    );
  }
}