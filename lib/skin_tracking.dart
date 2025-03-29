

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
//   final _service = SkinTrackingService();
//   final _picker = ImagePicker();
//   File? _selectedImage;
//   String? _prediction;
//   String? _error;
//   bool _isLoading = false;
//   bool _isModelLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeModelWithRetry();
//   }

//   Future<void> _initializeModelWithRetry({int retries = 3}) async {
//     for (int attempt = 1; attempt <= retries; attempt++) {
//       setState(() {
//         _isModelLoading = true;
//         _error = null;
//       });

//       try {
//         await _service.loadModel();
//         setState(() => _isModelLoading = false);
//         return; // Success
//       } catch (e) {
//         setState(() => _error = 'Attempt $attempt/$retries: ${e.toString()}');
//         if (attempt < retries) await Future.delayed(const Duration(seconds: 1));
//       } finally {
//         setState(() => _isModelLoading = false);
//       }
//     }

//     setState(() => _error = 'Failed to load model after $retries attempts');
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final image = await _picker.pickImage(source: source);
//       if (image != null) {
//         setState(() {
//           _selectedImage = File(image.path);
//           _prediction = null;
//           _error = null;
//         });
//       }
//     } catch (e) {
//       setState(() => _error = 'Image selection failed: ${e.toString()}');
//     }
//   }

//   Future<void> _analyzeImage() async {
//     if (_selectedImage == null) return;
    
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       final result = await _service.predictImage(_selectedImage!);
//       setState(() => _prediction = result);
//     } catch (e) {
//       setState(() => _error = 'Analysis failed: ${e.toString()}');
//       // Attempt to reload model if prediction failed
//       if (e.toString().contains('not loaded')) {
//         await _initializeModelWithRetry();
//       }
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     _service.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Skin Analysis'),
//         backgroundColor: Colors.deepOrangeAccent,
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     if (_error != null) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 _error!,
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _initializeModelWithRetry,
//                 child: const Text('Retry Loading Model'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Stack(
//       children: [
//         SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               if (_isModelLoading)
//                 const LinearProgressIndicator()
//               else if (_selectedImage != null)
//                 _buildImagePreview()
//               else
//                 _buildImageSelection(),
              
//               if (_isLoading)
//                 const Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: CircularProgressIndicator(),
//                 ),
              
//               if (_prediction != null)
//                 _buildResult(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildImagePreview() {
//     return Column(
//       children: [
//         Container(
//           height: 300,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             image: DecorationImage(
//               image: FileImage(_selectedImage!),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               child: const Text('Change Image'),
//             ),
//             const SizedBox(width: 16),
//             ElevatedButton(
//               onPressed: () => setState(() => _selectedImage = null),
//               child: const Text('Remove'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 32),
//         ElevatedButton.icon(
//           onPressed: _isLoading ? null : _analyzeImage,
//           icon: const Icon(Icons.analytics),
//           label: const Text('Analyze Skin Image'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.deepOrangeAccent,
//             foregroundColor: Colors.white,
//             minimumSize: const Size(200, 50),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildImageSelection() {
//     return Column(
//       children: [
//         const Text(
//           'Select an image of your skin condition',
//           style: TextStyle(fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 24),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.camera),
//               icon: const Icon(Icons.camera_alt),
//               label: const Text('Camera'),
//             ),
//             const SizedBox(width: 16),
//             ElevatedButton.icon(
//               onPressed: () => _pickImage(ImageSource.gallery),
//               icon: const Icon(Icons.photo_library),
//               label: const Text('Gallery'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildResult() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           const Text(
//             'Analysis Result:',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _prediction!,
//             style: const TextStyle(fontSize: 16),
//             textAlign: TextAlign.center,
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
  int _currentAttempt = 0;
  final int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    if (_isModelLoading) return; // Prevent multiple simultaneous loading attempts
    
    setState(() {
      _isModelLoading = true;
      _error = null;
      _currentAttempt++;
    });

    try {
      // Make sure to reset the service before loading a new model
      if (_currentAttempt > 1) {
        _service.dispose();
      }
      
      await _service.loadModel();
      setState(() {
        _isModelLoading = false;
        _currentAttempt = 0; // Reset attempt counter on success
      });
    } catch (e) {
      setState(() {
        _isModelLoading = false;
        _error = 'Attempt $_currentAttempt/$_maxRetries: ${e.toString()}';
      });
      
      if (_currentAttempt < _maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
        await _loadModel(); // Recursively retry
      } else {
        setState(() {
          _error = 'Failed to load model after $_maxRetries attempts';
          _currentAttempt = 0; // Reset counter for the next manual retry
        });
      }
    }
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
      // Reset the model if prediction failed due to model issues
      if (e.toString().contains('not loaded') || e.toString().contains('interpreter')) {
        _currentAttempt = 0; // Reset counter before loading again
        await _loadModel();
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
                onPressed: () {
                  _currentAttempt = 0; // Reset attempt counter before retry
                  _loadModel();
                },
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