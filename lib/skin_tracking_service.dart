

// import 'dart:io';
// import 'package:image/image.dart' as img;
// import 'package:tflite_flutter/tflite_flutter.dart';

// class SkinTrackingService {
//   static const String _modelPath = 'assets/skinmate.tflite';
//   static const int _inputSize = 224;
//   static const int _numChannels = 3;
//   static const List<String> _classLabels = [
//     'blackheads',
//     'Acne',
//     'wrinkles',
//     'darkspots'
//   ];

//   late Interpreter _interpreter;
//   bool _isModelLoaded = false;
//   bool _isLoading = false;

//   Future<void> loadModel() async {
//     if (_isLoading || _isModelLoaded) return;
    
//     _isLoading = true;
//     try {
//       final options = InterpreterOptions()
//         ..threads = 4
//         ..useNnApiForAndroid = true;

//       // Load model with verification
//       _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
      
//       // Verify model shape matches our expectations
//       final inputTensors = _interpreter.getInputTensors();
//       final outputTensors = _interpreter.getOutputTensors();
      
//       if (inputTensors.isEmpty || outputTensors.isEmpty) {
//         throw Exception("Invalid model - missing input/output tensors");
//       }

//       final inputShape = inputTensors[0].shape;
//       final outputShape = outputTensors[0].shape;

//       if (inputShape.length != 4 || 
//           inputShape[1] != _inputSize || 
//           inputShape[2] != _inputSize || 
//           inputShape[3] != _numChannels) {
//         throw Exception("Model input shape mismatch. Expected [1,$_inputSize,$_inputSize,$_numChannels]");
//       }

//       if (outputShape.length != 2 || outputShape[1] != _classLabels.length) {
//         throw Exception("Model output shape mismatch. Expected [1,${_classLabels.length}]");
//       }

//       await _warmUpModel();
//       _isModelLoaded = true;
//       print("Model loaded successfully with input: $inputShape, output: $outputShape");
//     } catch (e) {
//       _isModelLoaded = false;
//       _interpreter.close();
//       throw Exception("Model loading failed: $e");
//     } finally {
//       _isLoading = false;
//     }
//   }

//   Future<void> _warmUpModel() async {
//     try {
//       final warmUpInput = List.generate(
//         1,
//         (_) => List.generate(
//           _inputSize,
//           (_) => List.generate(
//             _inputSize,
//             (_) => List.filled(_numChannels, 0.0),
//           ),
//         ),
//       );

//       final warmUpOutput = List.filled(_classLabels.length, 0.0)
//           .reshape([1, _classLabels.length]);

//       _interpreter.run(warmUpInput, warmUpOutput);
//     } catch (e) {
//       throw Exception("Model warmup failed: $e");
//     }
//   }

//   Future<String> predictImage(File imageFile) async {
//     if (!_isModelLoaded) {
//       // Attempt to load model if not loaded
//       try {
//         await loadModel();
//       } catch (e) {
//         throw Exception("Model not loaded and failed to load: $e");
//       }
//     }

//     try {
//       final input = await _preprocessImage(imageFile);
//       final output = List.filled(_classLabels.length, 0.0)
//           .reshape([1, _classLabels.length]);

//       _interpreter.run(input, output);
//       return _interpretOutput(output[0]);
//     } catch (e) {
//       throw Exception("Prediction failed: $e");
//     }
//   }

//   Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
//     try {
//       final bytes = await imageFile.readAsBytes();
//       final image = img.decodeImage(bytes);
//       if (image == null) throw Exception("Image decoding failed");

//       final resized = img.copyResize(
//         image,
//         width: _inputSize,
//         height: _inputSize,
//         interpolation: img.Interpolation.cubic,
//       );

//       return _convertImageToInput(resized);
//     } catch (e) {
//       throw Exception("Image preprocessing error: $e");
//     }
//   }

//   List<List<List<List<double>>>> _convertImageToInput(img.Image image) {
//     return List.generate(1, (_) {
//       return List.generate(_inputSize, (y) {
//         return List.generate(_inputSize, (x) {
//           final pixel = image.getPixel(x, y);
//           return [
//             pixel.r / 255.0, // Normalized R
//             pixel.g / 255.0, // Normalized G
//             pixel.b / 255.0, // Normalized B
//           ];
//         });
//       });
//     });
//   }

//   String _interpretOutput(List<double> output) {
//     final maxIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));
//     final confidence = (output[maxIndex] * 100).toStringAsFixed(1);
//     return "${_classLabels[maxIndex]} ($confidence% confidence)";
//   }

//   void dispose() {
//     if (_isModelLoaded) {
//       _interpreter.close();
//       _isModelLoaded = false;
//     }
//   }
// }

import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class SkinTrackingService {
  static const String _modelPath = 'assets/skinmate.tflite';
  static const int _inputSize = 224;
  static const List<String> _labels = ['blackheads', 'Acne', 'wrinkles', 'darkspots'];
  
  Interpreter? _interpreter;
  bool _isModelLoaded = false;

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
      if (inputTensor.shape[0] != 1 || 
          inputTensor.shape[1] != _inputSize || 
          inputTensor.shape[2] != _inputSize || 
          inputTensor.shape[3] != 3) {
        throw Exception('Model expects input shape [1,224,224,3] but got ${inputTensor.shape}');
      }

      // Verify output shape matches our labels
      final outputTensor = _interpreter!.getOutputTensor(0);
      if (outputTensor.shape[0] != 1 || outputTensor.shape[1] != _labels.length) {
        throw Exception('Model expects output shape [1,${_labels.length}] but got ${outputTensor.shape}');
      }

      _isModelLoaded = true;
    } catch (e) {
      _isModelLoaded = false;
      _interpreter?.close();
      rethrow;
    }
  }

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

      // Convert to exactly [1,224,224,3] shape
      final input = _convertToModelInput(resizedImage);
      final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);

      // Run prediction
      _interpreter!.run(input, output);

      // Interpret results
      return _interpretResult(output[0]);
    } catch (e) {
      throw Exception('Prediction failed: $e');
    }
  }

  List<List<List<List<double>>>> _convertToModelInput(img.Image image) {
  // Create a properly typed 4D list
  final input = List<List<List<List<double>>>>.filled(
    1,
    List<List<List<double>>>.filled(
      _inputSize,
      List<List<double>>.filled(
        _inputSize,
        List<double>.filled(3, 0.0),
      ),
    ),
  );

  for (var y = 0; y < _inputSize; y++) {
    for (var x = 0; x < _inputSize; x++) {
      final pixel = image.getPixel(x, y);
      input[0][y][x][0] = pixel.r / 255.0; // R channel
      input[0][y][x][1] = pixel.g / 255.0; // G channel
      input[0][y][x][2] = pixel.b / 255.0; // B channel
    }
  }
  return input;
}

  String _interpretResult(List<double> output) {
    final maxIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));
    final confidence = (output[maxIndex] * 100).toStringAsFixed(1);
    return '${_labels[maxIndex]} ($confidence% confidence)';
  }

  void dispose() {
    _interpreter?.close();
    _isModelLoaded = false;
  }
}