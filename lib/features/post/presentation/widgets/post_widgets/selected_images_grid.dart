import 'dart:io';
import 'package:flutter/material.dart';

class SelectedImagesGrid extends StatelessWidget {
  final List<File> imageFiles;
  final Function(int) onRemove;

  const SelectedImagesGrid({
    super.key,
    required this.imageFiles,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final int displayCount = imageFiles.length > 3 ? 3 : imageFiles.length;
    final int remainingCount = imageFiles.length - 3;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final bool showOverlay = index == 2 && remainingCount > 0;

        return Stack(
          children: [
            // عرض الصورة
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFiles[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // الطبقة الضبابية مع العداد (تظهر فقط على الصورة الثالثة إذا في صور زيادة)
            if (showOverlay)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55), // تغبيش أسود شفاف
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '+$remainingCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            // زر الحذف (إشارة الـ X من فوق)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => onRemove(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}