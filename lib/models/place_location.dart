import 'package:flutter/foundation.dart';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String? address; // Use String? to allow null for address

  const PlaceLocation({
    required this.latitude,   // Use required instead of @required
    required this.longitude,  // Use required instead of @required
    this.address,             // This can remain optional
  });
}