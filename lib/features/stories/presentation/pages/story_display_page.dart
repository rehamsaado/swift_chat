import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entity/story_entity.dart';
import '../blocs/story_bloc.dart';
import '../blocs/story_event.dart';
import '../widgets/story_content_view.dart';
import '../widgets/story_viewers_bottom_sheet.dart';

class StoryDisplayScreen extends StatefulWidget {
  final List<StoryEntity> stories;
  final int initialIndex;

  const StoryDisplayScreen({
    super.key,
    required this.stories,
    required this.initialIndex,
  });

  @override
  State<StoryDisplayScreen> createState() => _StoryDisplayScreenState();
}

class _StoryDisplayScreenState extends State<StoryDisplayScreen> {
  late PageController _pageController;
  late int _currentIndex;

  final String? _myUserId = Supabase.instance.client.auth.currentUser?.id;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    _markAsViewed(_currentIndex);
  }

  void _markAsViewed(int index) {
    final storyId = widget.stories[index].id;
    context.read<StoryBloc>().add(MarkStoryAsViewedEvent(storyId));
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStory = widget.stories[_currentIndex];
    final bool isMyStory = currentStory.userId.trim().toLowerCase() == _myUserId?.trim().toLowerCase();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.stories.length,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              _markAsViewed(index);
            },
            itemBuilder: (context, index) {
              return StoryContentView(story: widget.stories[index]);
            },
          ),
          Positioned.fill(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _previousStory,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _nextStory,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 10,
            right: 10,
            child: Column(
              children: [
                _buildProgressBar(),
                const SizedBox(height: 10),
                _buildHeader(currentStory, theme),
              ],
            ),
          ),
          if (isMyStory)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => StoryViewersBottomSheet(
                        storyId: currentStory.id,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white..withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.remove_red_eye_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          "المشاهدات",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(widget.stories.length, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: LinearProgressIndicator(
              value: index <= _currentIndex ? 1.0 : 0.0,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 2,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(StoryEntity story, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          backgroundImage: story.avatarUrl != null
              ? NetworkImage(story.avatarUrl!)
              : null,
          child: story.avatarUrl == null
              ? Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant, size: 18)
              : null,
        ),
        const SizedBox(width: 10),
        Text(
          story.fullName ?? "مخدم غير معروف",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}