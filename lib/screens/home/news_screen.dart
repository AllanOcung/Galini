import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  Future<String> _getCurrentUserUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    return user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getCurrentUserUid(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Error fetching user data')),
          );
        }

        final String userUid = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text(
              'News Feed',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            backgroundColor: const Color(0xFFBDDDFC),
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
                    userUid: userUid,
                    // imageUrl: post['image_url'], // Uncomment if image handling is implemented
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class NewsCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('news_feed')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final int likesCount = data['likes'] ?? 0;
        final List<dynamic> likedUsers = data['liked_users'] ?? [];
        final bool isLiked = likedUsers.contains(userUid);
        final List<dynamic> comments = data['comments'] ?? [];
        final int commentsCount = comments.length;

        return Card(
          color: const Color(0xFFBDDDFC),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
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
                          onPressed: () async {
                            final docRef = FirebaseFirestore.instance.collection('news_feed').doc(postId);

                            if (isLiked) {
                              // Dislike logic
                              await docRef.update({
                                'likes': FieldValue.increment(-1),
                                'liked_users': FieldValue.arrayRemove([userUid]),
                              });
                            } else {
                              // Like logic
                              await docRef.update({
                                'likes': FieldValue.increment(1),
                                'liked_users': FieldValue.arrayUnion([userUid]),
                              });
                            }
                          },
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
                      'By $author',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const Spacer(),
                    Text(
                      '${createdAt.day}/${createdAt.month}/${createdAt.year}',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
          onPressed: () async {
            if (commentController.text.isNotEmpty) {
              final docRef = FirebaseFirestore.instance.collection('news_feed').doc(postId);

              await docRef.update({
                'comments': FieldValue.arrayUnion([
                  {
                    'user': userUid,
                    'comment': commentController.text,
                    'timestamp': Timestamp.now(),
                  }
                ]),
                'commented_users': FieldValue.arrayUnion([userUid]),
              });

              Navigator.pop(context);
            }
          },
          child: const Text('Post', style: TextStyle(color: Colors.blue),),
        ),
      ],
    ),
  );
}
}
