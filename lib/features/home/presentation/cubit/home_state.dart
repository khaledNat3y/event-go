part of 'home_cubit.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class EventsLoading extends HomeState {}

final class EventsSuccess extends HomeState {
  final List<EventModel> eventsList;
  final PaginationModel paginationModel;
  final bool isLoadingMore;
  final String? loadMoreError;

  const EventsSuccess({
    required this.eventsList,
    required this.paginationModel,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  bool get hasNextPage => paginationModel.hasNextPage;

  EventsSuccess copyWith({
    List<EventModel>? eventsList,
    PaginationModel? paginationModel,
    bool? isLoadingMore,
    Object? loadMoreError = _keepLoadMoreError,
  }) {
    return EventsSuccess(
      eventsList: eventsList ?? this.eventsList,
      paginationModel: paginationModel ?? this.paginationModel,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: identical(loadMoreError, _keepLoadMoreError)
          ? this.loadMoreError
          : loadMoreError as String?,
    );
  }
}

const Object _keepLoadMoreError = Object();

final class EventsFailure extends HomeState {
  final String message;
  final String code;
  const EventsFailure({required this.message, required this.code});
}