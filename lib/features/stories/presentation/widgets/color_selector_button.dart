import 'package:flutter/material.dart';

class ColorSelectorButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color currentColor;

  const ColorSelectorButton({super.key, required this.onTap, required this.currentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: theme.colorScheme.onSurface.withOpacity(0.12),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentColor,
            border: Border.all(color: theme.colorScheme.surface, width: 2),
          ),
        ),
      ),
    );
  }
}