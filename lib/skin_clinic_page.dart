

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SkinClinicPage extends StatefulWidget {
  const SkinClinicPage({super.key});

  @override
  _SkinClinicPageState createState() => _SkinClinicPageState();
}

class _SkinClinicPageState extends State<SkinClinicPage> {
  Position? _currentPosition;
  List<dynamic> _clinics = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// ✅ **Get User Location with Proper Permissions**
  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError("⚠ GPS is turned off. Please enable it.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError("⚠ Location permission denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError("⚠ Location access is permanently denied. Enable it in settings.");
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (_currentPosition != null) {
        _fetchNearbyClinics();
      } else {
        _showError("⚠ Unable to determine location. Try again.");
      }
    } catch (e) {
      _showError("⚠ Error getting location: $e");
    }
  }

  /// ✅ **Fetch Nearby Skin Clinics Using Photon API**
  Future<void> _fetchNearbyClinics() async {
    if (_currentPosition == null) {
      _showError("⚠ Unable to fetch location.");
      return;
    }

    String query = "skin clinic";
    String url =
        "https://photon.komoot.io/api/?q=$query&lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&limit=10";

    print("🔍 Fetching clinics from: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("🔍 API Response: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data["features"].isNotEmpty) {
          setState(() {
            _clinics = data["features"];
            _isLoading = false;
            _hasError = false;
          });
        } else {
          _showError("⚠ No skin clinics found nearby. Try searching in another area.");
        }
      } else {
        _showError("⚠ API Error: ${response.statusCode}. Try again later.");
      }
    } catch (e) {
      _showError("⚠ Network error: $e");
    }
  }

  /// ✅ **Open Google Maps for Directions**
  void _openGoogleMaps(double lat, double lon) async {
    String googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$lon";
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      _showError("⚠ Could not open Google Maps.");
    }
  }

  /// ✅ **Show Error Message**
  void _showError(String message) {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Skin Clinics")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // ✅ Show loading indicator
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("⚠ Error loading clinics.", style: TextStyle(fontSize: 18, color: Colors.red)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _hasError = false;
                          });
                          _getCurrentLocation(); // ✅ Retry fetching location
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : _clinics.isEmpty
                  ? const Center(child: Text("⚠ No clinics found nearby.", style: TextStyle(fontSize: 18)))
                  : ListView.builder(
                      itemCount: _clinics.length,
                      itemBuilder: (context, index) {
                        var clinic = _clinics[index];
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: const Icon(Icons.local_hospital, color: Colors.red),
                            title: Text(
                              clinic["properties"]["name"] ?? "Unknown Clinic",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              clinic["properties"]["city"] ?? "Address not available",
                              style: const TextStyle(color: Colors.black54),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.map, color: Colors.blue),
                              onPressed: () => _openGoogleMaps(
                                double.parse(clinic["geometry"]["coordinates"][1].toString()),
                                double.parse(clinic["geometry"]["coordinates"][0].toString()),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
