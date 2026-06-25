import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/story_bloc.dart';
import '../blocs/story_event.dart';

class CreateTextStoryPage extends StatefulWidget {
  const CreateTextStoryPage({super.key});

  @override
  State<CreateTextStoryPage> createState() => _CreateTextStoryPageState();
}

class _CreateTextStoryPageState extends State<CreateTextStoryPage> {
  final TextEditingController _textController = TextEditingController();

  late List<Color> _backgroundColors;
  int _colorIndex = 0;
  bool _isColorsInitialized = false;

  void _submitStory() {
    if (_textController.text.trim().isNotEmpty) {

      final int colorValue = _backgroundColors[_colorIndex].toARGB32();


      String hexColor =
          '0xFF${colorValue.toRadixString(16).substring(2).toUpperCase()}';
      context.read<StoryBloc>().add(
        UploadTextStoryEvent(
          text: _textController.text.trim(),
          backgroundColor: hexColor,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!_isColorsInitialized) {
      _backgroundColors = [
        theme.colorScheme.primary,
        Colors.black,
        Colors.blueAccent,
        Colors.purple,
        Colors.teal,
        Colors.deepOrange,
      ];
      _isColorsInitialized = true;
    }

    final Color currentBgColor = _backgroundColors[_colorIndex];
    final Color contentColor =
        ThemeData.estimateBrightnessForColor(currentBgColor) == Brightness.light
        ? Colors.black
        : Colors.white;

    return Scaffold(
      backgroundColor: currentBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: contentColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.palette_outlined, color: contentColor),
            onPressed: () {
              setState(() {
                _colorIndex = (_colorIndex + 1) % _backgroundColors.length;
              });
            },
          ),
          TextButton(
            onPressed: _submitStory,
            child: Text(
              "نشر",
              style: TextStyle(
                color: contentColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            controller: _textController,
            autofocus: true,
            textAlign: TextAlign.center,
            maxLines: null,
            cursorColor: contentColor,
            style: TextStyle(
              color: contentColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: "اكتب قصتك هنا...",
              hintStyle: TextStyle(color: contentColor..withValues(alpha: 0.5)),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
