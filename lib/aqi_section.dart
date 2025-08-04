import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AQISection extends StatelessWidget {
  final int aqi;
  const AQISection({super.key, required this.aqi});

  Color get aqiColor {
    if (aqi == 1) return Colors.green;
    if (aqi == 2) return Colors.yellow;
    if (aqi == 3) return Colors.orange;
    if (aqi == 4) return Colors.red;
    return Colors.purple;
  }

  String get aqiText {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [aqiColor.withOpacity(0.7), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(Icons.air, color: aqiColor, size: 48),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Air Quality Index', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  'AQI: $aqi ($aqiText)',
                  style: GoogleFonts.poppins(fontSize: 16, color: aqiColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 