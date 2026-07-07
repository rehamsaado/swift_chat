import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/comment_model.dart';
import '../model/post_model.dart';
import '../model/user_reaction_model.dart';

abstract class PostsRemoteDataSource {
  Stream<List<PostModel>> getPosts();

  Future<void> createPost(String content, List<String> imageUrls);

  Future<void> updatePost(String postId, String content);

  Future<void> deletePost(String postId);

  Stream<List<CommentModel>> getPostComments(String postId);

  Future<void> addComment(
    String postId,
    String content, {
    String? parentCommentId,
  });

  Future<void> deleteComment(String commentId);

  Future<void> toggleLike(String postId);

  Future<List<UserReactionModel>> getPostReactions(String postId);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final SupabaseClient supabaseClient;

  const PostsRemoteDataSourceImpl(this.supabaseClient);

  String get _currentUserId => supabaseClient.auth.currentUser?.id ?? '';

  @override
  Stream<List<PostModel>> getPosts() {
    return supabaseClient
        .from('posts')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .asyncMap((event) async {
          final response = await supabaseClient
              .from('posts')
              .select(
                '*, profiles!posts_user_id_fkey(*), post_likes(user_id), comments(id)',
              )
              .order('created_at', ascending: false);

          return (response as List)
              .map((json) => PostModel.fromJson(json, _currentUserId))
              .toList();
        });
  }

  @override
  Future<void> createPost(String content, List<String> imageUrls) async {
    await supabaseClient.from('posts').insert({
      'content': content,
      'image_urls': imageUrls,
      'user_id': _currentUserId,
    });
  }

  @override
  Future<void> updatePost(String postId, String content) async {
    await supabaseClient
        .from('posts')
        .update({'content': content})
        .eq('id', postId);
  }

  @override
  Future<void> deletePost(String postId) async {
    await supabaseClient.from('posts').delete().eq('id', postId);
  }
  @override
  Stream<List<CommentModel>> getPostComments(String postId) {
    return supabaseClient
        .from('comments')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .order('created_at', ascending: true)
        .asyncMap((event) async {
      final response = await supabaseClient
          .from('comments')
          .select('*, profiles!comments_user_id_fkey(*)')
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => CommentModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<void> addComment(
    String postId,
    String content, {
    String? parentCommentId,
  }) async {
    await supabaseClient.from('comments').insert({
      'post_id': postId,
      'content': content,
      'user_id': _currentUserId,
      if (parentCommentId != null) 'parent_comment_id': parentCommentId,
    });
  }

  @override
  Future<void> deleteComment(String commentId) async {
    await supabaseClient.from('comments').delete().eq('id', commentId);
  }

  @override
  Future<void> toggleLike(String postId) async {
    final userId = _currentUserId;

    final existingLike = await supabaseClient
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existingLike != null) {
      await supabaseClient
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
    } else {
      await supabaseClient.from('post_likes').insert({
        'post_id': postId,
        'user_id': userId,
      });
    }
  }

  @override
  Future<List<UserReactionModel>> getPostReactions(String postId) async {
    final response = await supabaseClient
        .from('post_likes')
        .select('*, profiles(*)')
        .eq('post_id', postId);

    return (response as List)
        .map((json) => UserReactionModel.fromJson(json))
        .toList();
  }
}
