class EventImageModel {
  final String url;
  final int width;
  final int height;
  final String? ratio;

  const EventImageModel({
    required this.url,
    required this.width,
    required this.height,
    this.ratio,
  });

  factory EventImageModel.fromJson(Map<String, dynamic> json) {
    return EventImageModel(
      url: json['url'] as String? ?? '',
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
      ratio: json['ratio'] as String?,
    );
  }
}
