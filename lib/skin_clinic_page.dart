


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class SkinClinicPage extends StatefulWidget {
//   const SkinClinicPage({super.key});

//   @override
//   _SkinClinicPageState createState() => _SkinClinicPageState();
// }

// class _SkinClinicPageState extends State<SkinClinicPage> {
//   Position? _currentPosition;
//   List<dynamic> _clinics = [];
//   bool _isLoading = true;
//   bool _hasError = false;
//   String _searchQuery = "skin clinic";
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         _showError("Location services are disabled. Please enable GPS.");
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           _showError("Location permissions are required to find nearby clinics.");
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         _showError("Location permissions are permanently denied. Please enable them in app settings.");
//         return;
//       }

//       setState(() => _isLoading = true);
//       _currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );

//       if (_currentPosition != null) {
//         _fetchNearbyClinics();
//       } else {
//         _showError("Could not determine your current location. Please try again.");
//       }
//     } catch (e) {
//       _showError("An error occurred while getting your location: ${e.toString()}");
//     }
//   }

//   Future<void> _fetchNearbyClinics() async {
//     if (_currentPosition == null) return;

//     try {
//       final response = await http.get(Uri.parse(
//         "https://photon.komoot.io/api/?q=$_searchQuery&lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&limit=15",
//       ));

//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data["features"].isNotEmpty) {
//           setState(() {
//             _clinics = data["features"];
//             _isLoading = false;
//             _hasError = false;
//           });
//         } else {
//           _showError("No skin clinics found nearby. Try expanding your search area.");
//         }
//       } else {
//         _showError("Failed to load clinics. Server responded with status ${response.statusCode}");
//       }
//     } catch (e) {
//       _showError("Network error: ${e.toString()}");
//     }
//   }

  
// void _openGoogleMaps(double lat, double lon) async {
//   try {
//     final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
    
//     // Check if we can launch the URL
//     if (await canLaunchUrl(url)) {
//       final bool launched = await launchUrl(
//         url, 
//         mode: LaunchMode.externalApplication,
//       );
      
//       if (!launched) {
//         _showError("Could not launch Google Maps. Please check if the app is installed.");
//       }
//     } else {
//       // Try with a different URL format as fallback
//       final mapUrl = Uri.parse("geo:$lat,$lon?q=$lat,$lon");
//       if (await canLaunchUrl(mapUrl)) {
//         await launchUrl(mapUrl);
//       } else {
//         _showError("Could not launch map application. Please make sure you have a maps app installed.");
//       }
//     }
//   } catch (e) {
//     _showError("Error launching maps: ${e.toString()}");
//   }
// }
//   void _showError(String message) {
//     setState(() {
//       _isLoading = false;
//       _hasError = true;
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Theme.of(context).colorScheme.error,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           hintText: 'Search for clinics...',
//           prefixIcon: const Icon(Icons.search),
//           suffixIcon: IconButton(
//             icon: const Icon(Icons.clear),
//             onPressed: () {
//               _searchController.clear();
//               _searchQuery = "skin clinic";
//               _fetchNearbyClinics();
//             },
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.grey[200],
//           contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
//         ),
//         onSubmitted: (value) {
//           if (value.isNotEmpty) {
//             setState(() {
//               _searchQuery = value;
//               _isLoading = true;
//             });
//             _fetchNearbyClinics();
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildClinicCard(dynamic clinic) {
//     final name = clinic["properties"]["name"] ?? "Unnamed Clinic";
//     final city = clinic["properties"]["city"] ?? "Unknown location";
//     final street = clinic["properties"]["street"] ?? "";
//     final postcode = clinic["properties"]["postcode"] ?? "";
    
//     final coords = clinic["geometry"]["coordinates"];
//     final distance = _currentPosition != null 
//         ? Geolocator.distanceBetween(
//             _currentPosition!.latitude,
//             _currentPosition!.longitude,
//             coords[1],
//             coords[0],
//           ).round()
//         : null;

//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => _openGoogleMaps(coords[1], coords[0]),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.local_hospital, color: Theme.of(context).primaryColor),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               if (street.isNotEmpty || postcode.isNotEmpty || city.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(left: 36),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (street.isNotEmpty) Text(street),
//                       if (postcode.isNotEmpty || city.isNotEmpty)
//                         Text('$postcode $city'.trim()),
//                       if (distance != null)
//                         Padding(
//                           padding: const EdgeInsets.only(top: 8),
//                           child: Text(
//                             '${distance}m away',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               const SizedBox(height: 12),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: ElevatedButton.icon(
//                   icon: const Icon(Icons.directions, size: 18),
//                   label: const Text('Directions'),
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   ),
//                   onPressed: () => _openGoogleMaps(coords[1], coords[0]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Skin Clinics Nearby'),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               setState(() => _isLoading = true);
//               _getCurrentLocation();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildSearchBar(),
//           Expanded(
//             child: _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _hasError
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                             const SizedBox(height: 16),
//                             const Text(
//                               'Unable to load clinics',
//                               style: TextStyle(fontSize: 18),
//                             ),
//                             const SizedBox(height: 8),
//                             ElevatedButton(
//                               onPressed: _getCurrentLocation,
//                               child: const Text('Try Again'),
//                             ),
//                           ],
//                         ),
//                       )
//                     : _clinics.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.search_off, size: 48, color: Colors.grey),
//                                 const SizedBox(height: 16),
//                                 const Text(
//                                   'No clinics found',
//                                   style: TextStyle(fontSize: 18),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _searchQuery = "skin clinic";
//                                       _isLoading = true;
//                                     });
//                                     _fetchNearbyClinics();
//                                   },
//                                   child: const Text('Reset Search'),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : RefreshIndicator(
//                             onRefresh: _fetchNearbyClinics,
//                             child: ListView.builder(
//                               physics: const AlwaysScrollableScrollPhysics(),
//                               itemCount: _clinics.length,
//                               itemBuilder: (context, index) => _buildClinicCard(_clinics[index]),
//                             ),
//                           ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
  // Color scheme matching home page
  final Color _accentColor = const Color(0xFFCD853F); // Peru (warm orange-brown)
  final Color _backgroundColor = const Color(0xFFFAF9F6); // Off-white
  final Color _cardColor = Colors.white;
  final Color _textColor = const Color(0xFF5D4037); // Dark brown
  final Color _secondaryTextColor = const Color(0xFF8D6E63); // Lighter brown

  Position? _currentPosition;
  List<dynamic> _clinics = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _searchQuery = "skin clinic";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError("Location services are disabled. Please enable GPS.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError("Location permissions are required to find nearby clinics.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError("Location permissions are permanently denied. Please enable them in app settings.");
        return;
      }

      setState(() => _isLoading = true);
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      if (_currentPosition != null) {
        _fetchNearbyClinics();
      } else {
        _showError("Could not determine your current location. Please try again.");
      }
    } catch (e) {
      _showError("An error occurred while getting your location: ${e.toString()}");
    }
  }

  Future<void> _fetchNearbyClinics() async {
    if (_currentPosition == null) return;

    try {
      final response = await http.get(Uri.parse(
        "https://photon.komoot.io/api/?q=$_searchQuery&lat=${_currentPosition!.latitude}&lon=${_currentPosition!.longitude}&limit=15",
      ));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["features"].isNotEmpty) {
          setState(() {
            _clinics = data["features"];
            _isLoading = false;
            _hasError = false;
          });
        } else {
          _showError("No skin clinics found nearby. Try expanding your search area.");
        }
      } else {
        _showError("Failed to load clinics. Server responded with status ${response.statusCode}");
      }
    } catch (e) {
      _showError("Network error: ${e.toString()}");
    }
  }

  void _openGoogleMaps(double lat, double lon) async {
    try {
      final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
      
      if (await canLaunchUrl(url)) {
        final bool launched = await launchUrl(
          url, 
          mode: LaunchMode.externalApplication,
        );
        
        if (!launched) {
          _showError("Could not launch Google Maps. Please check if the app is installed.");
        }
      } else {
        final mapUrl = Uri.parse("geo:$lat,$lon?q=$lat,$lon");
        if (await canLaunchUrl(mapUrl)) {
          await launchUrl(mapUrl);
        } else {
          _showError("Could not launch map application. Please make sure you have a maps app installed.");
        }
      }
    } catch (e) {
      _showError("Error launching maps: ${e.toString()}");
    }
  }

  void _showError(String message) {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for clinics...',
          hintStyle: TextStyle(color: _secondaryTextColor.withOpacity(0.7)),
          prefixIcon: Icon(Icons.search, color: _accentColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: _accentColor),
                  onPressed: () {
                    _searchController.clear();
                    _searchQuery = "skin clinic";
                    _fetchNearbyClinics();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: _cardColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        style: TextStyle(color: _textColor),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            setState(() {
              _searchQuery = value;
              _isLoading = true;
            });
            _fetchNearbyClinics();
          }
        },
      ),
    );
  }

  Widget _buildClinicCard(dynamic clinic) {
    final name = clinic["properties"]["name"] ?? "Unnamed Clinic";
    final city = clinic["properties"]["city"] ?? "Unknown location";
    final street = clinic["properties"]["street"] ?? "";
    final postcode = clinic["properties"]["postcode"] ?? "";
    
    final coords = clinic["geometry"]["coordinates"];
    final distance = _currentPosition != null 
        ? Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            coords[1],
            coords[0],
          ).round()
        : null;

    final distanceInKm = distance != null ? (distance / 1000).toStringAsFixed(1) : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: _cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openGoogleMaps(coords[1], coords[0]),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.local_hospital, color: _accentColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                          if (street.isNotEmpty || postcode.isNotEmpty || city.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (street.isNotEmpty) 
                                    Text(
                                      street,
                                      style: TextStyle(
                                        color: _secondaryTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  if (postcode.isNotEmpty || city.isNotEmpty)
                                    Text(
                                      '$postcode $city'.trim(),
                                      style: TextStyle(
                                        color: _secondaryTextColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (distanceInKm != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$distanceInKm km',
                          style: TextStyle(
                            color: _accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 0,
                    ),
                    onPressed: () => _openGoogleMaps(coords[1], coords[0]),
                    child: const Text('Get Directions'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: _secondaryTextColor.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No clinics found',
            style: TextStyle(
              fontSize: 18,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              setState(() {
                _searchQuery = "skin clinic";
                _isLoading = true;
              });
              _fetchNearbyClinics();
            },
            child: const Text('Reset Search'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red[700]),
          const SizedBox(height: 16),
          Text(
            'Unable to load clinics',
            style: TextStyle(
              fontSize: 18,
              color: _textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: _getCurrentLocation,
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Skin Clinics Nearby',
          style: TextStyle(
            color: _textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _accentColor),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: _accentColor),
            onPressed: () {
              setState(() => _isLoading = true);
              _getCurrentLocation();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(color: _accentColor),
                  )
                : _hasError
                    ? _buildErrorState()
                    : _clinics.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                            color: _accentColor,
                            onRefresh: _fetchNearbyClinics,
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: _clinics.length,
                              itemBuilder: (context, index) => _buildClinicCard(_clinics[index]),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}