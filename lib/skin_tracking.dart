
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'skin_tracking_service.dart';

class SkinTrackingPage extends StatefulWidget {
  const SkinTrackingPage({super.key});

  @override
  _SkinTrackingPageState createState() => _SkinTrackingPageState();
}

class _SkinTrackingPageState extends State<SkinTrackingPage> {
  final SkinTrackingService trackingService = SkinTrackingService();
  final ImagePicker _picker = ImagePicker();
  bool isUploading = false;
  String? predictionResult;
  File? _selectedImage;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        predictionResult = null;
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
        predictionResult = null;
      });
    }
  }
Future<void> uploadImage(String userId) async {
  if (_selectedImage == null) return;

  setState(() {
    isUploading = true;
  });

  try {
    // Changed from uploadImage to predictImage
    String prediction = await trackingService.predictImage(_selectedImage!);
    
    setState(() {
      predictionResult = prediction;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Prediction: $prediction")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  } finally {
    setState(() {
      isUploading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skin Tracking"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Column(
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        ),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text("Change Image"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => setState(() => _selectedImage = null),
                          child: const Text("Remove"),
                        ),
                      ],
                    ),
                  ]
                )
              else
                Column(
                  children: [
                    const Text(
                      "Select an image of your skin condition",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _takePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Take Photo"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.photo_library),
                          label: const Text("From Gallery"),
                        ),
                      ],
                    ),
                  ],
                ),
              
              const SizedBox(height: 32),
              
              if (_selectedImage != null)
                ElevatedButton.icon(
                  onPressed: isUploading ? null : () => uploadImage("userId"),
                  icon: const Icon(Icons.upload),
                  label: const Text("Analyze Skin Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              
              if (isUploading) 
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              
              if (predictionResult != null) 
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Analysis Result:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        predictionResult!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}