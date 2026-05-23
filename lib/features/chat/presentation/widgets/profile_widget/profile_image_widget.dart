// import 'package:flutter/material.dart';
//
// class ProfileImageWidget extends StatelessWidget {
//   final String? imageUrl; // جعلناها تتقبل null
//   final String fullName; // نحتاج الاسم لجلب الحروف
//   final bool isLoading;
//   final VoidCallback? onEditTap;
//
//   const ProfileImageWidget({
//     super.key,
//     this.imageUrl,
//     required this.fullName,
//     required this.isLoading,
//     this.onEditTap,
//   });
//
//   // دالة مساعدة للحصول على أول حرفين من الاسم
//   String _getInitials(String name) {
//     if (name.isEmpty) return "U"; // User افتراضي
//     List<String> nameParts = name.trim().split(' ');
//     if (nameParts.length > 1) {
//       // إذا كان الاسم يتكون من مقطعين (اسم أول وعائلة)
//       return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
//     } else {
//       // إذا كان مقطعاً واحداً، نأخذ أول حرفين منه
//       return name.substring(0, name.length > 1 ? 2 : 1).toUpperCase();
//     }
//   }
//
//   // دالة لتوليد لون خلفية عشوائي بناءً على الاسم (اختياري)
//   Color _getBackgroundColor(String name) {
//     final colors = [
//       Colors.blueAccent,
//       Colors.greenAccent[700]!,
//       Colors.orangeAccent,
//       Colors.purpleAccent,
//       Colors.teal,
//     ];
//     // نستخدم الـ hashCode للاسم لاختيار لون ثابت لنفس المستخدم
//     return colors[name.hashCode % colors.length];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const double avatarSize = 130.0;
//
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         // 1. عرض الصورة أو الأحرف الأولى
//         Container(
//           width: avatarSize,
//           height: avatarSize,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: _getBackgroundColor(fullName), // لون الخلفية في حال عدم وجود صورة
//             border: Border.all(color: Colors.white, width: 4),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 2,
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(avatarSize / 2),
//             child: (imageUrl != null && imageUrl!.isNotEmpty)
//                 ? Image.network(
//               imageUrl!,
//               fit: BoxFit.cover,
//               // في حال فشل تحميل الصورة، نظهر الأحرف
//               errorBuilder: (context, error, stackTrace) => _buildInitials(),
//             )
//                 : _buildInitials(),
//           ),
//         ),
//
//         // 2. مؤشر التحميل (Spinner) فوق الصورة
//         if (isLoading)
//           Container(
//             width: avatarSize,
//             height: avatarSize,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.black.withOpacity(0.5),
//             ),
//             child: const Center(
//               child: CircularProgressIndicator(color: Colors.white),
//             ),
//           ),
//
//         // 3. أيقونة تعديل الصورة (الكاميرا)
//         if (onEditTap != null && !isLoading)
//           Positioned(
//             bottom: 0,
//             right: 0,
//             child: InkWell(
//               onTap: onEditTap,
//               child: Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.blueAccent,
//                 ),
//                 child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   // ودجت الأحرف الأولى
//   Widget _buildInitials() {
//     return Center(
//       child: Text(
//         _getInitials(fullName),
//         style: const TextStyle(
//           fontSize: 48,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//           letterSpacing: 2,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final String fullName;
  final bool isLoading;
  final VoidCallback? onEditTap;
  final double size; // أضفنا التحكم في الحجم
  final bool showStatus; // أضفنا حالة الاتصال (Online/Offline)

  const ProfileImageWidget({
    super.key,
    this.imageUrl,
    required this.fullName,
    this.isLoading = false,
    this.onEditTap,
    this.size = 130.0, // القيمة الافتراضية للبروفايل
    this.showStatus = false, // افتراضياً لا تظهر إلا لو حددنا
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
        // الدائرة الأساسية
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getBackgroundColor(fullName),
            border: Border.all(color: Colors.white, width: size * 0.03), // تناسب السماكة مع الحجم
            boxShadow: [
              if (size > 60) // نضع ظل فقط في الأحجام الكبيرة (البروفايل)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
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

        // مؤشر التحميل
        if (isLoading)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.4),
            ),
            child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
          ),

        // حالة الاتصال (للقائمة)
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

        // أيقونة التعديل (للبروفايل)
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