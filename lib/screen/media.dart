import 'package:alternate_rbim/screen/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alternate_rbim/media_util/playlist_video_page.dart';

class Media extends StatefulWidget {
  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  final String apiKey = constants().APIKEY;
  final String channelId = constants().CHANNEL_ID;
  List playlists = [];

  @override
  void initState() {
    super.initState();
    fetchPlaylists();
  }

  Future<void> fetchPlaylists() async {
    final url =
        'https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=$channelId&maxResults=50&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        playlists = data['items'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('YouTube Playlists')),
      body: playlists.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return PlaylistTile(playlist: playlist);
              },
            ),
    );
  }
}

class PlaylistTile extends StatelessWidget {
  final Map playlist;

  PlaylistTile({required this.playlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistVideosPage(
              playlistId: playlist['id'],
              title: playlist['snippet']['title'],
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        elevation: 5,
        child: ListTile(
          leading: Image.network(
            playlist['snippet']['thumbnails']['default']['url'],
            width: 80,
          ),
          title: Text(
            playlist['snippet']['title'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            playlist['snippet']['description'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
