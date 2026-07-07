import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection_container.dart';
import '../../../post/presentation/bloc/post_bloc/post_bloc.dart';
import '../../../post/presentation/bloc/post_bloc/post_event.dart';
import '../../../post/presentation/bloc/post_bloc/post_state.dart';
import '../../../post/presentation/widgets/post_widgets/post_card.dart';
import '../widgets/stories_bar.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<PostsBloc>(
      create: (context) => sl<PostsBloc>()..add(WatchPostsEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "الصفحة الرئيسية",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: theme.colorScheme.onPrimary,

            ),
          ),
          backgroundColor: theme.colorScheme.secondary,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const StoriesBar(),
                  Divider(
                    color: theme.dividerTheme.color ?? theme.hintColor.withOpacity(0.2),
                    thickness: 0.5,
                  ),
                ],
              ),
            ),
            BlocBuilder<PostsBloc, PostsState>(
              builder: (context, state) {
                if (state is PostsLoading) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  );
                } else if (state is PostsLoaded) {
                  if (state.posts.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "لا توجد منشورات بعد",
                          style: TextStyle(color: theme.hintColor),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final post = state.posts[index];
                        return PostCard(
                          post: post,
                          onCommentPressed: () {},
                          onOptionsPressed: () {},
                        );
                      },
                      childCount: state.posts.length,
                    ),
                  );
                } else if (state is PostsError) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }
}