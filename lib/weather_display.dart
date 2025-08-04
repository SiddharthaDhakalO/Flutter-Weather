import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherDisplay extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  const WeatherDisplay({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final temp = weatherData['main']['temp'].toStringAsFixed(0);
    final city = weatherData['name'];
    final desc = weatherData['weather'][0]['description'];
    final icon = weatherData['weather'][0]['icon'];
    final humidity = weatherData['main']['humidity'];
    final wind = weatherData['wind']['speed'];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              city,
              style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Image.network(
              'https://openweathermap.org/img/wn/$icon@4x.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              '$temp°C',
              style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.w600, color: Colors.blueAccent),
            ),
            const SizedBox(height: 8),
            Text(
              desc.toString().toUpperCase(),
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blueAccent),
                    const SizedBox(height: 4),
                    Text('Humidity', style: GoogleFonts.poppins(fontSize: 14)),
                    Text('$humidity%', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.air, color: Colors.blueAccent),
                    const SizedBox(height: 4),
                    Text('Wind', style: GoogleFonts.poppins(fontSize: 14)),
                    Text('${wind} m/s', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 