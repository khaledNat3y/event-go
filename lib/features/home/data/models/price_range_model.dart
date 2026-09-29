class PriceRangeModel {
  final String? currency;
  final double? min;
  final double? max;

  const PriceRangeModel({this.currency, this.min, this.max});

  factory PriceRangeModel.fromJson(Map<String, dynamic> json) {
    return PriceRangeModel(
      currency: json['currency'] as String?,
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );
  }
}
