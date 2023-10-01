import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String predictedClass;
  final double probability;
  final String solution;

  ResultPage(
      {required this.predictedClass,
      required this.probability,
      required this.solution});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Result'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Set the container width as a percentage of the screen width
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green, // Background color
              borderRadius: BorderRadius.circular(10.0), // Add rounded corners
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Predicted Class: $predictedClass',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Text color
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Probability: ${probability.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Text color
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Solution: $solution',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Text color
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
