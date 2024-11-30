import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wastetrack/widget/location_detail_sheet.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'TPS KALIWARON',
      'lat': -7.2598809251486545,
      'lng': 112.7702110011479,
      'details': 'Garbage dump',
      'indicators': [0.7, 0.5, 0.6, 0.3],
    },
    {
      'name': 'TPS Pacar Keling',
      'lat': -7.2580077841167006,
      'lng': 112.75767972170691,
      'details': 'Garbage dump',
      'indicators': [0.4, 0.8, 0.3, 0.6],
    },
    {
      'name': 'TPS Kertopaten',
      'lat': -7.2312721039322705,
      'lng': 112.74240186047065,
      'details': 'Garbage dump',
      'indicators': [0.5, 0.7, 0.4, 0.2],
    },
  ];

  int _currentIndex = 0;
  final MapController _mapController =
      MapController(); // map's movement programmatically

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(_locations[0]['lat'], _locations[0]['lng']),
              zoom: 5.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _currentIndex = -1; // Reset carousel when tapping the map
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: _locations.map((location) {
                  int index = _locations.indexOf(location);
                  return Marker(
                    point: LatLng(location['lat'], location['lng']),
                    builder: (ctx) => GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex =
                              index; // Set the current index based on the tapped marker
                        });
                      },
                      child: Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          if (_currentIndex != -1) // Show carousel when a marker is tapped
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: FlutterCarousel(
                options: FlutterCarouselOptions(
                  height: 115,
                  viewportFraction: 0.9,
                  initialPage:
                      _currentIndex, // Start the carousel at the tapped location
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: _locations.map((location) {
                  return GestureDetector(
                    onTap: () {
                      // Move the map to the selected marker when carousel item is clicked
                      _mapController.move(
                        LatLng(location['lat'], location['lng']),
                        15.0, // Zoom level after moving
                      );
                    },
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! < 0) {
                        // Swipe up to open the bottom sheet
                        showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return LocationDetailSheet(
                              title: location['name'],
                              subtitle: location['details'],
                              indicators: location['indicators'],
                            );
                          },
                        );
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              location['details'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
