import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String? _userUid;

  @override
  void initState() {
    super.initState();
    _fetchUserUid();
  }

  Future<void> _fetchUserUid() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User is not logged in");
      }
      setState(() {
        _userUid = user.uid;
      });
    } catch (e) {
      setState(() {
        _userUid = null; // To handle the error state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userUid == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'News Feed',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 103, 164, 245),
          ),
        ),
        backgroundColor: const Color(0xFFBDDDFC),
        iconTheme: const IconThemeData(
          color: Colors.blue, // Set the back arrow color here
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news_feed')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return NewsCard(
                title: post['title'],
                content: post['content'],
                author: post['author'],
                createdAt: post['created_at'].toDate(),
                postId: post.id,
                userUid: _userUid!,
              );
            },
          );
        },
      ),
    );
  }
}

class NewsCard extends StatefulWidget {
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final String postId;
  final String userUid;

  const NewsCard({
    Key? key,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.postId,
    required this.userUid,
  }) : super(key: key);

  @override
  _NewsCardState createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  int likesCount = 0;
  bool isLiked = false;
  int commentsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchPostData();
  }

  Future<void> _fetchPostData() async {
    final doc = await FirebaseFirestore.instance
        .collection('news_feed')
        .doc(widget.postId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        likesCount = data['likes'] ?? 0;
        isLiked = (data['liked_users'] ?? []).contains(widget.userUid);
        commentsCount = (data['comments'] ?? []).length;
      });
    }
  }

  Future<void> _toggleLike() async {
    final docRef = FirebaseFirestore.instance.collection('news_feed').doc(widget.postId);

    if (isLiked) {
      // Dislike logic
      await docRef.update({
        'likes': FieldValue.increment(-1),
        'liked_users': FieldValue.arrayRemove([widget.userUid]),
      });
      setState(() {
        likesCount -= 1;
        isLiked = false;
      });
    } else {
      // Like logic
      await docRef.update({
        'likes': FieldValue.increment(1),
        'liked_users': FieldValue.arrayUnion([widget.userUid]),
      });
      setState(() {
        likesCount += 1;
        isLiked = true;
      });
    }
  }

  Future<void> _addComment(String comment) async {
    if (comment.isNotEmpty) {
      final docRef = FirebaseFirestore.instance.collection('news_feed').doc(widget.postId);

      await docRef.update({
        'comments': FieldValue.arrayUnion([
          {
            'user': widget.userUid,
            'comment': comment,
            'timestamp': Timestamp.now(),
          }
        ]),
      });

      setState(() {
        commentsCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(color: Colors.grey[400], thickness: 1, height: 1.5),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              widget.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    ),
                    Text(
                      likesCount.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'likes',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.comment_outlined),
                      onPressed: () {
                        _showCommentDialog(context);
                      },
                    ),
                    Text(
                      commentsCount.toString(),
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'comments',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[400], thickness: 1, height: 1.5),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage("images/doctor1.jpg"),
                ),
                const SizedBox(width: 8),
                Text(
                  'By ${widget.author}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const Spacer(),
                Text(
                  '${widget.createdAt.day}/${widget.createdAt.month}/${widget.createdAt.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: 'Write your comment here'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addComment(commentController.text);
              Navigator.pop(context);
            },
            child: const Text(
              'Post',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
