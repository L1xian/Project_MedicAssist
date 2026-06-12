import 'package:blog_app/features/posts/domain/post.dart'; 
import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:blog_app/core/utils/format_date.dart'; // Assuming you have this utility
import 'package:blog_app/features/posts/presentation/widgets/comment_section.dart';
import 'package:blog_app/features/posts/presentation/bloc/blog_bloc.dart';


class XPostCard extends StatelessWidget {
  final Post blog; // Changed type from Blog to Post
  final VoidCallback? onBookAppointment; // New parameter

  const XPostCard({
    super.key, // Added key parameter
    required this.blog,
    this.onBookAppointment, // Make it optional
  });

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentSection(blog: blog),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? AppPallete.whiteColor : Colors.black87;
    final Color mutedColor = isDark ? AppPallete.greyColor : (Colors.grey[600] ?? Colors.black); // Ensure mutedColor is non-nullable

    // Placeholder for avatar - ideally, this would come from the user data
    final String avatarUrl = 'https://api.dicebear.com/7.x/avataaars/svg?seed=${blog.posterId}';

    return InkWell(
      onTap: () {
        // Handle tap to view full post or navigate to detail page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped on post by ${blog.posterName ?? 'Unknown User'}')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: AppPallete.borderColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Info (Name, Handle, Time)
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          blog.posterName ?? 'Unknown User',
                          overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '• ${formatDateBydMMMYYYY(blog.updatedAt)}', // Assuming formatDateBydMMMYYYY exists
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Post Content
                  Text(
                    blog.content,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      height: 1.4,
                    ),
                    maxLines: 5, // Limit lines for preview
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (blog.imageUrl.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        blog.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 150,
                          color: AppPallete.borderColor.withOpacity(0.3),
                          child: Center(
                            child: Icon(Icons.broken_image, color: mutedColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Status indicator (used for Pending/Denied mock posts)
                  Builder(
                    builder: (context) {
                      final String? status = blog.topics
                          .map((t) => t.toLowerCase())
                          .contains('pending')
                          ? 'pending'
                          : (blog.topics
                                  .map((t) => t.toLowerCase())
                                  .contains('denied')
                              ? 'denied'
                              : null);

                      if (status != null) {
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  status == 'pending'
                                      ? Icons.hourglass_empty
                                      : Icons.cancel,
                                  color: status == 'pending'
                                      ? Colors.orange
                                      : Colors.red,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  status == 'pending' ? 'Pending' : 'Denied',
                                  style: TextStyle(
                                    color: status == 'pending'
                                        ? Colors.orange
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      // Default: Action Buttons (Placeholder)
                      return const SizedBox.shrink();
                    },
                  ),


                  // Hide replies/shares/bookmark icons for Pending/Denied posts
                  Builder(
                    builder: (context) {
                      final lowerTopics = blog.topics.map((t) => t.toLowerCase()).toList();
                      final bool isPending = lowerTopics.contains('pending');
                      final bool isDenied = lowerTopics.contains('denied');

                      if (isPending || isDenied) return const SizedBox.shrink();

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildActionButton(
                            Icons.chat_bubble_outline,
                            '12',
                            mutedColor,
                            onTap: () => _showComments(context),
                          ),
                          _buildActionButton(Icons.repeat, '5', mutedColor), // Repost/Retweet (Placeholder)
                          _buildActionButton(
                            Icons.favorite_border,
                            '23',
                            mutedColor,
                            onTap: () => context.read<PostsBloc>().add(
                                  PostsToggleLike(
                                    postId: blog.posterId,
                                    isCurrentlyLiked: false,
                                  ),
                                ),
                          ), // Like (dispatch)
                          _buildActionButton(
                            Icons.bookmark_border,
                            '',
                            mutedColor,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Saved "${blog.title}" to your bookmarks'),
                                ),
                              );
                            },
                          ), // Bookmark (local UI)

                          _buildActionButton(Icons.share, '', mutedColor),
                        ],
                      );
                    },
                  ),
                  if (onBookAppointment != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onBookAppointment,
                        icon: const Icon(Icons.calendar_today, color: Colors.white),
                        label: const Text(
                          'Book Appointment',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPallete.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count, Color color, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            if (count.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(count, style: TextStyle(color: color, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}