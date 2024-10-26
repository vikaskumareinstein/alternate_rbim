import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoList extends StatelessWidget {
  final List videos;
  final String emptyMessage;

  VideoList({required this.videos, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    return videos.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return VideoTile(video: video);
            },
          );
  }
}

class VideoTile extends StatelessWidget {
  final Map video;

  VideoTile({required this.video});

  @override
  Widget build(BuildContext context) {
    final videoId = video['id']['videoId'];
    final url = 'https://www.youtube.com/watch?v=$videoId';
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 5,
      child: ListTile(
        leading: Image.network(
          video['snippet']['thumbnails']['default']['url'],
          width: 80,
        ),
        title: Text(
          video['snippet']['title'],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          video['snippet']['description'],
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => launchURL(url),
      ),
    );
  }

  void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
