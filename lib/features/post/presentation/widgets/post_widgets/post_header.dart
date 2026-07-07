import 'package:flutter/material.dart';
import '../../../domain/entities/post_entity.dart';

class PostHeader extends StatelessWidget {
  final PostEntity post;
  final VoidCallback? onOptionsPressed;

  const PostHeader({
    super.key,
    required this.post,
    this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: post.userImageUrl.isNotEmpty
                ? NetworkImage(post.userImageUrl)
                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTime(post.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.grey),
            onPressed: onOptionsPressed,
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (duration.inDays > 0) {
      return 'قبل ${duration.inDays} ي';
    } else if (duration.inHours > 0) {
      return 'قبل ${duration.inHours} سا';
    } else if (duration.inMinutes > 0) {
      return 'قبل ${duration.inMinutes} د';
    } else {
      return 'الآن';
    }
  }
}