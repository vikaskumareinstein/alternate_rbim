import 'package:alternate_rbim/screen/components/bulleted_elevated_text_box.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:alternate_rbim/screen/components/elevated_text_box.dart';
import 'package:alternate_rbim/screen/components/text_value.dart';

class AboutPage extends StatelessWidget {
  // Images for the top carousel
  final List<String> topCarouselImages = [
    'images/background_1.png',
    'images/background_2.jpg',
  ];

  // Coworkers details
  final List<Map<String, String>> coworkers = [
    {
      'image': 'images/tonia.png',
      'name': 'Tonia Ngurang',
      'designation': 'Youth Minister'
    },
    {
      'image': 'images/tubin.png',
      'name': 'Tubin Mudang',
      'designation': 'Youth Pastor'
    },
    {
      'image': 'images/sanu.png',
      'name': 'Sanu Bhuzel',
      'designation': 'Worship Minister'
    },
  ];

  // URL for the Google Map location
  final String mapLocationUrl = 'https://maps.app.goo.gl/oW7oV6htMJe7dLTK9';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top carousel image slider
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
            ),
            items: topCarouselImages.map((imagePath) {
              return Builder(
                builder: (BuildContext context) {
                  return Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              );
            }).toList(),
          ),

          SizedBox(height: 20),

          // Your photo and description
          CircleAvatar(
            radius: 90,
            backgroundImage: AssetImage('images/rbim_icon_1.png'),
          ),
          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedTextBox(
                title: TextValues().ABOUT_RBIM_TITLE,
                description: TextValues().ABOUT_RBIM_DESC),
          ),

          // Coworkers carousel slider
          SizedBox(height: 35),
          Text(
            'Meet Our Team',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 280.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 2),
              enlargeCenterPage: true,
            ),
            items: coworkers.map((coworker) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundImage: AssetImage(coworker['image']!),
                  ),
                  Text(coworker['name']!,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 3),
                  Text(coworker['designation']!,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: BulletedElevatedTextBox(
                title: TextValues().ABOUT_RBIM_TITLE,
                description: TextValues().RBIM_BELIEF),
          ),

          // Map image
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedTextBox(
                title: "Vision & Mission",
                description: TextValues().RBIM_VISION),
          ),

          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: BulletedElevatedTextBox(
                title: "RBIM Desires", description: TextValues().RBIM_DESIRES),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: _openMap,
            child: Column(
              children: [
                Image.asset(
                  'images/map_location.png',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 8),
                Text(
                  'Find Us on Google Maps',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to launch Google Maps
  void _openMap() async {
    if (await canLaunchUrl(Uri.parse(mapLocationUrl))) {
      await launchUrl(Uri.parse(mapLocationUrl));
    } else {
      throw 'Could not launch $mapLocationUrl';
    }
  }
}
