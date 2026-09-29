import 'event_model.dart';
import 'pagination_model.dart';

class EventsResponse {
  final List<EventModel> events;
  final PaginationModel page;

  const EventsResponse({required this.events, required this.page});

  factory EventsResponse.fromJson(Map<String, dynamic> json) {
    final embedded = json['_embedded'] as Map<String, dynamic>?;
    final rawEvents = embedded?['events'] as List<dynamic>? ?? [];

    return EventsResponse(
      events: rawEvents
          .map((item) => EventModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: PaginationModel.fromJson(
        json['page'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}
