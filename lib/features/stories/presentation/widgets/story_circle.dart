import 'package:flutter/material.dart';
import '../../domain/entity/story_entity.dart';

class StoryCircle extends StatelessWidget {
  final StoryEntity? story;
  final bool isMe;
  final VoidCallback onTap;
  final VoidCallback? onAddTap;

  const StoryCircle({
    super.key,
    this.story,
    this.isMe = false,
    required this.onTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasStory = story != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: onTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: hasStory ? theme.colorScheme.primary : theme.dividerTheme.color ?? theme.hintColor..withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: _getBackgroundColor(theme),
                    backgroundImage: (story?.avatarUrl != null)
                        ? NetworkImage(story!.avatarUrl!)
                        : null,
                    child: (story?.avatarUrl == null)
                        ? (story?.contentType == 'text'
                        ? TextStyle(color: theme.colorScheme.onPrimary).color != null
                        ? Icon(Icons.text_fields, color: theme.colorScheme.onPrimary, size: 20)
                        : const Icon(Icons.text_fields, color: Colors.white, size: 20)
                        : Icon(
                      Icons.person,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 28,
                    ))
                        : null,
                  ),
                ),
              ),
              if (isMe)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onAddTap ?? onTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: theme.colorScheme.onPrimary,
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Flexible(
            child: SizedBox(
              width: 65,
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  isMe ? "قصتك" : (story?.fullName ?? "مستخدم"),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (story?.contentType == 'text' && story?.backgroundColor != null) {
      try {
        return Color(int.parse(story!.backgroundColor!));
      } catch (e) {
        return theme.colorScheme.primary;
      }
    }
    return theme.colorScheme.surfaceContainerHighest;
  }
}