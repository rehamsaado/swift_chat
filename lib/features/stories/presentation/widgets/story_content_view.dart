import 'package:flutter/material.dart';
import '../../domain/entity/story_entity.dart';

class StoryContentView extends StatelessWidget {
  final StoryEntity story;

  const StoryContentView({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (story.contentType == 'image') {
      return Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            story.mediaUrl!,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
          if (story.caption != null && story.caption!.isNotEmpty)
            Positioned(
              bottom: 50,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black..withValues(alpha: 0.5),
                child: Text(
                  story.caption!,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
        ],
      );
    } else {
      return Container(
        color: story.backgroundColor != null
            ? Color(int.parse(story.backgroundColor!))
            : theme.colorScheme.primary,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Text(
          story.textContent ?? "",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}