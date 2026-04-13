import 'package:blog_app/features/posts/domain/post.dart'; 
import 'package:blog_app/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/core/utils/format_date.dart'; // Assuming you have this utility

class XPostCard extends StatelessWidget {
  final Post blog; // Changed type from Blog to Post

  const XPostCard({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
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
                      Text(
                        blog.posterName ?? 'Unknown User', // Handle null posterName
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '@${(blog.posterName ?? 'unknown').toLowerCase().replaceAll(' ', '')}', // Handle null posterName
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 14,
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
                  // Action Buttons (Placeholder)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionButton(Icons.chat_bubble_outline, '12', mutedColor),
                      _buildActionButton(Icons.repeat, '5', mutedColor),
                      _buildActionButton(Icons.favorite_border, '23', mutedColor),
                      _buildActionButton(Icons.share, '', mutedColor),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(count, style: TextStyle(color: color, fontSize: 13)),
        ],
      ],
    );
  }
}