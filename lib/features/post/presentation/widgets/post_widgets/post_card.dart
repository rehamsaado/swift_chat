import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/post_entity.dart';
import 'post_header.dart';
import 'post_content.dart';
import 'post_actions.dart';

class PostCard extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onCommentPressed;
  final VoidCallback? onOptionsPressed;

  const PostCard({
    super.key,
    required this.post,
    required this.onCommentPressed,
    this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isMyPost = post.userId == currentUserId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      elevation: 0.5,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            post: post,
            onOptionsPressed: isMyPost ? onOptionsPressed : null,
          ),
          PostContent(post: post),
          const SizedBox(height: 8),
          PostActions(post: post, onCommentPressed: onCommentPressed),
        ],
      ),
    );
  }
}
