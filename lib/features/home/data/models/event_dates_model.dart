class EventDatesModel {
  final DateTime? startDateTime;
  final String? localDate;
  final String? localTime;
  final String? statusCode;

  const EventDatesModel({
    this.startDateTime,
    this.localDate,
    this.localTime,
    this.statusCode,
  });

  factory EventDatesModel.fromJson(Map<String, dynamic> json) {
    final start = json['start'] as Map<String, dynamic>?;
    final status = json['status'] as Map<String, dynamic>?;

    return EventDatesModel(
      startDateTime: DateTime.tryParse(start?['dateTime']?.toString() ?? ''),
      localDate: start?['localDate'] as String?,
      localTime: start?['localTime'] as String?,
      statusCode: status?['code'] as String?,
    );
  }

  DateTime? get resolvedDate =>
      startDateTime ?? DateTime.tryParse(localDate ?? '');
}
