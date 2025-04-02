import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
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
    if (_isModelLoading) return;

    setState(() {
      _isModelLoading = true;
      _error = null;
      _currentAttempt++;
    });

    try {
      if (_currentAttempt > 1) {
        _service.dispose();
      }

      await _service.loadModel();
      setState(() {
        _isModelLoading = false;
        _currentAttempt = 0;
      });
    } catch (e) {
      setState(() {
        _isModelLoading = false;
        _error = 'Attempt $_currentAttempt/$_maxRetries: ${e.toString()}';
      });

      if (_currentAttempt < _maxRetries) {
        await Future.delayed(const Duration(seconds: 1));
        await _loadModel();
      } else {
        setState(() {
          _error = 'Failed to load model after $_maxRetries attempts';
          _currentAttempt = 0;
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
      if (result == null || result.isEmpty) {
        throw Exception('Empty prediction result');
      }
      setState(() => _prediction = result);
    } on ImageProcessingException catch (e) {
      setState(() => _error = 'Image processing error: ${e.message}');
    } on ModelException catch (e) {
      setState(() => _error = 'Model error: ${e.message}');
      await _loadModel();
    } catch (e) {
      setState(() => _error = 'Unexpected error: ${e.toString()}');
      if (e.toString().contains('not loaded') ||
          e.toString().contains('interpreter')) {
        _currentAttempt = 0;
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
                  _currentAttempt = 0;
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
              if (_prediction != null) _buildResult(),
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

class SkinTrackingService {
  static const String _modelPath = 'assets/skinmate.tflite';
  static const int _inputSize = 224;
  static const List<String> _labels = [
    'blackheads',
    'Acne',
    'wrinkles',
    'darkspots'
  ];

  Interpreter? _interpreter;
  bool _isModelLoaded = false;

  Future<void> loadModel() async {
    try {
      final modelPath = await _getModelPath();
      final options = InterpreterOptions()
        ..threads = 4
        ..useNnApiForAndroid = false;
      _interpreter = await Interpreter.fromAsset(modelPath, options: options);
      print('Model loaded successfully');
    } catch (e, stackTrace) {
      print('Error loading model: $e');
      print(stackTrace);
    }
  }

  Future<String> predictImage(File image) async {
    if (!_isModelLoaded || _interpreter == null) {
      throw ModelException('Model not loaded. Call loadModel() first');
    }

    try {
      final input = _preprocessImage(image);
      final output = List<List<double>>.filled(
          1, List<double>.filled(_labels.length, 0.0));
      _interpreter!.run(input, output);
      return _interpretResult(output[0]);
    } catch (e) {
      _log('Prediction failed: $e');
      throw Exception('Prediction failed: $e');
    }
  }

  Uint8List _preprocessImage(File imageFile) {
    try {
      final imageBytes = imageFile.readAsBytesSync();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null)
        throw ImageProcessingException('Failed to decode image');

      final resizedImage = img.copyResize(decodedImage,
          width: _inputSize,
          height: _inputSize,
          interpolation: img.Interpolation.cubic);

      final inputBuffer = Float32List(1 * _inputSize * _inputSize * 3);
      int pixelIndex = 0;

      for (var y = 0; y < _inputSize; y++) {
        for (var x = 0; x < _inputSize; x++) {
          final pixel = resizedImage.getPixel(x, y);
          inputBuffer[pixelIndex++] = pixel.r / 255.0;
          inputBuffer[pixelIndex++] = pixel.g / 255.0;
          inputBuffer[pixelIndex++] = pixel.b / 255.0;
        }
      }

      return inputBuffer.buffer.asUint8List();
    } catch (e) {
      throw ImageProcessingException(
          'Image processing failed: ${e.toString()}');
    }
  }

  String _interpretResult(List<double> output) {
    int maxIndex = 0;
    double maxValue = output[0];

    for (int i = 1; i < output.length; i++) {
      if (output[i] > maxValue) {
        maxValue = output[i];
        maxIndex = i;
      }
    }

    final confidence = (maxValue * 100).toStringAsFixed(1);
    return '${_labels[maxIndex]} ($confidence% confidence)';
  }

  Future<String> _getModelPath() async {
    return _modelPath;
  }

  void _verifyModelShape() {
    final inputTensor = _interpreter!.getInputTensor(0);
    if (inputTensor.shape.length != 4 ||
        inputTensor.shape[1] != _inputSize ||
        inputTensor.shape[2] != _inputSize ||
        inputTensor.shape[3] != 3) {
      throw ModelException(
          'Invalid input shape. Expected [1,224,224,3], got ${inputTensor.shape}');
    }

    final outputTensor = _interpreter!.getOutputTensor(0);
    if (outputTensor.shape.length != 2 ||
        outputTensor.shape[1] != _labels.length) {
      throw ModelException(
          'Invalid output shape. Expected [1,${_labels.length}], got ${outputTensor.shape}');
    }
  }

  void _log(String message) {
    debugPrint('[SkinTracking] $message');
  }

  void dispose() {
    _interpreter?.close();
    _isModelLoaded = false;
    _log('Service disposed');
  }

  bool get isModelLoaded => _isModelLoaded;
}

class ImageProcessingException implements Exception {
  final String message;
  ImageProcessingException(this.message);
}

class ModelException implements Exception {
  final String message;
  ModelException(this.message);
}
