import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Disease Detection',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PlantDiseaseDetection(),
    );
  }
}

class PlantDiseaseDetection extends StatefulWidget {
  @override
  _PlantDiseaseDetectionState createState() => _PlantDiseaseDetectionState();
}

class _PlantDiseaseDetectionState extends State<PlantDiseaseDetection> {
  File? _selectedImage;
  String? _errorMessage; // Store error message
  String? _predictedClass;
  double? _probability;
  String? _solution;

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        _errorMessage = null; // Clear any previous error message
      }
    });
  }

  Future<void> _classifyImage() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = "Select an image first";
      });
      return;
    }

    final serverUrl = 'https://8b9c-103-227-94-102.ngrok.io/upload';

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        body: {'image': _selectedImage!.readAsBytesSync()},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _predictedClass = jsonResponse['predicted_class'];
        _probability = double.parse(jsonResponse['probability']);
        _solution = jsonResponse['solution'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              predictedClass: _predictedClass!,
              probability: _probability!,
              solution: _solution!,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = "Server error. Please try again later.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            "Error sending image to server. Please check your internet connection.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Disease Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _selectedImage != null
                ? Image.file(
                    _selectedImage!,
                    height: 200.0,
                  )
                : Icon(
                    Icons.image,
                    size: 100.0,
                    color: Colors.grey,
                  ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _getImage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Select Image',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _selectedImage != null
                  ? _classifyImage
                  : null, // Disable when no image is selected
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Classify',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            if (_errorMessage != null)
              SizedBox(
                height: 20.0,
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  sendImageToServer(File file, String serverUrl) {}
}

class ResultPage extends StatelessWidget {
  final String predictedClass;
  final double probability;
  final String solution;

  ResultPage({
    required this.predictedClass,
    required this.probability,
    required this.solution,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Prediction Result:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text('Class: $predictedClass'),
            Text('Probability: ${probability.toStringAsFixed(2)}%'),
            Text('Solution: $solution'),
          ],
        ),
      ),
    );
  }
}
