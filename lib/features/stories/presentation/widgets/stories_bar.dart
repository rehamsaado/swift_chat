import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entity/story_entity.dart';
import '../blocs/story_bloc.dart';
import '../blocs/story_event.dart';
import '../blocs/story_state.dart';
import '../pages/create_text_story_page.dart';
import '../pages/story_display_page.dart';
import 'add_story_bottom_sheet.dart';
import 'story_circle.dart';

class StoriesBar extends StatefulWidget {
  const StoriesBar({super.key});

  @override
  State<StoriesBar> createState() => _StoriesBarState();
}

class _StoriesBarState extends State<StoriesBar> {
  @override
  void initState() {
    super.initState();
    context.read<StoryBloc>().add(GetActiveStoriesEvent());
  }

  void _openAddStorySheet() {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddStoryBottomSheet(
        onTextTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTextStoryPage(),
            ),
          );
        },
        onImageTap: () {
          Navigator.pop(context);
          print("نفتح المعرض");
        },
      ),
    );
  }

  void _showMyStoryOptions(List<dynamic> myStories) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(
                Icons.remove_red_eye_outlined,
                color: theme.colorScheme.onSurface,
              ),
              title: Text(
                "عرض قصتك",
                style: TextStyle(color: theme.colorScheme.onSurface),
              ),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoryDisplayScreen(
                      stories: List<StoryEntity>.from(myStories),
                      initialIndex: 0,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
              title: Text(
                "إضافة قصة جديدة",
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _openAddStorySheet();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? _myUserId = Supabase.instance.client.auth.currentUser?.id;
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: BlocBuilder<StoryBloc, StoryState>(
        builder: (stateContext, state) {
          if (state is StoryLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          if (state is StoryError) {
            return Center(
              child: Text(
                "خطأ في التحميل",
                style: TextStyle(color: theme.colorScheme.error),
              ),
            );
          }

          if (state is StoryLoaded) {
            final myCleanId = _myUserId?.trim().toLowerCase();

            final Map<String, List<StoryEntity>> groupedStories = {};

            for (var story in state.stories) {
              final storyUserId = story.userId.trim().toLowerCase();
              if (storyUserId != myCleanId) {
                if (!groupedStories.containsKey(storyUserId)) {
                  groupedStories[storyUserId] = [];
                }
                groupedStories[storyUserId]!.add(story);
              }
            }

            final List<List<StoryEntity>> usersStoriesList = groupedStories
                .values
                .toList();

            final myStories = state.stories.where((story) {
              return story.userId.trim().toLowerCase() == myCleanId;
            }).toList();

            final bool hasMyStory = myStories.isNotEmpty;
            final myActiveStory = hasMyStory ? myStories.first : null;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: usersStoriesList.length + 1,
              itemBuilder: (listViewContext, index) {
                if (index == 0) {
                  return StoryCircle(
                    isMe: true,
                    story: myActiveStory,
                    onAddTap: () {
                      _openAddStorySheet();
                    },
                    onTap: () {
                      if (hasMyStory) {
                        _showMyStoryOptions(myStories);
                      } else {
                        _openAddStorySheet();
                      }
                    },
                  );
                }

                final List<StoryEntity> userStories =
                usersStoriesList[index - 1];
                final displayStory = userStories.first;

                return StoryCircle(
                  story: displayStory,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryDisplayScreen(
                          stories: userStories,
                          initialIndex:
                          0,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}