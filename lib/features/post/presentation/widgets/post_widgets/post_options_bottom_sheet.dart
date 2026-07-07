// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../bloc/post_bloc/post_bloc.dart';
// import '../../bloc/post_bloc/post_event.dart';
//
// class PostOptionsBottomSheet extends StatelessWidget {
//   final String postId;
//   final String postContent;
//
//   const PostOptionsBottomSheet({
//     super.key,
//     required this.postId,
//     required this.postContent,
//   });
//
//   static void show(BuildContext context, {required String postId, required String postContent, required PostsBloc postsBloc}) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return BlocProvider.value(
//           value: postsBloc,
//           child: PostOptionsBottomSheet(postId: postId, postContent: postContent),
//         );
//       },
//     );
//   }
//
//   void _showDeleteConfirmation(BuildContext context, PostsBloc postsBloc) {
//     final theme = Theme.of(context);
//
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('حذف المنشور', textAlign: TextAlign.right),
//           content: const Text('هل أنتِ متأكدة من رغبتكِ في حذف هذا المنشور نهائياً؟', textAlign: TextAlign.right),
//           actionsAlignment: MainAxisAlignment.spaceBetween,
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(dialogContext),
//               child: Text('إلغاء', style: TextStyle(color: theme.hintColor)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(dialogContext);
//                 postsBloc.add(DeletePostEvent(postId));
//               },
//               child: Text('حذف', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Container(
//       decoration: BoxDecoration(
//         color: theme.scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 14.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[400],
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // زر تعديل المنشور
//               ListTile(
//                 leading: const Icon(Icons.edit_outlined),
//                 title: const Text('تعديل المنشور', style: TextStyle(fontSize: 15)),
//                 onTap: () {
//                   Navigator.pop(context, true);
//                 },
//               ),
//               const Divider(height: 1, thickness: 0.5),
//
//               // زر حذف المنشور
//               ListTile(
//                 leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
//                 title: Text(
//                   'حذف المنشور',
//                   style: TextStyle(color: theme.colorScheme.error, fontSize: 15, fontWeight: FontWeight.w500),
//                 ),
//                 onTap: () {
//                   // 1. نسحب الـ Bloc الحالي ونحفظه في متغير قبل إغلاق الـ Bottom Sheet
//                   final postsBloc = context.read<PostsBloc>();
//
//                   // 2. نغلق الـ Bottom Sheet
//                   Navigator.pop(context);
//
//                   // 3. نفتح ديالوج التأكيد ونمرر له الـ Bloc المحفوظ بأمان
//                   _showDeleteConfirmation(context, postsBloc);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/post_entity.dart';
import '../../bloc/post_bloc/post_bloc.dart';
import '../../bloc/post_bloc/post_event.dart';
import '../../pages/post_pages/create_post_page.dart';

class PostOptionsBottomSheet extends StatelessWidget {
  final PostEntity post;

  const PostOptionsBottomSheet({super.key, required this.post});

  static void show(
    BuildContext context, {
    required PostEntity post,
    required PostsBloc postsBloc,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider.value(
          value: postsBloc,
          child: PostOptionsBottomSheet(post: post),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, PostsBloc postsBloc) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('حذف المنشور', textAlign: TextAlign.right),
          content: const Text(
            'هل أنتِ متأكدة من رغبتكِ في حذف هذا المنشور نهائياً؟',
            textAlign: TextAlign.right,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('إلغاء', style: TextStyle(color: theme.hintColor)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                postsBloc.add(DeletePostEvent(post.id));
              },
              child: Text(
                'حذف',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(
                  'تعديل المنشور',
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () {
                  final postsBloc = context.read<PostsBloc>();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: postsBloc,
                        child: CreatePostPage(postToEdit: post),
                      ),
                    ),
                  );
                },
              ),
              const Divider(height: 1, thickness: 0.5),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  'حذف المنشور',
                  style: TextStyle(
                    color: theme.colorScheme.error,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  final postsBloc = context.read<PostsBloc>();
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, postsBloc);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
