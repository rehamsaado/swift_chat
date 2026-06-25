import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String fullName;
  final bool isLoading;
  final VoidCallback? onEditTap;
  final double size;
  final bool showStatus;

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    required this.fullName,
    this.isLoading = false,
    this.onEditTap,
    this.size = 130.0,
    this.showStatus = false,
  });

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "?";
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    } else {
      return nameParts[0][0].toUpperCase();
    }
  }

  Color _getBackgroundColor(String name) {
    final colors = [
      Colors.blueAccent,
      Colors.greenAccent[700]!,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.teal,
    ];
    return colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getBackgroundColor(fullName),
            border: Border.all(color: Colors.white, width: size * 0.03),
            boxShadow: [
              if (size > 60)
                BoxShadow(
                  color: Colors.black..withValues(alpha: 0.5),
                  spreadRadius: 2,
                  blurRadius: 10,
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: (imageUrl != null && imageUrl!.isNotEmpty)
                ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildInitials(),
            )
                : _buildInitials(),
          ),
        ),


        if (isLoading)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black..withValues(alpha: 0.5),
            ),
            child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
          ),


        if (showStatus)
          Positioned(
            bottom: size * 0.05,
            right: size * 0.05,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),


        if (onEditTap != null && !isLoading)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: EdgeInsets.all(size * 0.08),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
                child: Icon(Icons.camera_alt, color: Colors.white, size: size * 0.18),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _getInitials(fullName),
        style: TextStyle(
          fontSize: size * 0.4,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}