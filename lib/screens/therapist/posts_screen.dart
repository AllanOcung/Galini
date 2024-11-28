import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galini/screens/therapist/news_feed_screen.dart';

class TherapistPostsScreen extends StatefulWidget {
  const TherapistPostsScreen({Key? key}) : super(key: key);

  @override
  _TherapistPostsScreenState createState() => _TherapistPostsScreenState();
}

class _TherapistPostsScreenState extends State<TherapistPostsScreen> {
  String? therapistName;
  String? therapistUid;

  @override
  void initState() {
    super.initState();
    _fetchTherapistData();
  }

  // Fetch therapist data (name and UID)
  Future<void> _fetchTherapistData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        therapistUid = currentUser.uid;

        final therapistDoc = await FirebaseFirestore.instance
            .collection('therapist_requests')
            .doc(therapistUid)
            .get();

        if (therapistDoc.exists) {
          therapistName = therapistDoc.data()?['name'] ?? 'Unknown Therapist';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching therapist data: $e')),
      );
    } finally {
      setState(() {});
    }
  }

  // Delete post by ID
  Future<void> _deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('news_feed').doc(postId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting post: $e')),
      );
    }
  }

  // Navigate to edit post screen
  void _navigateToEditPost(String postId, String title, String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostScreen(
          postId: postId,
          currentTitle: title,
          currentContent: content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (therapistUid == null) {
      // Show a loading indicator while therapist data is being fetched
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Posts', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: const Color(0xFF7D99AA),
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back arrow color here
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('news_feed')
            .where('authorId', isEqualTo: therapistUid) // Fetch posts by this therapist
            //.orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No posts available.'));
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return Card(
                color: Colors.white,
                elevation: 8.0, // Set the elevation to control the shadow intensity
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Row(
                          children: [Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            post['title'] ?? 'Untitled',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),
                        ),
                        const SizedBox(width: 130),
                        IconButton(
                          color: const Color(0xFF7D99AA),
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _navigateToEditPost(post.id, post['title'], post['content']);
                            },
                          ),                         
                          IconButton(
                            color: Colors.red,
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deletePost(post.id);
                            },
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        post['content'] ?? '',
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            color: const Color(0xFF7D99AA),
                            icon: const Icon(Icons.thumb_up),
                            onPressed: () {
                              // Like button logic
                            },
                          ),
                          Text('${post['likes'] ?? 0} Likes', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 20),
                          IconButton(
                            color: const Color(0xFF7D99AA),
                            icon: const Icon(Icons.comment),
                            onPressed: () {
                              // Comment button logic
                              _showCommentsModal(post.id);
                            },
                          ),
                          Text('${(post['comments'] as List<dynamic>?)?.length ?? 0} Comments', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewsScreen(),
            ),
          );
        }, // Navigate to create post screen
        backgroundColor: const Color(0xFF7D99AA),
        child: const Icon(Icons.add, color: Colors.white,), // Plus icon
      ),
    );
  }

  // Show comments modal
  void _showCommentsModal(String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.5, // Adjust this value for the modal height (50% of screen height)
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('news_feed').doc(postId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No comments found.'));
            }

            var postData = snapshot.data!.data() as Map<String, dynamic>;
            var comments = postData['comments'] as List<dynamic>? ?? [];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Modal header
                  Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    height: 5,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Comments',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: comments.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: Colors.grey),
                      itemBuilder: (context, index) {
                        var comment = comments[index] as Map<String, dynamic>;
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['comment'] ?? 'No content',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment['timestamp'] != null
                                      ? (comment['timestamp'] as Timestamp)
                                          .toDate()
                                          .toString()
                                      : 'No timestamp',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}


}

class EditPostScreen extends StatefulWidget {
  final String postId;
  final String currentTitle;
  final String currentContent;

  const EditPostScreen({
    Key? key,
    required this.postId,
    required this.currentTitle,
    required this.currentContent,
  }) : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.currentTitle;
    contentController.text = widget.currentContent;
  }

  // Update the post
  Future<void> _updatePost() async {
    try {
      await FirebaseFirestore.instance.collection('news_feed').doc(widget.postId).update({
        'title': titleController.text,
        'content': contentController.text,
        'updated_at': Timestamp.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Post',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
          ),
        backgroundColor: const Color(0xFF7D99AA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.black54),
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title', labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            TextField(
              style: const TextStyle(color: Colors.black54),
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content', labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7D99AA),
                foregroundColor: Colors.white,
              ),
              child: const Text('Update Post'),
            ),
          ],
        ),
      ),
    );
  }
}
