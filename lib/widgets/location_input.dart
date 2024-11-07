import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  double? latitude;
  double? longitude;

  Future<void> _getCurrentUserLocation() async {
    final Location location = Location();
    try {
      final locData = await location.getLocation();
      latitude = locData.latitude;
      longitude = locData.longitude;
      widget.onSelectPlace(latitude, longitude);
      print('Latitude: $latitude, Longitude: $longitude');
    } catch (error) {
      // Handle the error here, e.g., show a message to the user
      print('Error getting current location: $error');
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(isSelecting: true),
      ),
    );
    if (selectedLocation != null) {
      latitude = selectedLocation.latitude;
      longitude = selectedLocation.longitude;
      widget.onSelectPlace(latitude, longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton.icon(
          icon: Icon(Icons.location_on),
          label: Text('Current Location'),
          onPressed: _getCurrentUserLocation,
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
        ),
        TextButton.icon(
          icon: Icon(Icons.map),
          label: Text('Select on Map'),
          onPressed: _selectOnMap,
          style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}

class LocationInputEnd extends StatefulWidget {
  final Function onSelectPlace;

  LocationInputEnd(this.onSelectPlace);

  @override
  _LocationInputEndState createState() => _LocationInputEndState();
}

class _LocationInputEndState extends State<LocationInputEnd> {
  double? latitude;
  double? longitude;

  double? getEndLatitude() {
    return latitude;
  }

  double? getEndLongitude() {
    return longitude;
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(isSelecting: true),
      ),
    );
    if (selectedLocation != null) {
      latitude = selectedLocation.latitude;
      longitude = selectedLocation.longitude;
      widget.onSelectPlace(latitude, longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: Icon(Icons.map),
      label: Text('Select on Map'),
      onPressed: _selectOnMap,
      style: TextButton.styleFrom(foregroundColor: Theme.of(context).primaryColor),
    );
  }
}
