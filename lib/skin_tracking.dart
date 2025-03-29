

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'skin_tracking_service.dart';

// class SkinTrackingPage extends StatefulWidget {
//   const SkinTrackingPage({super.key});

//   @override
//   _SkinTrackingPageState createState() => _SkinTrackingPageState();
// }

// class _SkinTrackingPageState extends State<SkinTrackingPage> {
//   final SkinTrackingService trackingService = SkinTrackingService();
//   final ImagePicker _picker = ImagePicker();
//   bool isUploading = false;
//   bool isModelLoading = false;
//   String? predictionResult;
//   String? _errorMessage;
//   File? _selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadModelWithRetry();
//     });
//   }

//   Future<void> _loadModelWithRetry({int retries = 3}) async {
//     setState(() {
//       isModelLoading = true;
//       _errorMessage = null;
//     });

//     for (int i = 0; i < retries; i++) {
//       try {
//         await trackingService.loadModel();
//         setState(() => isModelLoading = false);
//         return;
//       } catch (e) {
//         if (i == retries - 1) {
//           setState(() {
//             _errorMessage = "Failed to load model after $retries attempts";
//             isModelLoading = false;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(_errorMessage!)),
//           );
//         }
//         await Future.delayed(const Duration(seconds: 1));
//       }
//     }
//   }

//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//           predictionResult = null;
//           _errorMessage = null;
//         });
//       }
//     } catch (e) {
//       setState(() => _errorMessage = "Failed to pick image: ${e.toString()}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_errorMessage!)),
//       );
//     }
//   }

//   Future<void> _takePhoto() async {
//     try {
//       final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
//       if (photo != null) {
//         setState(() {
//           _selectedImage = File(photo.path);
//           predictionResult = null;
//           _errorMessage = null;
//         });
//       }
//     } catch (e) {
//       setState(() => _errorMessage = "Failed to take photo: ${e.toString()}");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(_errorMessage!)),
//       );
//     }
//   }

//   Future<void> uploadImage() async {
//     if (_selectedImage == null) return;
    
//     try {
//       setState(() {
//         isUploading = true;
//         _errorMessage = null;
//       });
      
//       final prediction = await trackingService.predictImage(_selectedImage!);
//       setState(() => predictionResult = prediction);
      
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Prediction: $prediction")),
//       );
//     } catch (e) {
//       setState(() => _errorMessage = e.toString());
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: $_errorMessage")),
//       );
//     } finally {
//       setState(() => isUploading = false);
//     }
//   }

//   @override
//   void dispose() {
//     trackingService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Skin Tracking"),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Error message display
//                   if (_errorMessage != null)
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 16.0),
//                       child: Text(
//                         _errorMessage!,
//                         style: const TextStyle(color: Colors.red, fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),

//                   // Model loading indicator
//                   if (isModelLoading)
//                     const LinearProgressIndicator(),

//                   // Main content
//                   if (!isModelLoading && _selectedImage != null)
//                     Column(
//                       children: [
//                         Container(
//                           height: 300,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(12),
//                             child: Image.file(_selectedImage!, fit: BoxFit.cover),
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton(
//                               onPressed: _pickImage,
//                               child: const Text("Change Image"),
//                             ),
//                             const SizedBox(width: 16),
//                             ElevatedButton(
//                               onPressed: () => setState(() => _selectedImage = null),
//                               child: const Text("Remove"),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 32),
//                         ElevatedButton.icon(
//                           onPressed: isUploading ? null : uploadImage,
//                           icon: const Icon(Icons.upload),
//                           label: const Text("Analyze Skin Image"),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.deepOrangeAccent,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 20, 
//                               vertical: 12),
//                           ),
//                         ),
//                       ],
//                     )
//                   else if (!isModelLoading)
//                     Column(
//                       children: [
//                         const Text(
//                           "Select an image of your skin condition",
//                           style: TextStyle(fontSize: 16),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 24),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             ElevatedButton.icon(
//                               onPressed: _takePhoto,
//                               icon: const Icon(Icons.camera_alt),
//                               label: const Text("Take Photo"),
//                             ),
//                             const SizedBox(width: 16),
//                             ElevatedButton.icon(
//                               onPressed: _pickImage,
//                               icon: const Icon(Icons.photo_library),
//                               label: const Text("From Gallery"),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),

//                   // Uploading indicator
//                   if (isUploading)
//                     const Padding(
//                       padding: EdgeInsets.all(16.0),
//                       child: CircularProgressIndicator(),
//                     ),

//                   // Prediction result
//                   if (predictionResult != null)
//                     Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         children: [
//                           const Text(
//                             "Analysis Result:",
//                             style: TextStyle(
//                               fontSize: 18, 
//                               fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             predictionResult!,
//                             style: const TextStyle(fontSize: 16),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
  final _service = SkinTrackingService();
  final _picker = ImagePicker();
  File? _selectedImage;
  String? _prediction;
  String? _error;
  bool _isLoading = false;
  bool _isModelLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeModelWithRetry();
  }

  Future<void> _initializeModelWithRetry({int retries = 3}) async {
    for (int attempt = 1; attempt <= retries; attempt++) {
      setState(() {
        _isModelLoading = true;
        _error = null;
      });

      try {
        await _service.loadModel();
        setState(() => _isModelLoading = false);
        return; // Success
      } catch (e) {
        setState(() => _error = 'Attempt $attempt/$retries: ${e.toString()}');
        if (attempt < retries) await Future.delayed(const Duration(seconds: 1));
      } finally {
        setState(() => _isModelLoading = false);
      }
    }

    setState(() => _error = 'Failed to load model after $retries attempts');
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _prediction = null;
          _error = null;
        });
      }
    } catch (e) {
      setState(() => _error = 'Image selection failed: ${e.toString()}');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _service.predictImage(_selectedImage!);
      setState(() => _prediction = result);
    } catch (e) {
      setState(() => _error = 'Analysis failed: ${e.toString()}');
      // Attempt to reload model if prediction failed
      if (e.toString().contains('not loaded')) {
        await _initializeModelWithRetry();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Analysis'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeModelWithRetry,
                child: const Text('Retry Loading Model'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_isModelLoading)
                const LinearProgressIndicator()
              else if (_selectedImage != null)
                _buildImagePreview()
              else
                _buildImageSelection(),
              
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              
              if (_prediction != null)
                _buildResult(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(_selectedImage!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Change Image'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => setState(() => _selectedImage = null),
              child: const Text('Remove'),
            ),
          ],
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _analyzeImage,
          icon: const Icon(Icons.analytics),
          label: const Text('Analyze Skin Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            foregroundColor: Colors.white,
            minimumSize: const Size(200, 50),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSelection() {
    return Column(
      children: [
        const Text(
          'Select an image of your skin condition',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Analysis Result:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _prediction!,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}