import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:alternate_rbim/screen/components/constants.dart';

class PlaylistVideosPage extends StatefulWidget {
  final String playlistId;
  final String title;

  PlaylistVideosPage({required this.playlistId, required this.title});

  @override
  _PlaylistVideosPageState createState() => _PlaylistVideosPageState();
}

class _PlaylistVideosPageState extends State<PlaylistVideosPage> {
  final String apiKey = constants().APIKEY;
  List videos = [];
  String? nextPageToken;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    String url =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=${widget.playlistId}&maxResults=50&key=$apiKey';
    if (nextPageToken != null) url += '&pageToken=$nextPageToken';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        videos.addAll(data['items']);
        nextPageToken = data['nextPageToken'];
      });
    }
  }

  void launchVideo(String videoId) async {
    final url = 'https://www.youtube.com/watch?v=$videoId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: videos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videos.length + 1,
              itemBuilder: (context, index) {
                if (index == videos.length) {
                  fetchVideos();
                  return Center(child: CircularProgressIndicator());
                }
                final video = videos[index];
                return VideoTile(video: video, launchVideo: launchVideo);
              },
            ),
    );
  }
}

class VideoTile extends StatelessWidget {
  final Map video;
  final Function(String) launchVideo;

  VideoTile({required this.video, required this.launchVideo});

  @override
  Widget build(BuildContext context) {
    final videoId = video['snippet']['resourceId']['videoId'];
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
        onTap: () => launchVideo(videoId),
      ),
    );
  }
}
