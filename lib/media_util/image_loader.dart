import 'package:flutter/material.dart';

class ImageWithLoading extends StatelessWidget {
  final String imageUrl;

  ImageWithLoading({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      // This builder is called every time the image is loading
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child; // Image has fully loaded
        } else {
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null, // Progress bar shows actual progress if available
            ),
          );
        }
      },
      // If an error occurs while loading the image
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 50.0,
              ),
              Text(
                'Failed to load image',
                style: TextStyle(color: Colors.red, fontSize: 16.0),
              ),
            ],
          ),
        );
      },
    );
  }
}
