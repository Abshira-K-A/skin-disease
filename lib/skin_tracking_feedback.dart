// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:math';

// class SkinTrackingFeedback {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<String> getFeedback(String userId) async {
//     var snapshots = await firestore.collection('skinTracking').doc(userId).collection('uploads').orderBy('timestamp', descending: true).limit(2).get();

//     if (snapshots.docs.length < 2) return "Not enough images to track progress.";

//     var oldImage = snapshots.docs[1]['imageUrl'];
//     var newImage = snapshots.docs[0]['imageUrl'];

//     double difference = Random().nextDouble(); // Placeholder for pixel difference analysis

//     if (difference < 0.2) {
//       return "Your skin is improving! Keep using your current routine.";
//     } else {
//       return "Your skin condition has worsened. Consider changing your skincare routine.";
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

// Import the SkinTrackingService
import 'skin_tracking_service.dart';

class SkinTrackingFeedback {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SkinTrackingService _skinService = SkinTrackingService();
  
  // Initialize the service
  Future<void> initialize() async {
    await _skinService.loadModel();
  }
  
  /// Get personalized feedback based on comparing recent skin images
  Future<Map<String, dynamic>> getFeedback(String userId) async {
    try {
      // Ensure model is loaded
      if (!_skinService.isModelLoaded) {
        await _skinService.loadModel();
      }
      
      // Get the two most recent image uploads
      var snapshots = await _firestore
          .collection('skinTracking')
          .doc(userId)
          .collection('uploads')
          .orderBy('timestamp', descending: true)
          .limit(2)
          .get();
      
      // Handle case with not enough images
      if (snapshots.docs.length < 2) {
        return {
          'status': 'insufficient_data',
          'message': "We need at least two images to track your progress. Please upload another image later.",
          'condition': null,
          'previousCondition': null,
          'improvement': null
        };
      }
      
      // Get image URLs and metadata
      var recentImageData = snapshots.docs[0].data();
      var previousImageData = snapshots.docs[1].data();
      
      var recentImageUrl = recentImageData['imageUrl'] as String;
      var previousImageUrl = previousImageData['imageUrl'] as String;
      
      // Download and analyze both images
      var recentCondition = await _analyzeImageFromUrl(recentImageUrl);
      var previousCondition = await _analyzeImageFromUrl(previousImageUrl);
      
      // Extract just the condition name without confidence
      var recentConditionName = _extractConditionName(recentCondition);
      var previousConditionName = _extractConditionName(previousCondition);
      
      // Extract confidence percentages
      var recentConfidence = _extractConfidence(recentCondition);
      var previousConfidence = _extractConfidence(previousCondition);
      
      // Determine improvement factor (-1 to 1 scale, where positive is improvement)
      double improvementFactor = 0;
      
      // If conditions are different, we need more nuanced feedback
      if (recentConditionName == previousConditionName) {
        // Same condition - improvement is based on confidence reduction
        improvementFactor = (previousConfidence - recentConfidence) / 100;
      } else {
        // Different conditions - use severity scale
        improvementFactor = _compareSeverity(previousConditionName, recentConditionName);
      }
      
      // Generate feedback message
      String feedbackMessage = _generateFeedbackMessage(
        recentConditionName, 
        previousConditionName,
        improvementFactor
      );
      
      // Store analysis results back to Firestore
      await _firestore
          .collection('skinTracking')
          .doc(userId)
          .collection('analysis')
          .add({
            'timestamp': FieldValue.serverTimestamp(),
            'recentImageId': snapshots.docs[0].id,
            'previousImageId': snapshots.docs[1].id,
            'recentCondition': recentCondition,
            'previousCondition': previousCondition,
            'improvementFactor': improvementFactor,
            'feedback': feedbackMessage
          });
      
      return {
        'status': 'success',
        'message': feedbackMessage,
        'condition': recentCondition,
        'previousCondition': previousCondition,
        'improvement': improvementFactor
      };
    } catch (e) {
      return {
        'status': 'error',
        'message': "An error occurred while analyzing your skin progress: $e",
        'condition': null,
        'previousCondition': null,
        'improvement': null
      };
    }
  }
  
  /// Download and analyze an image from a URL
  Future<String> _analyzeImageFromUrl(String imageUrl) async {
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }
      
      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_skin_image.jpg');
      await tempFile.writeAsBytes(response.bodyBytes);
      
      // Analyze the image using SkinTrackingService
      final result = await _skinService.predictImage(tempFile);
      
      // Clean up
      await tempFile.delete();
      
      return result;
    } catch (e) {
      throw Exception('Image analysis failed: $e');
    }
  }
  
  /// Extract just the condition name from the full result string
  String _extractConditionName(String conditionWithConfidence) {
    // Example input: "Acne (87.5% confidence)"
    return conditionWithConfidence.split(' (')[0];
  }
  
  /// Extract the confidence percentage as a number
  double _extractConfidence(String conditionWithConfidence) {
    // Example input: "Acne (87.5% confidence)"
    try {
      final percentageStr = conditionWithConfidence
          .split(' (')[1]
          .split('% confidence)')[0];
      return double.parse(percentageStr);
    } catch (e) {
      return 0.0; // Default in case of parsing error
    }
  }
  
  /// Compare the severity of two skin conditions
  /// Returns a value between -1 and 1, where positive means improvement
  double _compareSeverity(String oldCondition, String newCondition) {
    // Severity scale (lower is better):
    // 1. darkspots (least severe)
    // 2. wrinkles
    // 3. blackheads
    // 4. Acne (most severe)
    
    final Map<String, int> severityScale = {
      'darkspots': 1,
      'wrinkles': 2,
      'blackheads': 3,
      'Acne': 4
    };
    
    final oldSeverity = severityScale[oldCondition] ?? 0;
    final newSeverity = severityScale[newCondition] ?? 0;
    
    // Calculate improvement factor
    // Normalize to -1 to 1 scale (divide by max difference of 3)
    return (oldSeverity - newSeverity) / 3;
  }
  
  /// Generate personalized feedback based on skin condition changes
  String _generateFeedbackMessage(
    String currentCondition, 
    String previousCondition,
    double improvementFactor
  ) {
    // Clear improvement
    if (improvementFactor > 0.3) {
      return "Great progress! Your skin has improved significantly from $previousCondition to $currentCondition. Keep following your current routine.";
    }
    // Moderate improvement
    else if (improvementFactor > 0) {
      return "We're seeing some improvement in your skin condition. Continue with your current routine and consider additional hydration.";
    }
    // No significant change
    else if (improvementFactor > -0.3) {
      return "Your skin condition hasn't changed significantly. Consider incorporating products specifically targeting $currentCondition into your routine.";
    }
    // Worsening condition
    else {
      return "We've noticed your skin condition has changed from $previousCondition to $currentCondition, which may indicate increased skin sensitivity. Consider simplifying your routine and using gentle, non-irritating products.";
    }
  }
  
  /// Clean up resources
  void dispose() {
    _skinService.dispose();
  }
}