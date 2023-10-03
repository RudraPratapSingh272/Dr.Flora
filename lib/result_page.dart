import 'dart:convert'; // Import the 'dart:convert' package for JSON encoding and decoding.

import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // Import the HTTP package for making network requests.

class ResultPage extends StatefulWidget {
  final String predictedClass;
  final double probability;
  final String solution;

  ResultPage({
    required this.predictedClass,
    required this.probability,
    required this.solution,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String serverResponse = ''; // To store the response from the Flask server.

  // Function to send a request to the Flask server for additional information.
  Future<void> fetchDataFromServer() async {
    final url = Uri.parse(
        'https://8b9c-103-227-94-102.ngrok.io/predict'); // Replace with your Flask server URL.
    final response = await http.post(
      url,
      body: json.encode({
        'predictedClass': widget.predictedClass,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the response.
      final data = json.decode(response.body);
      setState(() {
        serverResponse =
            data['response']; // Update the serverResponse variable.
      });
    } else {
      // Handle any errors here.
      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromServer(); // Call the function to fetch data from the server when the page is loaded.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Predicted Class: ${widget.predictedClass}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Probability: ${widget.probability.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Solution: ${widget.solution}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Additional Information from Server:',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Text(
                  serverResponse, // Display the server response here.
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
