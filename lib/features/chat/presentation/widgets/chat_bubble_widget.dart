import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/constants/app_colors.dart';
import '../pages/full_screen_image_page.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String type;
  final DateTime time;
  final String status;
  final bool isGroup;
  final String? senderName;
  final String? senderImageUrl;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.type,
    required this.time,
    required this.status,
    this.isGroup = false,
    this.senderName,
    this.senderImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = type == 'image';

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isMe ? 16 : 0),
      bottomRight: Radius.circular(isMe ? 0 : 16),
    );

    // حساب عرض الشاشة بدقة لمنع التمدد البشع
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.72;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isGroup && !isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blueGrey[50],
              backgroundImage: (senderImageUrl != null && senderImageUrl!.isNotEmpty)
                  ? NetworkImage(senderImageUrl!)
                  : null,
              child: (senderImageUrl == null || senderImageUrl!.isEmpty)
                  ? Text(
                (senderName ?? "?").isNotEmpty ? senderName![0].toUpperCase() : "?",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey[700]),
              )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxBubbleWidth),
              child: Column(

                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isGroup && !isMe && senderName != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4, right: 4),
                      child: Text(
                        senderName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  Container(
                    padding: isImage ? const EdgeInsets.all(4) : const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? AppColors.primary
                          : AppColors.getSurfaceColor(Theme.of(context).brightness),
                      borderRadius: borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: isImage
                        ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(imageUrl: message),
                          ),
                        );
                      },
                      child: Hero(
                        tag: message,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: message,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder: (context, url) => const SizedBox(
                              height: 200,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    )
                        : Text(
                      message,
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.getPrimaryTextColor(Theme.of(context).brightness),
                        fontSize: 15,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(fontSize: 10, color: AppColors.gray400),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (status) {
      case 'read':
        return const Icon(Icons.done_all, size: 14, color: Colors.blue);
      case 'delivered':
        return const Icon(Icons.done_all, size: 14, color: Colors.grey);
      case 'sent':
      default:
        return const Icon(Icons.done, size: 14, color: Colors.grey);
    }
  }
}