import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place_location.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation = const PlaceLocation(
      latitude: 19.015723586531074,
      longitude: 72.84425150603056,
    ),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation; // Make this nullable

  @override
  void initState() {
    super.initState();
    // Set initial picked location to the initial location
    _pickedLocation = LatLng(widget.initialLocation.latitude, widget.initialLocation.longitude);
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position; // Update the picked location
    });
    print('Selected Location: ${position.latitude}, ${position.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 13,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('L'),
                  position: _pickedLocation ?? LatLng(
                    widget.initialLocation.latitude,
                    widget.initialLocation.longitude,
                  ),
                ),
              },
      ),
    );
  }
}
