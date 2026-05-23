import 'package:flutter/material.dart';
import '../widgets/stories_bar.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("الحالات"),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const StoriesBar(),
            Divider(
              color: theme.dividerTheme.color ?? theme.hintColor.withOpacity(0.2),
              thickness: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                "لا توجد تحديثات جديدة",
                style: TextStyle(color: theme.hintColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}