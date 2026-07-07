import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/injection_container.dart';
import '../../../post/presentation/bloc/post_bloc/post_bloc.dart';
import '../../../post/presentation/bloc/post_bloc/post_event.dart';
import '../../../post/presentation/bloc/post_bloc/post_state.dart';
import '../../../post/presentation/widgets/comment_widgets/post_comments_bottom_sheet.dart';
import '../../../post/presentation/widgets/post_widgets/post_card.dart';
import '../../../post/presentation/widgets/post_widgets/post_options_bottom_sheet.dart';

class UserPostsSection extends StatelessWidget {
  final String userId;

  const UserPostsSection({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsBloc>(
      create: (context) => sl<PostsBloc>()..add(WatchPostsEvent()),
      child: BlocBuilder<PostsBloc, PostsState>(
        buildWhen: (previous, current) =>
        current is PostsLoading ||
            current is PostsLoaded ||
            current is PostsError,
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (state is PostsLoaded) {
            final myPosts = state.posts.where((post) => post.userId == userId).toList();

            if (myPosts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    'لا توجد منشورات لهذا المستخدم بعد.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myPosts.length,
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemBuilder: (context, index) {
                final post = myPosts[index];
                return PostCard(
                  post: post,
                  onCommentPressed: () {
                    PostCommentsBottomSheet.show(context, post.id);
                  },
                  onOptionsPressed: () {
                    PostOptionsBottomSheet.show(
                      context,
                      post: post,
                      postsBloc: context.read<PostsBloc>(),
                    );
                  },
                );
              },
            );
          } else if (state is PostsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}