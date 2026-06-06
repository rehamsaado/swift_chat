import 'package:flutter/material.dart';

class AddStoryBottomSheet extends StatelessWidget {
  final VoidCallback onTextTap;
  final VoidCallback onImageTap;

  const AddStoryBottomSheet({
    super.key,
    required this.onTextTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "إضافة قصة جديدة",
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _OptionItem(
                icon: Icons.edit,
                label: "نص",
                color: Colors.orange,
                onTap: onTextTap,
              ),
              _OptionItem(
                icon: Icons.image,
                label: "صورة",
                color: Colors.blue,
                onTap: onImageTap,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color..withValues(alpha: 0.5),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}