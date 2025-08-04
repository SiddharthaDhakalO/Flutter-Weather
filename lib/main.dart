import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'weather_display.dart';
import 'forecast_graph.dart';
import 'seven_day_forecast.dart';
import 'aqi_section.dart';
import 'login_page.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dainik Mausam',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? weatherData;
  List<ForecastEntry> forecastData = [];
  List<DailyForecast> dailyForecasts = [];
  int? aqi;
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchWeather('Kathmandu,NP');
  }

  Future<void> fetchWeather(String city) async {
    setState(() {
      isLoading = true;
      error = null;
    });
    final apiKey = '6ad59723c08828d94598e25ca26486c6';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric';
    final forecastUrl =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));
      final forecastResponse = await http.get(Uri.parse(forecastUrl));
      if (response.statusCode == 200 && forecastResponse.statusCode == 200) {
        final weather = json.decode(response.body);
        final lat = weather['coord']['lat'];
        final lon = weather['coord']['lon'];
        // Fetch 7-day forecast
        final oneCallUrl = 'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts,current&appid=$apiKey&units=metric';
        final oneCallResp = await http.get(Uri.parse(oneCallUrl));
        // Fetch AQI
        final aqiUrl = 'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';
        final aqiResp = await http.get(Uri.parse(aqiUrl));
        setState(() {
          weatherData = weather;
          forecastData = parseForecast(json.decode(forecastResponse.body));
          dailyForecasts = oneCallResp.statusCode == 200 ? parseDailyForecasts(json.decode(oneCallResp.body)) : [];
          aqi = aqiResp.statusCode == 200 ? (json.decode(aqiResp.body)['list'][0]['main']['aqi'] as int) : null;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'City not found.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch weather.';
        isLoading = false;
      });
    }
  }

  List<ForecastEntry> parseForecast(Map<String, dynamic> data) {
    final List list = data['list'];
    return list.take(8).map((entry) {
      // 8 entries = 24 hours (3-hour intervals)
      return ForecastEntry(
        time: DateTime.parse(entry['dt_txt']),
        temp: (entry['main']['temp'] as num).toDouble(),
        icon: entry['weather'][0]['icon'],
      );
    }).toList();
  }

  List<DailyForecast> parseDailyForecasts(Map<String, dynamic> data) {
    final List days = data['daily'];
    return days.take(7).map<DailyForecast>((entry) {
      return DailyForecast(
        date: DateTime.fromMillisecondsSinceEpoch(entry['dt'] * 1000, isUtc: true),
        minTemp: (entry['temp']['min'] as num).toDouble(),
        maxTemp: (entry['temp']['max'] as num).toDouble(),
        icon: entry['weather'][0]['icon'],
      );
    }).toList();
  }

  Color _getGradientStart(String? main) {
    switch (main?.toLowerCase()) {
      case 'clear':
        return const Color(0xFFfceabb);
      case 'clouds':
        return const Color(0xFFa1c4fd);
      case 'rain':
      case 'drizzle':
        return const Color(0xFF89f7fe);
      case 'thunderstorm':
        return const Color(0xFF667db6);
      case 'snow':
        return const Color(0xFFe0eafc);
      default:
        return const Color(0xFFc2e9fb);
    }
  }

  Color _getGradientEnd(String? main) {
    switch (main?.toLowerCase()) {
      case 'clear':
        return const Color(0xFFf8b500);
      case 'clouds':
        return const Color(0xFFc2e9fb);
      case 'rain':
      case 'drizzle':
        return const Color(0xFF66a6ff);
      case 'thunderstorm':
        return const Color(0xFF0082c8);
      case 'snow':
        return const Color(0xFFcfdef3);
      default:
        return const Color(0xFFc2e9fb);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? mainWeather = weatherData != null ? weatherData!['weather'][0]['main'] as String? : null;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getGradientStart(mainWeather),
            _getGradientEnd(mainWeather),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Dainik Mausam',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextField(
                  controller: _controller,
                  style: GoogleFonts.poppins(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Enter city name',
                    hintStyle: GoogleFonts.poppins(color: Colors.black45),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black54),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          fetchWeather(_controller.text);
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      fetchWeather(value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
              if (error != null && !isLoading)
                Center(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
              if (weatherData != null && !isLoading && error == null) ...[
                WeatherDisplay(weatherData: weatherData!),
                const SizedBox(height: 24),
                if (forecastData.isNotEmpty)
                  ForecastGraph(forecastData: forecastData),
                if (dailyForecasts.isNotEmpty)
                  SevenDayForecast(dailyForecasts: dailyForecasts),
                if (aqi != null)
                  AQISection(aqi: aqi!),
              ],
              if (weatherData == null && !isLoading && error == null)
                Column(
                  children: [
                    Icon(Icons.cloud, size: 80, color: Colors.blue[200]),
                    const SizedBox(height: 16),
                    Text(
                      'Search for a city to see the weather!',
                      style: GoogleFonts.poppins(fontSize: 18, color: Colors.blueGrey),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
