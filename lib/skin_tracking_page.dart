// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:image/image.dart' as img;
// // import 'package:tflite_flutter/tflite_flutter.dart';

// // class SkinTrackingPage extends StatefulWidget {
// //   @override
// //   _SkinTrackingPageState createState() => _SkinTrackingPageState();
// // }

// // class _SkinTrackingPageState extends State<SkinTrackingPage> {
// //   Interpreter? _interpreter;
// //   String _result = "No prediction yet";
// //   File? _image;
// //   bool _isModelLoaded = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadModel();
// //   }

// //   Future<void> loadModel() async {
// //     try {
// //       print("------->");
// //       _interpreter = await Interpreter.fromAsset('assets/skinmate.tflite');
// //       setState(() {
// //         _isModelLoaded = true;
// //       });
// //       print('✅ Model loaded successfully');
// //     } catch (e, stacktrace) {
// //       print(stacktrace);
// //       print('❌ Failed to load model: $e');
// //     }
// //   }

// //   Future<void> pickImage() async {
// //     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
// //     print("-------------------------------------> $pickedFile✅");
// //     if (pickedFile != null) {
// //       setState(() {
// //         _image = File(pickedFile.path);
// //       });
// //     }
// //   }

// //   Future<void> runInference() async {
// //     if (!_isModelLoaded) {
// //       setState(() {
// //         _result = "Model not loaded. Try again.";
// //       });
// //       print("⚠️ Model not loaded. Cannot run inference.");
// //       return;
// //     }

// //     if (_image == null) {
// //       setState(() {
// //         _result = "Please upload an image first";
// //       });
// //       return;
// //     }

// //     img.Image? imageInput = img.decodeImage(await _image!.readAsBytes());

// //     if (imageInput == null) {
// //       setState(() {
// //         _result = "Error processing image";
// //       });
// //       return;
// //     }
      


// //     // check

// //     img.Image resizedImage = img.copyResize(imageInput, width: 224, height: 224);
// //     print("+++++++++++++++++++ $resizedImage");
    



// // List<List<List<double>>> inputBuffer = List.generate(
// //   224,
// //   (y) => List.generate(
// //     224,
// //     (x) {
// //       int color = resizedImage.getPixelSafe(x, y) as int; // Safe pixel retrieval
// //       print("*******$color");
// //       return [
// //         ((color >> 16) & 0xFF) / 255.0, // Red
// //         ((color >> 8) & 0xFF) / 255.0,  // Green
// //         (color & 0xFF) / 255.0,         // Blue
// //       ];
// //     },
// //   ),
// // );

// // // Ensure output matches the expected tensor format
// // List<List<double>> output = List.generate(1, (_) => List.filled(1, 0.0));



// //       print("#####################################😊😊😊😊❤️");
// //     try {
// //       _interpreter!.run([inputBuffer], output);
// //       setState(() {
// //         _result = "Prediction: ${output[0]}";
// //       });
// //       print('✅ Inference result: $_result');
// //     } catch (e) {
// //       print('❌ Error running inference: $e');
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _interpreter?.close();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text("Skin Tracking")),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           _image != null ? Image.file(_image!) : Placeholder(fallbackHeight: 200, fallbackWidth: 200),
// //           SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: pickImage,
// //             child: Text("Pick Image"),
// //           ),
// //           SizedBox(height: 10),
// //           ElevatedButton(
// //             onPressed: runInference,
// //             child: Text("Run Inference"),
// //           ),
// //           SizedBox(height: 20),
// //           Text(
// //             _result,
// //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tflite;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class SkinAnalysisPage extends StatefulWidget {
  const SkinAnalysisPage({super.key});

  @override
  _SkinAnalysisPageState createState() => _SkinAnalysisPageState();
}

class _SkinAnalysisPageState extends State<SkinAnalysisPage> {
  File? _image;
  bool _isAnalyzing = false;
  bool _isModelLoaded = false;
  String _result = '';
  List<Map<String, dynamic>> _analysisResults = [];
  late tflite.Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      final options = tflite.InterpreterOptions();
      _interpreter = await tflite.Interpreter.fromAsset(
        'assets/skinmate.tflite',
        options: options,
      );
      _logModelDetails();
      setState(() => _isModelLoaded = true);
      print('✅ Model loaded successfully');
    } catch (e) {
      print('❌ Failed to load model: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load model. Please try again.')),
        );
      }
    }
  }

  void _logModelDetails() {
    print('Model Input Details:');
    for (var tensor in _interpreter.getInputTensors()) {
      print('Name: ${tensor.name}, Shape: ${tensor.shape}, Type: ${tensor.type}');
    }
    print('\nModel Output Details:');
    for (var tensor in _interpreter.getOutputTensors()) {
      print('Name: ${tensor.name}, Shape: ${tensor.shape}, Type: ${tensor.type}');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          _image = File(pickedFile.path);
          _result = '';
          _analysisResults = [];
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selection failed: ${e.toString()}')),
        );
      }
    }
  }
Future<void> _analyzeImage() async {
  if (!_isModelLoaded || _image == null) return;

  setState(() {
    _isAnalyzing = true;
    _result = 'Analyzing...';
    _analysisResults = [];
  });

  try {
    // 1. Load and decode image
    final imageBytes = await _image!.readAsBytes();
    final image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // 2. Get model input specifications
    final inputTensor = _interpreter.getInputTensors().first;
    final inputShape = inputTensor.shape;
   // final inputType = _convertToTfLiteType(inputTensor.type);

    // 3. Resize and preprocess image
    final processedImage = _preprocessImage(image, inputShape, inputType);

    // 4. Prepare output buffer
    final outputTensor = _interpreter.getOutputTensors().first;
    final outputBuffer = _createOutputBuffer(outputTensor);

    // 5. Run inference
    _interpreter.run(processedImage, outputBuffer);

    // 6. Process results
    _processResults(outputBuffer);
  } catch (e) {
    print('❌ Analysis error: $e');
    if (mounted) {
      setState(() {
        _result = 'Analysis failed';
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis error: ${e.toString()}')),
      );
    }
  }
}

// Helper function to convert TensorType to TfLiteType
// tflite.TfLiteType _convertToTfLiteType(TensorType tensorType) {
//   switch (tensorType) {
//     case TensorType.float32:
//       return tflite.TfLiteType.kTfLiteFloat32;
//     case TensorType.uint8:
//       return tflite.TfLiteType.kTfLiteUInt8;
//     case TensorType.int8:
//       return tflite.TfLiteType.kTfLiteInt8;
//     case TensorType.int32:
//       return tflite.TfLiteType.kTfLiteInt32;
//     case TensorType.int64:
//       return tflite.TfLiteType.kTfLiteInt64;
//     case TensorType.string:
//       return tflite.TfLiteType.kTfLiteString;
//     // case TensorType.boolean:
//     //   return tflite.TfLiteType.kTfLiteBool;
//     default:
//       throw Exception('Unsupported tensor type: $tensorType');
//   }
// }
  dynamic _preprocessImage(img.Image image, List<int> inputShape, tflite.TfLiteType inputType) {
    final height = inputShape[1];
    final width = inputShape[2];
    final resizedImage = img.copyResize(image, width: width, height: height);

    if (inputType == tflite.TfLiteType.kTfLiteFloat32) {
      return _prepareFloatInput(resizedImage, mean: 127.5, std: 127.5);
    } else if (inputType == tflite.TfLiteType.kTfLiteUInt8) {
      return _prepareUint8Input(resizedImage);
    }
    throw Exception('Unsupported input type: $inputType');
  }

  Uint8List _prepareFloatInput(img.Image image, {double mean = 127.5, double std = 127.5}) {
    final buffer = Float32List(1 * image.height * image.width * 3);
    int index = 0;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        buffer[index++] = (pixel.r - mean) / std;
        buffer[index++] = (pixel.g - mean) / std;
        buffer[index++] = (pixel.b - mean) / std;
      }
    }
    return buffer.buffer.asUint8List();
  }

  Uint8List _prepareUint8Input(img.Image image) {
    final buffer = Uint8List(1 * image.height * image.width * 3);
    int index = 0;
    
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        buffer[index++] = pixel.r as int;
        buffer[index++] = pixel.g as int;
        buffer[index++] = pixel.b as int;
      }
    }
    return buffer;
  }

  List<dynamic> _createOutputBuffer(tflite.Tensor outputTensor) {
    final outputSize = outputTensor.shape.reduce((a, b) => a * b);
    return List.filled(outputSize, 0.0).reshape(outputTensor.shape);
  }

  void _processResults(List<dynamic> output) {
    // Adjust these labels to match your model's output classes
    const labels = ['Acne', 'Eczema', 'Melanoma', 'Psoriasis', 'Healthy'];
    final results = output is List<List<dynamic>> ? output[0] : output;

    if (mounted) {
      setState(() {
        _analysisResults = List.generate(
          min(labels.length, results.length),
          (i) => {
            'condition': labels[i],
            'confidence': (results[i] * 100).toStringAsFixed(2),
          },
        )..sort((a, b) => double.parse(b['confidence']).compareTo(double.parse(a['confidence'])));

        _result = 'Analysis Complete';
        _isAnalyzing = false;
      });
    }
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skin Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: _image == null
                  ? _buildPlaceholder()
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 16),
            
            // Image selection buttons
            _buildImageSourceButtons(),
            const SizedBox(height: 24),
            
            // Analysis button
            _buildAnalyzeButton(),
            const SizedBox(height: 24),
            
            // Results display
            if (_result.isNotEmpty) _buildResultsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'No image selected',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSourceButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: _image == null || _isAnalyzing || !_isModelLoaded 
          ? null 
          : _analyzeImage,
      child: _isAnalyzing
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'ANALYZE IMAGE',
              style: TextStyle(fontSize: 16),
            ),
    );
  }

  Widget _buildResultsCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _result,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_analysisResults.isNotEmpty)
              ..._analysisResults.map((result) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result['condition'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: double.parse(result['confidence']) / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getConfidenceColor(double.parse(result['confidence']))),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${result['confidence']}%'),
                      ],
                    ),
                  ],
                ),
              )),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence > 70) return Colors.green;
    if (confidence > 40) return Colors.orange;
    return Colors.red;
  }
}