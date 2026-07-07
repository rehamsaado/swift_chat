import 'package:flutter/material.dart';
import '../../../domain/entities/post_entity.dart';

class PostContent extends StatefulWidget {
  final PostEntity post;

  const PostContent({super.key, required this.post});

  @override
  State<PostContent> createState() => _PostContentState();
}

class _PostContentState extends State<PostContent> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.post.content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              widget.post.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                letterSpacing: 0.1,
              ),
            ),
          ),
        if (widget.post.imageUrls.isNotEmpty) ...[
          const SizedBox(height: 4),
          if (widget.post.imageUrls.length == 1)
            _buildSingleImage(widget.post.imageUrls.first)
          else
            _buildImageSlider(widget.post.imageUrls),
        ],
      ],
    );
  }

  Widget _buildSingleImage(String url) {
    return ClipRRect(
      child: Image.network(
        url,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 250,
            color: Colors.grey[200],
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          color: Colors.grey[200],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<String> urls) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            itemCount: urls.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                urls[index],
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        if (urls.length > 1)
          Positioned(
            bottom: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                urls.length,
                    (index) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}