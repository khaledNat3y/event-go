class VenueModel {
  final String? name;
  final String? city;
  final String? country;
  final String? addressLine;
  final double? latitude;
  final double? longitude;

  const VenueModel({
    this.name,
    this.city,
    this.country,
    this.addressLine,
    this.latitude,
    this.longitude,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    return VenueModel(
      name: json['name'] as String?,
      city: (json['city'] as Map<String, dynamic>?)?['name'] as String?,
      country: (json['country'] as Map<String, dynamic>?)?['name'] as String?,
      addressLine:
          (json['address'] as Map<String, dynamic>?)?['line1'] as String?,
      latitude: double.tryParse(location?['latitude']?.toString() ?? ''),
      longitude: double.tryParse(location?['longitude']?.toString() ?? ''),
    );
  }

  String get shortLocation {
    final parts = [
      city,
      country,
    ].where((part) => part != null && part.isNotEmpty);
    return parts.join(', ');
  }
}
