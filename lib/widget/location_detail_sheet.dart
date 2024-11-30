import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LocationDetailSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<double> indicators; // List untuk persentase indikator

  LocationDetailSheet({
    required this.title,
    required this.subtitle,
    required this.indicators,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.85, // Tinggi 85% layar
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 25),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Dua kolom
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: List.generate(4, (index) {
                // Warna berbeda untuk setiap indikator
                final colors = [
                  Color(0xFF4CAF50), // Green for "Organic"
                  Color(0xFFFF9800), // Orange for "Non-organic"
                  Color(0xFFF44336), // Red for "B3"
                  Color(0xFF9E9E9E), // Grey for "Unidentified"
                ];
                final legends = [
                  "Organic",
                  "Non-organic",
                  "B3",
                  "Unidentified"
                ];

                return Container(
                  constraints: BoxConstraints(
                    maxWidth: 250.0, // Maksimum lebar
                    maxHeight: 200.0, // Maksimum tinggi
                  ),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 8.0,
                          percent: indicators[index],
                          center: Text("${(indicators[index] * 100).toInt()}%"),
                          progressColor: colors[index],
                        ),
                        SizedBox(height: 5),
                        Text(
                          legends[index],
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
