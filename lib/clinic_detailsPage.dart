import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClinicDetailsPage extends StatelessWidget {
  final String name;
  final String address;
  final String contact;
  final double lat;
  final double lon;

  const ClinicDetailsPage({
    super.key,
    required this.name,
    required this.address,
    required this.contact,
    required this.lat,
    required this.lon,
  });

  void _openGoogleMaps() async {
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      print("Could not open Google Maps.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name), backgroundColor: Colors.deepOrangeAccent),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🏥 Name: $name", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("📍 Address: $address", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("📞 Contact: $contact", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _openGoogleMaps,
                icon: const Icon(Icons.map),
                label: const Text("Open in Google Maps"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
