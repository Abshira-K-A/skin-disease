

// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// class SkinTrackingService {
//   static const String _modelPath = 'assets/skinmate.tflite';
//   static const int _inputSize = 224;
//   static const List<String> _labels = ['blackheads', 'Acne', 'wrinkles', 'darkspots'];
  
//   Interpreter? _interpreter;
//   bool _isModelLoaded = false;

//   Future<void> loadModel() async {
//     try {
//       // Close previous interpreter if exists
//       _interpreter?.close();
      
//       // Load with NNAPI acceleration
//       final options = InterpreterOptions()
//         ..threads = 4
//         ..useNnApiForAndroid = true;

//       _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
      
//       // Verify model input shape
//       final inputTensor = _interpreter!.getInputTensor(0);
//       if (inputTensor.shape[0] != 1 || 
//           inputTensor.shape[1] != _inputSize || 
//           inputTensor.shape[2] != _inputSize || 
//           inputTensor.shape[3] != 3) {
//         throw Exception('Model expects input shape [1,224,224,3] but got ${inputTensor.shape}');
//       }

//       // Verify output shape matches our labels
//       final outputTensor = _interpreter!.getOutputTensor(0);
//       if (outputTensor.shape[0] != 1 || outputTensor.shape[1] != _labels.length) {
//         throw Exception('Model expects output shape [1,${_labels.length}] but got ${outputTensor.shape}');
//       }

//       _isModelLoaded = true;
//     } catch (e) {
//       _isModelLoaded = false;
//       _interpreter?.close();
//       rethrow;
//     }
//   }

//   Future<String> predictImage(File image) async {
//     if (!_isModelLoaded || _interpreter == null) {
//       throw Exception('Model not loaded. Call loadModel() first');
//     }

//     try {
//       // Load and preprocess image
//       final imageBytes = await image.readAsBytes();
//       final decodedImage = img.decodeImage(imageBytes);
//       if (decodedImage == null) throw Exception('Failed to decode image');
      
//       // Resize with proper interpolation
//       final resizedImage = img.copyResize(
//         decodedImage,
//         width: _inputSize,
//         height: _inputSize,
//         interpolation: img.Interpolation.cubic
//       );

//       // Convert to exactly [1,224,224,3] shape
//       final input = _convertToModelInput(resizedImage);
//       final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

//       // Run prediction
//       _interpreter!.run(input, output);

//       // Interpret results
//       return _interpretResult(output[0]);
//     } catch (e) {
//       throw Exception('Prediction failed: $e');
//     }
//   }

//   List<List<List<List<double>>>> _convertToModelInput(img.Image image) {
//   // Create a properly typed 4D list
//   final input = List<List<List<List<double>>>>.filled(
//     1,
//     List<List<List<double>>>.filled(
//       _inputSize,
//       List<List<double>>.filled(
//         _inputSize,
//         List<double>.filled(3, 0.0),
//       ),
//     ),
//   );

//   for (var y = 0; y < _inputSize; y++) {
//     for (var x = 0; x < _inputSize; x++) {
//       final pixel = image.getPixel(x, y);
//       input[0][y][x][0] = pixel.r / 255.0; // R channel
//       input[0][y][x][1] = pixel.g / 255.0; // G channel
//       input[0][y][x][2] = pixel.b / 255.0; // B channel
//     }
//   }
//   return input;
// }

//   String _interpretResult(List<double> output) {
//     final maxIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));
//     final confidence = (output[maxIndex] * 100).toStringAsFixed(1);
//     return '${_labels[maxIndex]} ($confidence% confidence)';
//   }

//   void dispose() {
//     _interpreter?.close();
//     _isModelLoaded = false;
//   }
// }

// // import 'dart:io';
// // import 'package:image/image.dart' as img;
// // import 'package:tflite_flutter/tflite_flutter.dart';

// // class SkinTrackingService {
// //   static const String _modelPath = 'assets/skinmate.tflite';
// //   static const int _inputSize = 224;
// //   static const List<String> _labels = ['blackheads', 'Acne', 'wrinkles', 'darkspots'];
  
// //   Interpreter? _interpreter;
// //   bool _isModelLoaded = false;

// //   Future<void> loadModel() async {
// //     try {
// //       // Close previous interpreter if exists
// //       _interpreter?.close();
      
// //       // First try with NNAPI
// //       try {
// //         final options = InterpreterOptions()
// //           ..threads = 4
// //           ..useNnApiForAndroid = true;
// //         _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
// //       } catch (e) {
// //         // If NNAPI fails, fall back to CPU
// //         print("NNAPI failed, falling back to CPU: $e");
// //         final options = InterpreterOptions()..threads = 4;
// //         _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
// //       }
      
// //       // Verify model is loaded correctly
// //       if (_interpreter == null) {
// //         throw Exception("Failed to initialize interpreter");
// //       }
      
// //       // Log model details for debugging
// //       print("Model loaded. Input: ${_interpreter!.getInputTensor(0).shape}");
// //       print("Model output: ${_interpreter!.getOutputTensor(0).shape}");
      
// //       _isModelLoaded = true;
// //     } catch (e) {
// //       _isModelLoaded = false;
// //       _interpreter?.close();
// //       print("Model loading error: $e");
// //       rethrow;
// //     }
// //   }

// //   Future<String> predictImage(File image) async {
// //     if (!_isModelLoaded || _interpreter == null) {
// //       throw Exception('Model not loaded. Call loadModel() first');
// //     }
    
// //     try {
// //       // Load and preprocess image
// //       final imageBytes = await image.readAsBytes();
// //       img.Image? decodedImage = img.decodeImage(imageBytes);
      
// //       if (decodedImage == null) {
// //         throw Exception('Failed to decode image');
// //       }
      
// //       // Handle images with different orientations
// //       decodedImage = img.bakeOrientation(decodedImage);
      
// //       // Resize with proper interpolation
// //       final resizedImage = img.copyResize(
// //         decodedImage,
// //         width: _inputSize,
// //         height: _inputSize,
// //         interpolation: img.Interpolation.cubic
// //       );
      
// //       // Convert to input for model
// //       final input = _preprocessImage(resizedImage);
      
// //       // Prepare output tensor
// //       final output = List<List<double>>.filled(
// //         1, 
// //         List<double>.filled(_labels.length, 0)
// //       );
      
// //       // Run inference
// //       _interpreter!.run(input, output);
      
// //       // Process results
// //       return _interpretResult(output[0]);
// //     } catch (e) {
// //       print("Prediction error: $e");
// //       throw Exception('Prediction failed: $e');
// //     }
// //   }

// //   List<List<List<List<double>>>> _preprocessImage(img.Image image) {
// //     final input = List.generate(
// //       1,
// //       (_) => List.generate(
// //         _inputSize,
// //         (_) => List.generate(
// //           _inputSize,
// //           (_) => List.filled(3, 0.0),
// //         ),
// //       ),
// //     );
    
// //     for (int y = 0; y < _inputSize; y++) {
// //       for (int x = 0; x < _inputSize; x++) {
// //         final pixel = image.getPixel(x, y);
        
// //         // Extract RGB values - handle different image package versions
// //         int r, g, b;
// //         if (pixel is int) {
// //           // For newer image package versions
// //           r = (pixel >> 16) & 0xFF;
// //           g = (pixel >> 8) & 0xFF;
// //           b = pixel & 0xFF;
// //         } else {
// //           // For older package versions
// //           r = pixel.r;
// //           g = pixel.g;
// //           b = pixel.b;
// //         }
        
// //         // Normalize to [0, 1]
// //         input[0][y][x][0] = r / 255.0;
// //         input[0][y][x][1] = g / 255.0;
// //         input[0][y][x][2] = b / 255.0;
// //       }
// //     }
    
// //     return input;
// //   }

// //   String _interpretResult(List<double> output) {
// //     // Find index with highest probability
// //     int maxIndex = 0;
// //     double maxValue = output[0];
    
// //     for (int i = 1; i < output.length; i++) {
// //       if (output[i] > maxValue) {
// //         maxValue = output[i];
// //         maxIndex = i;
// //       }
// //     }
    
// //     final confidence = (maxValue * 100).toStringAsFixed(1);
// //     return '${_labels[maxIndex]} (${confidence}% confidence)';
// //   }

// //   void dispose() {
// //     _interpreter?.close();
// //     _isModelLoaded = false;
// //   }
// // }

import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class SkinTrackingService {
  static const String _modelPath = 'assets/skinmate.tflite';
  static const int _inputSize = 224;
  static const List<String> _labels = ['blackheads', 'Acne', 'wrinkles', 'darkspots'];
  
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  /// Loads the TensorFlow Lite model from assets
  Future<void> loadModel() async {
    try {
      // Close previous interpreter if exists
      _interpreter?.close();
      
      // Load with NNAPI acceleration
      final options = InterpreterOptions()
        ..threads = 4
        ..useNnApiForAndroid = true;

      _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
      
      // Verify model input shape
      final inputTensor = _interpreter!.getInputTensor(0);
      final inputShape = inputTensor.shape;
      if (inputShape.length != 4 || 
          inputShape[0] != 1 || 
          inputShape[1] != _inputSize || 
          inputShape[2] != _inputSize || 
          inputShape[3] != 3) {
        throw Exception('Model expects input shape [1,224,224,3] but got $inputShape');
      }

      // Verify output shape matches our labels
      final outputTensor = _interpreter!.getOutputTensor(0);
      final outputShape = outputTensor.shape;
      if (outputShape.length != 2 ||
          outputShape[0] != 1 || 
          outputShape[1] != _labels.length) {
        throw Exception('Model expects output shape [1,${_labels.length}] but got $outputShape');
      }

      _isModelLoaded = true;
      print('Model loaded successfully');
    } catch (e) {
      _isModelLoaded = false;
      _interpreter?.close();
      print('Failed to load model: $e');
      rethrow;
    }
  }

  /// Predicts skin condition from the provided image file
  Future<String> predictImage(File image) async {
    if (!_isModelLoaded || _interpreter == null) {
      throw Exception('Model not loaded. Call loadModel() first');
    }

    try {
      // Load and preprocess image
      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) throw Exception('Failed to decode image');
      
      // Resize with proper interpolation
      final resizedImage = img.copyResize(
        decodedImage,
        width: _inputSize,
        height: _inputSize,
        interpolation: img.Interpolation.cubic
      );

      // Convert to model input format
      final input = _convertToModelInput(resizedImage);
      
      // Create output buffer
      final output = List<List<double>>.filled(
        1, 
        List<double>.filled(_labels.length, 0.0)
      );

      // Run prediction
      _interpreter!.run(input, output);

      // Interpret results
      return _interpretResult(output[0]);
    } catch (e) {
      print('Prediction failed: $e');
      throw Exception('Prediction failed: $e');
    }
  }

  /// Converts an image to the model's expected input format
  List<List<List<List<double>>>> _convertToModelInput(img.Image image) {
    // Create a buffer for normalized RGB values
    final inputBuffer = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (_) => List.generate(
          _inputSize,
          (_) => List.filled(3, 0.0),
        ),
      ),
    );

    // Fill the buffer with normalized pixel values
    for (var y = 0; y < _inputSize; y++) {
      for (var x = 0; x < _inputSize; x++) {
        final pixel = image.getPixel(x, y);
        // Normalize to 0-1 range
        inputBuffer[0][y][x][0] = pixel.r / 255.0;
        inputBuffer[0][y][x][1] = pixel.g / 255.0;
        inputBuffer[0][y][x][2] = pixel.b / 255.0;
      }
    }
    
    return inputBuffer;
  }

  /// Interprets the model output and returns a human-readable result
  String _interpretResult(List<double> output) {
    // Find the index with highest confidence
    int maxIndex = 0;
    double maxValue = output[0];
    
    for (int i = 1; i < output.length; i++) {
      if (output[i] > maxValue) {
        maxValue = output[i];
        maxIndex = i;
      }
    }
    
    // Format the result with confidence percentage
    final confidence = (maxValue * 100).toStringAsFixed(1);
    return '${_labels[maxIndex]} ($confidence% confidence)';
  }

  /// Releases resources used by the interpreter
  void dispose() {
    _interpreter?.close();
    _isModelLoaded = false;
    print('SkinTrackingService disposed');
  }

  /// Checks if the model is currently loaded
  bool get isModelLoaded => _isModelLoaded;
}