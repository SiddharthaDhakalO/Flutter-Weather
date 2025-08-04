import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForecastEntry {
  final DateTime time;
  final double temp;
  final String icon;
  ForecastEntry({required this.time, required this.temp, required this.icon});
}

class ForecastGraph extends StatelessWidget {
  final List<ForecastEntry> forecastData;
  const ForecastGraph({super.key, required this.forecastData});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('24-Hour Forecast', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: forecastData.map((entry) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.network(
                          'https://openweathermap.org/img/wn/${entry.icon}.png',
                          width: 32,
                          height: 32,
                        ),
                        Text('${entry.temp.toStringAsFixed(0)}°', style: GoogleFonts.poppins(fontSize: 16)),
                        Text('${entry.time.hour}:00', style: GoogleFonts.poppins(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 