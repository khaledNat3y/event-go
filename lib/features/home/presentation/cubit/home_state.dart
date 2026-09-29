part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class EventsLoading extends HomeState {}

final class EventsSuccess extends HomeState {
  final List<EventModel> eventsList;
  EventsSuccess({required this.eventsList});

  EventsSuccess copyWith({List<EventModel>? events}) {
    return EventsSuccess(eventsList: events ?? eventsList);
  }
}

final class EventsFailure extends HomeState {
  final String message;
  final String code;
  EventsFailure({required this.message, required this.code});
}
