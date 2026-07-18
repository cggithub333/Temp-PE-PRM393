import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  final String address;
  const MapScreen({super.key, required this.address});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _position;
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _geocodeAddress();
  }

  Future<void> _geocodeAddress() async {
    try {
      final locations = await locationFromAddress(widget.address);
      if (locations.isNotEmpty) {
        setState(() {
          _position = LatLng(locations.first.latitude, locations.first.longitude);
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Could not find location for this address.';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Location')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFF1E1E1E),
                      width: double.infinity,
                      child: Text(
                        widget.address,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: GoogleMap(
                        onMapCreated: (c) => _mapController = c,
                        initialCameraPosition: CameraPosition(target: _position!, zoom: 15),
                        markers: {
                          Marker(
                            markerId: const MarkerId('student'),
                            position: _position!,
                            infoWindow: InfoWindow(title: 'Student Location', snippet: widget.address),
                          ),
                        },
                        mapType: MapType.normal,
                        myLocationButtonEnabled: false,
                      ),
                    ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
