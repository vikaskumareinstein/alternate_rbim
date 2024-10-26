import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alternate_rbim/notification_service/notification.dart';
import 'package:alternate_rbim/screen/components/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alternate_rbim/notification_service/notification.dart';
import 'package:alternate_rbim/screen/components/video_list.dart';

class Livestream extends StatefulWidget {
  @override
  _LivestreamState createState() => _LivestreamState();
}

class _LivestreamState extends State<Livestream>
    with SingleTickerProviderStateMixin {
  final String apiKey = constants().APIKEY;
  final String channelId = constants().CHANNEL_ID;
  List ongoingLiveVideos = [];
  List completedLiveVideos = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    NotificationService.init(); // Initialize notification service
    fetchOngoingLiveVideos();
    fetchCompletedLiveVideos();
  }

  Future<void> fetchOngoingLiveVideos() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&eventType=live&type=video&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ongoingLiveVideos = data['items'];
      });
      if (ongoingLiveVideos.isNotEmpty) {
        NotificationService.showNotification(
          title: "Live Now!",
          body: "A live video is currently streaming on the channel!",
        );
      }
    }
  }

  Future<void> fetchCompletedLiveVideos() async {
    final url =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&eventType=completed&type=video&order=date&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        completedLiveVideos = data['items'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Videos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Ongoing Live Videos"),
            Tab(text: "Completed Live Videos"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          VideoList(
              videos: ongoingLiveVideos,
              emptyMessage: "No ongoing live videos"),
          VideoList(
              videos: completedLiveVideos,
              emptyMessage: "No completed live videos"),
        ],
      ),
    );
  }
}
