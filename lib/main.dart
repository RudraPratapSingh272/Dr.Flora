import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'result_page.dart'; // Import the ResultPage class

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

  void _classifyImage() {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = "Select an image first"; // Set error message
      });
      return; // Don't proceed with classification if no image is selected
    }

    // Add your image classification logic here
    // You would typically send the selected image to a server for classification
    // Once you receive the classification result, you can display it to the user
    // ...

    // For demonstration purposes, simulate prediction data (replace with actual prediction code)
    String predictedClass = "Some Class";
    double probability = 0.85;
    String solution = "Some Solution";

    // Navigate to ResultPage and pass prediction data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          predictedClass: predictedClass,
          probability: probability,
          solution: solution,
        ),
      ),
    );
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
                primary: Colors.green,
                onPrimary: Colors.white,
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
                primary: Colors.green,
                onPrimary: Colors.white,
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
          ],
        ),
      ),
    );
  }
}
