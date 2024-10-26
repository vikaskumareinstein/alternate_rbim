import 'package:flutter/material.dart';

class ElevatedTextBox extends StatelessWidget {
  final String title;
  final String description;

  ElevatedTextBox({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 8.0, // Softness of the shadow
            offset: Offset(4.0, 4.0), // Position of the shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(description,
              style: TextStyle(
                fontSize: 16.0,
              ),
              textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}
