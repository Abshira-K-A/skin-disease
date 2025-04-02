import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class SkinTrackingPage extends StatefulWidget {
  @override
  _SkinTrackingPageState createState() => _SkinTrackingPageState();
}

class _SkinTrackingPageState extends State<SkinTrackingPage> {
  Interpreter? _interpreter;
  String _result = "No prediction yet";
  File? _image;
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      print("------->");
      _interpreter = await Interpreter.fromAsset('assets/skinmate.tflite');
      setState(() {
        _isModelLoaded = true;
      });
      print('✅ Model loaded successfully');
    } catch (e, stacktrace) {
      print(stacktrace);
      print('❌ Failed to load model: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print("-------------------------------------> $pickedFile✅");
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> runInference() async {
    if (!_isModelLoaded) {
      setState(() {
        _result = "Model not loaded. Try again.";
      });
      print("⚠️ Model not loaded. Cannot run inference.");
      return;
    }

    if (_image == null) {
      setState(() {
        _result = "Please upload an image first";
      });
      return;
    }

    img.Image? imageInput = img.decodeImage(await _image!.readAsBytes());

    if (imageInput == null) {
      setState(() {
        _result = "Error processing image";
      });
      return;
    }
      


    // check

    img.Image resizedImage = img.copyResize(imageInput, width: 224, height: 224);
    



List<List<List<double>>> inputBuffer = List.generate(
  224,
  (y) => List.generate(
    224,
    (x) {
      int color = resizedImage.getPixelSafe(x, y) as int; // Safe pixel retrieval
      print("*******$color");
      return [
        ((color >> 16) & 0xFF) / 255.0, // Red
        ((color >> 8) & 0xFF) / 255.0,  // Green
        (color & 0xFF) / 255.0,         // Blue
      ];
    },
  ),
);

// Ensure output matches the expected tensor format
List<List<double>> output = List.generate(1, (_) => List.filled(1, 0.0));



      print("#####################################😊😊😊😊❤️");
    try {
      _interpreter!.run([inputBuffer], output);
      setState(() {
        _result = "Prediction: ${output[0]}";
      });
      print('✅ Inference result: $_result');
    } catch (e) {
      print('❌ Error running inference: $e');
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Skin Tracking")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null ? Image.file(_image!) : Placeholder(fallbackHeight: 200, fallbackWidth: 200),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickImage,
            child: Text("Pick Image"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: runInference,
            child: Text("Run Inference"),
          ),
          SizedBox(height: 20),
          Text(
            _result,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
