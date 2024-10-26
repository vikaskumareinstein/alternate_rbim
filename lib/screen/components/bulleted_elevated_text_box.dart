import 'package:flutter/material.dart';

class BulletedElevatedTextBox extends StatelessWidget {
  final String title;
  final List<String> description;

  BulletedElevatedTextBox({required this.title, required this.description});

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
          Column(
            children: description.map((str_one) {
              return Row(children: [
                Expanded(
                  child: Text(
                    "\u271F " + str_one,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ), //text
                ),
                //bullet text
                SizedBox(
                  width: 10,
                ), //space between bullet and text
              ]);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
