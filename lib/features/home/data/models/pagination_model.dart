class PaginationModel {
  final int size;
  final int totalElements;
  final int totalPages;
  final int number;

  const PaginationModel({
    this.size = 0,
    this.totalElements = 0,
    this.totalPages = 0,
    this.number = 0,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      size: (json['size'] as num?)?.toInt() ?? 0,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      number: (json['number'] as num?)?.toInt() ?? 0,
    );
  }

  bool get hasNextPage => number + 1 < totalPages;
}
