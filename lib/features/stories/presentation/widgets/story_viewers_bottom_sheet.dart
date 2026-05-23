import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/story_bloc.dart';
import '../blocs/story_event.dart';
import '../blocs/story_state.dart';

class StoryViewersBottomSheet extends StatefulWidget {
  final String storyId;

  const StoryViewersBottomSheet({super.key, required this.storyId});

  @override
  State<StoryViewersBottomSheet> createState() =>
      _StoryViewersBottomSheetState();
}

class _StoryViewersBottomSheetState extends State<StoryViewersBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<StoryBloc>().add(GetStoryViewersEvent(widget.storyId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: theme.dividerTheme.color ?? theme.hintColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "المشاهدات",
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: BlocBuilder<StoryBloc, StoryState>(
              builder: (context, state) {
                if (state is StoryViewersLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  );
                }

                if (state is StoryViewersError) {
                  return Center(
                    child: Text(
                      "فشل جلب المشاهدين: ${state.message}",
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  );
                }

                if (state is StoryViewersLoaded) {
                  final viewers = state.viewers;

                  if (viewers.isEmpty) {
                    return Center(
                      child: Text(
                        "لا توجد مشاهدات بعد 👁️",
                        style: TextStyle(color: theme.hintColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: viewers.length,
                    itemBuilder: (context, index) {
                      final viewerData = viewers[index];
                      final profile =
                      viewerData['profiles'] as Map<String, dynamic>?;
                      final String fullName =
                          profile?['full_name'] ?? "مستخدم غير معروف";
                      final String? avatarUrl = profile?['avatar_url'];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl == null
                              ? Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant)
                              : null,
                        ),
                        title: Text(
                          fullName,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.remove_red_eye_outlined,
                          color: theme.hintColor,
                          size: 20,
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}