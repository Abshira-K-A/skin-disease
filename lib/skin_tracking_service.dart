import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class SkinTrackingService {
  static const String _modelPath = 'assets/skinmate.tflite';
  static const int _inputSize = 224;
  static const int _numChannels = 3;
  static const List<String> _classLabels = [
    'Healthy',
    'Acne',
    'Eczema',
    'Psoriasis',
    'Rosacea'
  ]; // Update with your actual classes

  late Interpreter _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      // Create interpreter options
      final options = InterpreterOptions()
        ..threads = 4
        ..useNnApiForAndroid = true;

      // Load model
      _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
      
      // Print model input/output details
      printModelDetails();

      // Warm up the model
      await _warmUpModel();
      
      _isModelLoaded = true;
      print("TFLite Model Loaded Successfully!");
    } catch (e) {
      _isModelLoaded = false;
      throw Exception("Failed to load TFLite model: $e");
    }
  }

  void printModelDetails() {
    if (!_isModelLoaded) return;
    
    print('Model Input Details:');
    for (var input in _interpreter.getInputTensors()) {
      print(input);
    }
    
    print('\nModel Output Details:');
    for (var output in _interpreter.getOutputTensors()) {
      print(output);
    }
  }

  Future<void> _warmUpModel() async {
    // Create dummy input for warm-up
    final warmUpInput = List.generate(
      1,
      (batch) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) => List.generate(_numChannels, (c) => 0.0),
        ),
      ),
    );

    // Run warm-up inference
    _interpreter.run(warmUpInput, List.filled(1, 0).reshape([1, _classLabels.length]));
  }

  Future<String> predictImage(File imageFile) async {
    if (!_isModelLoaded) {
      throw Exception("Model is not loaded. Call loadModel() first.");
    }

    try {
      // Load and preprocess image
      final input = await _preprocessImage(imageFile);

      // Prepare output buffer
      final output = List.filled(_classLabels.length, 0.0)
          .reshape([1, _classLabels.length]);

      // Run inference
      _interpreter.run(input, output);

      // Process output
      return _interpretOutput(output[0]);
    } catch (e) {
      throw Exception("Prediction failed: $e");
    }
  }

  Future<List<List<List<List<double>>>>> _preprocessImage(File imageFile) async {
    try {
      // Load image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) throw Exception("Failed to decode image");

      // Resize and normalize
      final resizedImage = img.copyResize(
        image,
        width: _inputSize,
        height: _inputSize,
      );

      return _imageToInputArray(resizedImage);
    } catch (e) {
      throw Exception("Image preprocessing failed: $e");
    }
  }

  List<List<List<List<double>>>> _imageToInputArray(img.Image image) {
    return List.generate(1, (batch) {
      return List.generate(_inputSize, (y) {
        return List.generate(_inputSize, (x) {
          final pixel = image.getPixel(x, y);
          return [
            pixel.getChannel(img.Channel.red) / 255.0,   // Normalize R
            pixel.getChannel(img.Channel.green) / 255.0, // Normalize G
            pixel.getChannel(img.Channel.blue) / 255.0, // Normalize B
          ];
        });
      });
    });
  }

  String _interpretOutput(List<double> output) {
    if (output.length != _classLabels.length) {
      throw Exception("Output length doesn't match class labels count");
    }

    // Get the index of the highest probability
    final maxIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));
    final confidence = output[maxIndex];
    final confidencePercentage = (confidence * 100).toStringAsFixed(2);

    return "${_classLabels[maxIndex]} ($confidencePercentage% confidence)";
  }

  void dispose() {
    if (_isModelLoaded) {
      _interpreter.close();
      _isModelLoaded = false;
    }
  }
}