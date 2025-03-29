




// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;
// import 'dart:math';


// class SkinDiseaseDetector {
//   Interpreter? _interpreter;
//   List<String> _labels = [];

//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset(
//         'assets/skinmate.tflite',
//         options: InterpreterOptions()..threads = 4,
//       );
      
//       final labelsData = await rootBundle.loadString('assets/labels.txt');
//       _labels = labelsData.split('\n');
//     } catch (e) {
//       print("Model loading error: $e");
//       throw Exception("Model initialization failed");
//     }
//   }

//   Future<Map<String, dynamic>> classifyImage(File imageFile) async {
//     if (_interpreter == null) await _loadModel();
    
//     try {
//       final imageBytes = await imageFile.readAsBytes();
//       final image = img.decodeImage(imageBytes);
//       if (image == null) return {'error': 'Image decoding failed'};

//       // Get pixel data correctly
//       final input = _processImage(image);
//       final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
      
//       _interpreter!.run(input, output);
      
//       final results = output[0];
//       final maxIndex = results.indexOf(results.reduce(max));
      
//       return {
//         'label': _labels[maxIndex],
//         'confidence': (results[maxIndex] * 100).toStringAsFixed(1),
//         'scores': List<double>.from(results)
//       };
//     } catch (e) {
//       return {'error': 'Classification failed: $e'};
//     }
//   }

//   /// Resize image to 224x224 and normalize pixel values
//   List<List<List<List<double>>>> _processImage(img.Image image) {
//   final resized = img.copyResize(image, width: 224, height: 224);
//   return List.generate(1, (_) {
//     return List.generate(224, (y) {
//       return List.generate(224, (x) {
//         final pixel = resized.getPixel(x, y); // Returns a Pixel object
//         return [
//           pixel.r / 255.0, // Corrected way to get red channel
//           pixel.g / 255.0, // Corrected way to get green channel
//           pixel.b / 255.0, // Corrected way to get blue channel
//         ];
//       });
//     });
//   });
// }


//   // Proper pixel value extraction methods
//   int _getRed(int pixel) => (pixel >> 16) & 0xFF;
//   int _getGreen(int pixel) => (pixel >> 8) & 0xFF;
//   int _getBlue(int pixel) => pixel & 0xFF;

//   void dispose() {
//     _interpreter?.close();
//   }
// }


import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class SkinDiseaseDetector {
  static const String _modelPath = 'assets/skinmate.tflite';
  static const String _labelsPath = 'assets/labels.txt';
  static const int _inputSize = 224;
  
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isModelLoaded = false;

  /// Loads the model and labels
  Future<void> loadModel() async {
    if (_isModelLoaded) return;
    
    try {
      // Load interpreter with optimizations
      final options = InterpreterOptions()
        ..threads = 4
        ..useNnApiForAndroid = true;
        
      _interpreter = await Interpreter.fromAsset(
        _modelPath,
        options: options,
      );
      
      // Load and parse labels
      final labelsData = await rootBundle.loadString(_labelsPath);
      _labels = labelsData.split('\n')
          .where((label) => label.trim().isNotEmpty)
          .toList();
      
      // Verify model compatibility with labels
      final outputTensor = _interpreter!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      
      if (outputShape[1] != _labels.length) {
        throw Exception('Model output (${outputShape[1]} classes) doesn\'t match labels (${_labels.length} classes)');
      }
      
      _isModelLoaded = true;
      print('Model and labels loaded successfully: ${_labels.join(", ")}');
    } catch (e) {
      print('Failed to load model or labels: $e');
      _isModelLoaded = false;
      _interpreter?.close();
      throw Exception('Model initialization failed: $e');
    }
  }

  /// Classifies an image file and returns the results
  Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    // Ensure model is loaded
    if (!_isModelLoaded) {
      try {
        await loadModel();
      } catch (e) {
        return {'error': 'Model initialization failed: $e'};
      }
    }
    
    try {
      // Read and decode image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        return {'error': 'Image decoding failed. Please try another image.'};
      }
      
      // Preprocess image
      final processedInput = _processImage(image);
      
      // Prepare output buffer
      final outputBuffer = List<List<double>>.filled(
        1,
        List<double>.filled(_labels.length, 0.0),
      );
      
      // Run inference
      _interpreter!.run(processedInput, outputBuffer);
      
      // Process results
      final results = outputBuffer[0];
      
      // Find the classification with highest confidence
      int maxIndex = 0;
      double maxValue = results[0];
      
      for (int i = 1; i < results.length; i++) {
        if (results[i] > maxValue) {
          maxValue = results[i];
          maxIndex = i;
        }
      }
      
      // Create standardized response
      return {
        'label': _labels[maxIndex],
        'confidence': (maxValue * 100).toStringAsFixed(1),
        'confidenceValue': maxValue,
        'allLabels': _labels,
        'allScores': List<double>.from(results),
        'success': true
      };
    } catch (e) {
      print('Classification error: $e');
      return {
        'error': 'Classification failed: $e',
        'success': false
      };
    }
  }

  /// Process image for the model input (resize and normalize)
  List<List<List<List<double>>>> _processImage(img.Image image) {
    // Resize image to expected dimensions
    final resized = img.copyResize(
      image,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.cubic
    );
    
    // Create a buffer for normalized RGB values - shape [1, 224, 224, 3]
    final inputBuffer = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (_) => List.generate(
          _inputSize,
          (_) => List<double>.filled(3, 0.0),
        ),
      ),
    );

    // Fill the buffer with normalized pixel values
    for (var y = 0; y < _inputSize; y++) {
      for (var x = 0; x < _inputSize; x++) {
        final pixel = resized.getPixel(x, y);
        // Normalize to 0-1 range
        inputBuffer[0][y][x][0] = pixel.r / 255.0;
        inputBuffer[0][y][x][1] = pixel.g / 255.0;
        inputBuffer[0][y][x][2] = pixel.b / 255.0;
      }
    }
    
    return inputBuffer;
  }
  
  /// Returns top N classifications with their scores
  List<Map<String, dynamic>> getTopNResults(List<double> scores, int n) {
    // Create list of (index, score) pairs
    List<MapEntry<int, double>> indexedScores = [];
    for (int i = 0; i < scores.length; i++) {
      indexedScores.add(MapEntry(i, scores[i]));
    }
    
    // Sort by score in descending order
    indexedScores.sort((a, b) => b.value.compareTo(a.value));
    
    // Take top N results
    final topN = indexedScores.take(math.min(n, scores.length));
    
    // Convert to readable format
    return topN.map((entry) => {
      'label': _labels[entry.key],
      'confidence': (entry.value * 100).toStringAsFixed(1),
      'score': entry.value
    }).toList();
  }

  /// Free resources when done
  void dispose() {
    _interpreter?.close();
    _isModelLoaded = false;
    print('SkinDiseaseDetector resources released');
  }
  
  /// Check if model is loaded
  bool get isModelLoaded => _isModelLoaded;
  
  /// Get the list of supported skin conditions
  List<String> get supportedConditions => List.from(_labels);
}