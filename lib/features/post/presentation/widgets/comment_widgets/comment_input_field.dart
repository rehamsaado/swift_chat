import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/comment_bloc/comment_bloc.dart';
import '../../bloc/comment_bloc/comment_event.dart';
import '../../bloc/comment_bloc/comment_state.dart';

class CommentInputField extends StatefulWidget {
  final String postId;
  final String? parentCommentId;
  final VoidCallback onCommentAdded;

  const CommentInputField({
    super.key,
    required this.postId,
    this.parentCommentId,
    required this.onCommentAdded,
  });

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<CommentsBloc, CommentsState>(
      listenWhen: (previous, current) => current is CommentActionSuccess,
      listener: (context, state) {
        if (state is CommentActionSuccess) {
          _commentController.clear();
          widget.onCommentAdded();
        }
      },
      buildWhen: (previous, current) => current is CommentActionLoading || current is CommentActionSuccess || current is CommentsError,
      builder: (context, state) {
        final isActionLoading = state is CommentActionLoading;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: widget.parentCommentId != null ? 'الرد على التعليق...' : 'اكتب تعليقاً...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
              isActionLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : IconButton(
                icon: Icon(Icons.send, color: theme.colorScheme.primary),
                onPressed: () {
                  final text = _commentController.text.trim();
                  if (text.isNotEmpty) {
                    context.read<CommentsBloc>().add(
                      AddCommentEvent(
                        postId: widget.postId,
                        content: text,
                        parentCommentId: widget.parentCommentId,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}