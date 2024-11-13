import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final List<Map<String, dynamic>> _locations = [
    {
      'name': 'Location 1',
      'lat': 37.7749,
      'lng': -122.4194,
      'details': 'Details about Location 1',
    },
    {
      'name': 'Location 2',
      'lat': 34.0522,
      'lng': -118.2437,
      'details': 'Details about Location 2',
    },
    {
      'name': 'Location 3',
      'lat': 40.7128,
      'lng': -74.0060,
      'details': 'Details about Location 3',
    },
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explore Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(_locations[0]['lat'], _locations[0]['lng']),
              zoom: 5.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _currentIndex = -1;
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
                          _currentIndex = index;
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
          if (_currentIndex != -1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0), // Padding tepi
                child: FlutterCarousel(
                  options: FlutterCarouselOptions(
                    height: 150,
                    viewportFraction:
                        0.9, // Mengatur lebar item di dalam carousel
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: _locations.map((location) {
                    return GestureDetector(
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity! < 0) {
                          // Swipe ke atas untuk membuka detail
                          showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                height: MediaQuery.of(context).size.height *
                                    0.85, // Menyisakan 15% bagian atas
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 5,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    Text(
                                      location['name'],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(location['details']),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 4), // Margin antar card
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
                              SizedBox(height: 8),
                              Text(
                                  'Lat: ${location['lat']}, Lng: ${location['lng']}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
