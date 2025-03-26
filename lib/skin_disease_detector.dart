// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as img;

// class SkinDiseaseDetector {
//   Interpreter? _interpreter;
//   List<String> _labels = [];

//   SkinDiseaseDetector() {
//     _loadModel();
//   }

//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('assets/skinmate.tflite');

//       final labelsData = await rootBundle.loadString('assets/labels.txt');
//       _labels = labelsData.split('\n');
      
//       print("Model and labels loaded successfully!");
//     } catch (e) {
//       print("Error loading model: $e");
//     }
//   }

//   Future<String> classifyImage(File imageFile) async {
//     if (_interpreter == null) {
//       await _loadModel();
//     }

//     img.Image? image = img.decodeImage(await imageFile.readAsBytes());
//     if (image == null) {
//       return "Error decoding image";
//     }

//     // Resize image to match the input shape of the model
//     image = img.copyResize(image, width: 150, height: 150);

//     // Convert image to a 3D array (150x150x3)
//     var input = List.generate(150, (y) {
//       return List.generate(150, (x) {
//         img.Pixel pixel = image.getPixel(x, y); // Get the Pixel object
//         int color = pixel.toColor(); // Convert Pixel to ARGB int
        
//         return [
//           ((color >> 16) & 0xFF) / 255.0, // Extract Red
//           ((color >> 8) & 0xFF) / 255.0,  // Extract Green
//           (color & 0xFF) / 255.0          // Extract Blue
//         ];
//       });
//     });

//     // Convert input to float32 tensor
//     var inputTensor = [input];

//     // Model output
//     var outputTensor = List.generate(1, (index) => List.filled(_labels.length, 0.0));

//     _interpreter!.run(inputTensor, outputTensor);

//     // Get predicted class
//     int predictedIndex = outputTensor[0].indexWhere((element) => element == outputTensor[0].reduce((a, b) => a > b ? a : b));

//     return _labels[predictedIndex];
//   }
// }


import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:math';


class SkinDiseaseDetector {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/skinmate.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      
      final labelsData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData.split('\n');
    } catch (e) {
      print("Model loading error: $e");
      throw Exception("Model initialization failed");
    }
  }

  Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    if (_interpreter == null) await _loadModel();
    
    try {
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      if (image == null) return {'error': 'Image decoding failed'};

      // Get pixel data correctly
      final input = _processImage(image);
      final output = List.filled(_labels.length, 0.0).reshape([1, _labels.length]);
      
      _interpreter!.run(input, output);
      
      final results = output[0];
      final maxIndex = results.indexOf(results.reduce(max));
      
      return {
        'label': _labels[maxIndex],
        'confidence': (results[maxIndex] * 100).toStringAsFixed(1),
        'scores': List<double>.from(results)
      };
    } catch (e) {
      return {'error': 'Classification failed: $e'};
    }
  }

  // List<List<List<List<double>>>> _processImage(img.Image image) {
  //   final resized = img.copyResize(image, width: 150, height: 150);
  //   return List.generate(1, (_) {
  //     return List.generate(150, (y) {
  //       return List.generate(150, (x) {
  //         final pixel = resized.getPixel(x, y);
  //         return [
  //           _getRed(pixel) / 255.0,
  //           _getGreen(pixel) / 255.0,
  //           _getBlue(pixel) / 255.0,
  //         ];
  //       });
  //     });
  //   });
  // }
  List<List<List<List<double>>>> _processImage(img.Image image) {
  final resized = img.copyResize(image, width: 150, height: 150);
  return List.generate(1, (_) {
    return List.generate(150, (y) {
      return List.generate(150, (x) {
        final pixel = resized.getPixel(x, y); // Returns a Pixel object
        return [
          pixel.r / 255.0, // Corrected way to get red channel
          pixel.g / 255.0, // Corrected way to get green channel
          pixel.b / 255.0, // Corrected way to get blue channel
        ];
      });
    });
  });
}


  // Proper pixel value extraction methods
  int _getRed(int pixel) => (pixel >> 16) & 0xFF;
  int _getGreen(int pixel) => (pixel >> 8) & 0xFF;
  int _getBlue(int pixel) => pixel & 0xFF;

  void dispose() {
    _interpreter?.close();
  }
}