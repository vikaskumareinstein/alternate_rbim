import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:alternate_rbim/firebase_utils/fetch_post.dart';
import 'package:share_plus/share_plus.dart';
import 'package:alternate_rbim/media_util/video_player.dart';
import 'package:alternate_rbim/media_util/image_loader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final List<DocumentSnapshot> _posts = [];
  bool _loadingMore = false;
  bool _hasMorePosts = true;
  DocumentSnapshot? _lastPost;
  final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();
    _fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchPosts();
      }
    });
  }

  Future<void> _fetchPosts() async {
    if (!_loadingMore && _hasMorePosts) {
      setState(() => _loadingMore = true);
      List<DocumentSnapshot> newPosts =
          await _postService.fetchPosts(lastPost: _lastPost);

      setState(() {
        if (newPosts.isNotEmpty) {
          _posts.addAll(newPosts);
          _lastPost = newPosts.last;
        } else {
          _hasMorePosts = false;
        }
        _loadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instagram-like Feed')),
      body: _posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _posts.length + 1,
              itemBuilder: (context, index) {
                if (index == _posts.length) {
                  return _loadingMore
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
                final post = _posts[index].data() as Map<String, dynamic>;
                return _buildPostItem(post);
              },
            ),
    );
  }

  Widget _buildPostItem(Map<String, dynamic> post) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          post['mediaUrl'] == null
              ? SizedBox.shrink()
              : post['isVideo'] == false
                  ? ImageWithLoading(imageUrl: post['mediaUrl'])
                  : AspectRatio(
                      aspectRatio: 16 / 9,
                      child: VideoPlayerWidget(videoUrl: post['mediaUrl'])),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(post['caption'] ?? ''),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () => _likePost(post['id']),
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () =>
                    _sharePost(post['mediaUrl'] ?? post['mediaUrl']),
              ),
              Text('${post['likes'] ?? 0} likes'),
            ],
          ),
        ],
      ),
    );
  }

  void _likePost(String postId) {
    // Update the likes in Firebase
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  void _sharePost(String? url) {
    if (url != null) {
      Share.share('Check out this post: $url');
    }
  }
}
