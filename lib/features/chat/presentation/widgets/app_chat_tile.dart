import 'package:flutter/material.dart';
import 'package:swift_chat/features/chat/presentation/widgets/profile_widget/profile_image_widget.dart';
import '../../../../core/theme/constants/app_colors.dart';


class AppChatTile extends StatelessWidget {
  final String title;
  final String subTitle;
  final String time;
  final String imageUrl;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback onTap;

  const AppChatTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.time,
    required this.imageUrl,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // نستخدم Theme.of لضمان دعم الـ Dark/Light Mode تلقائياً
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ProfileImageWidget(
        imageUrl: imageUrl,
        fullName: title, // نمرر اسم الشخص
        size: 55,        // حجم مناسب للقائمة
        showStatus: isOnline, // نظهر حالة الـ Online
      ),
      // // 1. الأفاتار مع حالة الاتصال
      // leading: AppAvatarWidget(
      //   imageUrl: imageUrl,
      //   isStatusShown: isOnline,
      //   radius: 28, name: title, // حجم مناسب للقائمة
      // ),
      // 2. اسم المستخدم
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // 3. آخر رسالة
      subtitle: Text(
        subTitle,
        style: textTheme.bodyMedium?.copyWith(
          color: unreadCount > 0 ? AppColors.primary : AppColors.gray500,
          fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // 4. الوقت وعدد الرسائل غير المقروءة
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: textTheme.labelSmall?.copyWith(
              color: unreadCount > 0 ? AppColors.primary : AppColors.gray400,
            ),
          ),
          const SizedBox(height: 4),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}