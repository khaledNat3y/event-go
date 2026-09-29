import 'package:event_ticket_booking/core/networking/api_constants.dart';
import 'package:event_ticket_booking/core/networking/api_error_handler.dart';
import 'package:event_ticket_booking/core/networking/api_result.dart';
import 'package:event_ticket_booking/core/networking/api_service.dart';
import 'package:event_ticket_booking/core/networking/ticket_master_error_parser.dart';
import 'package:event_ticket_booking/features/home/data/models/event_filters.dart';
import 'package:event_ticket_booking/features/home/data/models/events_response.dart';

class HomeRepo {
  final ApiService _apiService;
  const HomeRepo(this._apiService);

  Future<ApiResult> getEvents({
    EventFilters filters = const EventFilters(),
    int page = 0,
  }) async {
    try {
      final response = await _apiService.getRequest(
        endPoint: ApiConstants.events,
        queryParams: {
          'apikey': ApiConstants.apiKey,
          ...filters.toQueryParameters(page: page),
        },
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = EventsResponse.fromJson(response.data);
        return Success(data);
      } else {
        return Error(
          ApiErrorHandler.handle(response, parser: TicketmasterErrorParser()),
        );
      }
    } catch (e) {
      return Error(
        ApiErrorHandler.handle(e, parser: TicketmasterErrorParser()),
      );
    }
  }
}
