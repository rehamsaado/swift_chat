import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/constants/app_colors.dart';
import '../pages/full_screen_image_page.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String type;
  final DateTime time;
  final String status; // الحقل الجديد (sent, delivered, read)

  const ChatBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.type,
    required this.time,
    required this.status,
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

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // --- الجزء الذي كان محذوفاً (محتوى الرسالة) ---
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: isImage ? const EdgeInsets.all(4) : const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.primary
                  : AppColors.getSurfaceColor(Theme.of(context).brightness),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isImage)
                  GestureDetector(
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
                else
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : AppColors.getPrimaryTextColor(Theme.of(context).brightness),
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
          // --- نهاية الجزء المحذوف ---

          // منطقة الوقت والحالة (التي أضفناها سابقاً)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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