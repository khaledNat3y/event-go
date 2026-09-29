import '../../../../core/networking/api_constants.dart';

class EventFilters {
  final String keyword;
  final String? classificationName;
  final String countryCode;

  const EventFilters({
    this.keyword = '',
    this.classificationName,
    this.countryCode = ApiConstants.defaultCountryCode,
  });

  EventFilters copyWith({
    String? keyword,
    String? classificationName,
    bool clearClassification = false,
    String? countryCode,
  }) {
    return EventFilters(
      keyword: keyword ?? this.keyword,
      classificationName: clearClassification
          ? null
          : (classificationName ?? this.classificationName),
      countryCode: countryCode ?? this.countryCode,
    );
  }

  Map<String, dynamic> toQueryParameters({required int page}) {
    return {
      'countryCode': countryCode,
      'size': ApiConstants.pageSize,
      'page': page,
      'sort': 'date,asc',
      if (keyword.trim().isNotEmpty) 'keyword': keyword.trim(),
      if (classificationName != null) 'classificationName': classificationName,
    };
  }
}
