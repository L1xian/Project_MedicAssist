import 'package:blog_app/features/posts/domain/post.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/core/utils/format_date.dart';

class CommentSection extends StatefulWidget {
  final Post blog;
  const CommentSection({super.key, required this.blog});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();

  // Mock comments for testing UI
  final List<Map<String, dynamic>> _comments = [
    {
      'userName': 'John Doe',
      'content': 'Great post! Very informative.',
      'updatedAt': DateTime.now().subtract(const Duration(hours: 1)),
      'avatarUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=John',
    },
    {
      'userName': 'Jane Smith',
      'content': 'I learned a lot from this. Thanks for sharing!',
      'updatedAt': DateTime.now().subtract(const Duration(minutes: 30)),
      'avatarUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Jane',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _comments.insert(0, {
          'userName': 'Me', // Placeholder for logged-in user
          'content': _commentController.text.trim(),
          'updatedAt': DateTime.now(),
          'avatarUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Me',
        });
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppPallete.backgroundColor : Colors.white;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Drag Handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: AppPallete.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Comments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _comments.isEmpty
                  ? Center(
                      child: Text(
                        'No comments yet.',
                        style: TextStyle(color: AppPallete.greyColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(comment['avatarUrl']),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment['userName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                formatDateBydMMMYYYY(comment['updatedAt']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppPallete.greyColor,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            comment['content'],
                            style: TextStyle(color: textColor),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(color: AppPallete.greyColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: isDark ? AppPallete.surfaceColor : Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      style: TextStyle(color: textColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _addComment,
                    icon: const Icon(Icons.send, color: AppPallete.primaryColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}