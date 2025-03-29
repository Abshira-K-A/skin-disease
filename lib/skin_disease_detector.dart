


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
        'assets/skinmate.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      
      final labelsData = await rootBundle.loadString('assets/labels.txt');
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

  /// Resize image to 224x224 and normalize pixel values
  List<List<List<List<double>>>> _processImage(img.Image image) {
  final resized = img.copyResize(image, width: 224, height: 224);
  return List.generate(1, (_) {
    return List.generate(224, (y) {
      return List.generate(224, (x) {
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