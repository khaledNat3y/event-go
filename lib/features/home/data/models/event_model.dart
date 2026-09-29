import 'event_dates_model.dart';
import 'event_image_model.dart';
import 'price_range_model.dart';
import 'venue_model.dart';

class EventModel {
  final String id;
  final String name;
  final String? ticketUrl;
  final String? info;
  final List<EventImageModel> images;
  final EventDatesModel? dates;
  final List<PriceRangeModel> priceRanges;
  final VenueModel? venue;
  final String? segmentName;
  final String? genreName;

  const EventModel({
    required this.id,
    required this.name,
    this.ticketUrl,
    this.info,
    this.images = const [],
    this.dates,
    this.priceRanges = const [],
    this.venue,
    this.segmentName,
    this.genreName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final embedded = json['_embedded'] as Map<String, dynamic>?;
    final venues = embedded?['venues'] as List<dynamic>?;
    final classifications = json['classifications'] as List<dynamic>?;
    final classification = (classifications == null || classifications.isEmpty)
        ? null
        : classifications.first as Map<String, dynamic>;

    return EventModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Untitled event',
      ticketUrl: json['url'] as String?,
      info: json['info'] as String? ?? json['pleaseNote'] as String?,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((item) => EventImageModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      dates: json['dates'] == null
          ? null
          : EventDatesModel.fromJson(json['dates'] as Map<String, dynamic>),
      priceRanges: (json['priceRanges'] as List<dynamic>? ?? [])
          .map((item) => PriceRangeModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      venue: (venues == null || venues.isEmpty)
          ? null
          : VenueModel.fromJson(venues.first as Map<String, dynamic>),
      segmentName:
          (classification?['segment'] as Map<String, dynamic>?)?['name']
              as String?,
      genreName:
          (classification?['genre'] as Map<String, dynamic>?)?['name']
              as String?,
    );
  }

  String? get coverImageUrl {
    if (images.isEmpty) return null;

    final wide = images
        .where((image) => image.ratio == '16_9' && image.width >= 640)
        .toList();
    if (wide.isNotEmpty) return wide.first.url;

    final sorted = [...images]..sort((a, b) => b.width.compareTo(a.width));
    return sorted.first.url;
  }

  DateTime? get startDate => dates?.resolvedDate;

  bool get isOnSale => (dates?.statusCode ?? 'onsale') == 'onsale';

  bool get isUpcoming =>
      startDate == null || startDate!.isAfter(DateTime.now());

  bool get isBookable => isOnSale && isUpcoming;

  String? get formattedPriceRange {
    if (priceRanges.isEmpty) return null;

    final range = priceRanges.first;
    final currency = range.currency ?? '';
    final min = range.min;
    final max = range.max;

    if (min == null && max == null) return null;
    if (min != null && max != null && min != max) {
      return '$currency ${min.toStringAsFixed(0)} - ${max.toStringAsFixed(0)}';
    }
    return '$currency ${(min ?? max)!.toStringAsFixed(0)}';
  }
}
