import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "YOUR_API_KEY"; // Replace with your OpenWeatherMap API Key
  final String city = "Trivandrum"; // Change to user’s location if available

  Future<Map<String, dynamic>> getWeatherData() async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
