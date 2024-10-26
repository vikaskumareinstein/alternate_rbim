import 'package:alternate_rbim/screen/components/bulleted_elevated_text_box.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alternate_rbim/screen/components/elevated_text_box.dart';
import 'package:alternate_rbim/screen/components/text_value.dart';

class AboutPastor extends StatelessWidget {
  // Images for the top carousel
  final List<String> topCarouselImages = [
    'images/background_1.png',
    'images/background_2.jpg',
  ];

  // Coworkers details

  // URL for the Google Map location
  final String mapLocationUrl = 'https://maps.app.goo.gl/oW7oV6htMJe7dLTK9';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Your photo and description
          CircleAvatar(
            radius: 90,
            backgroundImage: AssetImage('images/pastorandnini.png'),
          ),
          Text("Shajet Thomas & Nini Shajet",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          SizedBox(height: 3),
          Text("Founder & Senior Pastor",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedTextBox(
                title: TextValues().ABOUT_FOUNDER_TITLE,
                description: TextValues().ABOUT_FOUNDER),
          ),

          SizedBox(height: 30),
        ],
      ),
    );
  }
}
