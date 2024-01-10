import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newnew_favorite_places/models/places.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
        address: '', latitude: 422.022, longitude: -122.084),
    this.isSelecting = true,
  });
  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.latitude, widget.location.longitude),
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: const MarkerId(
              'm1',
            ),
            position:
                LatLng(widget.location.latitude, widget.location.longitude),
          ),
        },
      ),
    );
  }
}
