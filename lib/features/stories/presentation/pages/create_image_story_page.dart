import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/story_bloc.dart';
import '../blocs/story_event.dart';
import '../blocs/story_state.dart';

class CreateImageStoryPage extends StatefulWidget {
  final String imagePath;

  const CreateImageStoryPage({super.key, required this.imagePath});

  @override
  State<CreateImageStoryPage> createState() => _CreateImageStoryPageState();
}

class _CreateImageStoryPageState extends State<CreateImageStoryPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "قصة مصورة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<StoryBloc, StoryState>(
        listener: (context, state) {

          if (state is StoryLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تم نشر قصتك المصورة بنجاح! 🎉"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }

          else if (state is StoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("خطأ: ${state.message}"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              bottom: 40,
              right: 20,
              child: BlocBuilder<StoryBloc, StoryState>(
                builder: (context, state) {
                  final bool isLoading = state is StoryLoading;

                  return FloatingActionButton.extended(
                    backgroundColor: theme.colorScheme.primary,
                    onPressed: isLoading
                        ? null
                        : () {

                      context.read<StoryBloc>().add(
                        UploadImageStoryEvent(
                          filePath: widget.imagePath,
                          caption: null, 
                        ),
                      );
                    },
                    label: isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Row(
                      children: [
                        Text(
                          "نشر الآن",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.send, color: Colors.white, size: 18),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}