// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/theme/constants/app_colors.dart';
// import '../bloc/message_bloc/message_bloc.dart';
// import '../bloc/message_bloc/message_event.dart';
//
// class MessageInputBar extends StatefulWidget {
//   final String roomId;
//
//   const MessageInputBar({super.key, required this.roomId});
//
//   @override
//   State<MessageInputBar> createState() => _MessageInputBarState();
// }
//
// class _MessageInputBarState extends State<MessageInputBar> {
//   final TextEditingController _controller = TextEditingController();
//   final FocusNode _focusNode = FocusNode(); // لتحسين تجربة المستخدم
//
//   void _sendMessage() {
//     final text = _controller.text.trim();
//     if (text.isNotEmpty) {
//       // إرسال الرسالة باستخدام الـ ID الممرر (سواء كان ID غرفة أو مستخدم، الـ DataSource سيعالجه)
//       context.read<MessageBloc>().add(MessageSent(widget.roomId, text));
//
//       _controller.clear();
//
//       // إبقاء التركيز على حقل النص لسهولة الكتابة المستمرة
//       _focusNode.requestFocus();
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 20), // مسافة إضافية للأسفل
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         border: Border(
//           top: BorderSide(
//             color: AppColors.getDividerColor(Theme.of(context).brightness),
//             width: 0.5,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.image, color: AppColors.primary),
//             onPressed: () {
//               // لاحقاً: إضافة الصور
//             },
//           ),
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               focusNode: _focusNode,
//               onSubmitted: (_) => _sendMessage(),
//               textInputAction: TextInputAction.send, // تغيير زر الكيبورد لـ Send
//               decoration: InputDecoration(
//                 hintText: "اكتب رسالة...",
//                 hintStyle: const TextStyle(fontSize: 14),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey..withValues(alpha: 0.5)(0.1),
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: _sendMessage,
//             child: const CircleAvatar(
//               radius: 22,
//               backgroundColor: AppColors.primary,
//               child: Icon(Icons.send, color: Colors.white, size: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:io'; // لاستخدام File
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // المكتبة الجديدة
import '../../../../core/theme/constants/app_colors.dart';
import '../bloc/message_bloc/message_bloc.dart';
import '../bloc/message_bloc/message_event.dart';

class MessageInputBar extends StatefulWidget {
  final String roomId;

  const MessageInputBar({super.key, required this.roomId});

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker(); // كائن لاختيار الصور

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      context.read<MessageBloc>().add(MessageSent(widget.roomId, text, type: 'text'));
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  // دالة جديدة لاختيار الصورة ورفعها
  Future<void> _pickAndSendImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // يمكنك عرض مؤشر تحميل هنا (مثلاً Dialog أو Overlay)

      // نرسل حدث للـ Bloc لرفع الصورة وإرسالها
      context.read<MessageBloc>().add(SendImageMessageStarted(widget.roomId, imageFile));
      // لا تنسى إزالة مؤشر التحميل بعد الإرسال أو عند الخطأ
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: AppColors.getDividerColor(Theme.of(context).brightness),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: AppColors.primary),
            onPressed: _pickAndSendImage, // ربط الزر بالدالة الجديدة
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (_) => _sendMessage(),
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: "اكتب رسالة...",
                hintStyle: const TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.withValues(alpha: 0.1),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}