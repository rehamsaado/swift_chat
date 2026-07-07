import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/injection_container.dart';
import '../../bloc/post_bloc/post_bloc.dart';
import '../../bloc/post_bloc/post_event.dart';
import '../../bloc/post_bloc/post_state.dart';
import '../../widgets/comment_widgets/post_comments_bottom_sheet.dart';
import '../../widgets/post_widgets/post_card.dart';
import '../../widgets/post_widgets/post_options_bottom_sheet.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostsBloc>(
      create: (context) => sl<PostsBloc>()..add(WatchPostsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'آخر المنشورات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<PostsBloc, PostsState>(
          listener: (context, state) {

            if (state is PostActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'تم العملية بنجاح ',
                    style: TextStyle(fontFamily: 'Tajawal'),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              context.read<PostsBloc>().add(WatchPostsEvent());
            }
          },
          buildWhen: (previous, current) =>
              current is PostsLoading ||
              current is PostsLoaded ||
              current is PostsError,
          builder: (context, state) {
            if (state is PostsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostsLoaded) {
              if (state.posts.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد منشورات بعد.',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.posts.length,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemBuilder: (context, index) {
                  final post = state.posts[index];
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<PostsBloc>().add(WatchPostsEvent());
                        },
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
