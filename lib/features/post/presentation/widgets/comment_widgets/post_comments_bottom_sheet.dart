import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/injection_container.dart';
import '../../bloc/comment_bloc/comment_bloc.dart';
import '../../bloc/comment_bloc/comment_event.dart';
import '../../bloc/comment_bloc/comment_state.dart';
import 'comment_card.dart';
import 'comment_input_field.dart';

class PostCommentsBottomSheet extends StatefulWidget {
  final String postId;

  const PostCommentsBottomSheet({super.key, required this.postId});

  static void show(BuildContext context, String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PostCommentsBottomSheet(postId: postId),
    );
  }

  @override
  State<PostCommentsBottomSheet> createState() => _PostCommentsBottomSheetState();
}

class _PostCommentsBottomSheetState extends State<PostCommentsBottomSheet> {
  String? _selectedParentCommentId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<CommentsBloc>(
      create: (context) => sl<CommentsBloc>()..add(WatchCommentsEvent(widget.postId)),
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'التعليقات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const Divider(thickness: 0.5),
              Expanded(
                child: BlocBuilder<CommentsBloc, CommentsState>(
                  buildWhen: (previous, current) => current is CommentsLoading || current is CommentsLoaded || current is CommentsError,
                  builder: (context, state) {
                    if (state is CommentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is CommentsLoaded) {
                      if (state.comments.isEmpty) {
                        return Center(
                          child: Text(
                            'كن أول من يعلق على هذا المنشور',
                            style: TextStyle(color: theme.hintColor),
                          ),
                        );
                      }

                      final mainComments = state.comments.where((c) => c.parentCommentId == null).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: mainComments.length,
                        itemBuilder: (context, index) {
                          final mainComment = mainComments[index];
                          final replies = state.comments.where((c) => c.parentCommentId == mainComment.id).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommentCard(
                                comment: mainComment,
                                onDelete: () {
                                  _showDeleteDialog(context, context.read<CommentsBloc>(), mainComment.id);
                                },
                                onReply: () {
                                  setState(() {
                                    _selectedParentCommentId = mainComment.id;
                                  });
                                },
                              ),
                              if (replies.isNotEmpty)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 18),
                                    Container(
                                      width: 2,
                                      height: replies.length * 56.0,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      color: theme.dividerColor.withOpacity(0.4),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        children: replies.map((reply) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: CommentCard(
                                              comment: reply,
                                              onDelete: () {
                                                _showDeleteDialog(context, context.read<CommentsBloc>(), reply.id);
                                              },
                                              onReply: () {
                                                setState(() {
                                                  _selectedParentCommentId = mainComment.id;
                                                });
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          );
                        },
                      );
                    } else if (state is CommentsError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              if (_selectedParentCommentId != null)
                Container(
                  color: theme.colorScheme.surfaceContainerHigh,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      const Text('أنت ترد على هذا التعليق الآن', style: TextStyle(fontSize: 12)),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () {
                          setState(() {
                            _selectedParentCommentId = null;
                          });
                        },
                      )
                    ],
                  ),
                ),
              Builder(
                builder: (blocContext) {
                  return CommentInputField(
                    postId: widget.postId,
                    parentCommentId: _selectedParentCommentId,
                    onCommentAdded: () {
                      blocContext.read<CommentsBloc>().add(WatchCommentsEvent(widget.postId));
                      if (_selectedParentCommentId != null) {
                        setState(() {
                          _selectedParentCommentId = null;
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, CommentsBloc commentsBloc, String commentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف التعليق'),
        content: const Text('هل أنت متأكد من رغبتك في حذف هذا التعليق؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              commentsBloc.add(DeleteCommentEvent(commentId));
              Navigator.pop(dialogContext);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}