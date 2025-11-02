class LocationData {
  final double lat;
  final double lng;
  final String address;

  LocationData({
    required this.lat,
    required this.lng,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
    };
  }

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      lat: map['lat']?.toDouble() ?? 0.0,
      lng: map['lng']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
    );
  }

  @override
  String toString() => address;
}
