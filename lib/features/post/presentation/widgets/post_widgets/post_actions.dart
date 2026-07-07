// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../domain/entities/post_entity.dart';
// import '../../bloc/reaction_bloc/reation_bloc.dart';
// import '../../bloc/reaction_bloc/reation_event.dart';
//
// class PostActions extends StatelessWidget {
//   final PostEntity post;
//   final VoidCallback onCommentPressed;
//
//   const PostActions({
//     super.key,
//     required this.post,
//     required this.onCommentPressed,
//     VoidCallback? onLikePressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final ValueNotifier<Map<String, dynamic>> likeNotifier = ValueNotifier({
//       'isLiked': post.isLikedByMe,
//       'count': post.likesCount,
//     });
//
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.favorite, size: 16, color: Colors.red[400]),
//                   const SizedBox(width: 4),
//
//                    ValueListenableBuilder<Map<String, dynamic>>(
//                     valueListenable: likeNotifier,
//                     builder: (context, likeData, _) {
//                       return Text(
//                         '${likeData['count']}',
//                         style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//               Text(
//                 '${post.commentsCount} تعليق',
//                 style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//         const Divider(height: 1, thickness: 0.5),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 4.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
// ValueListenableBuilder<Map<String, dynamic>>(
//                 valueListenable: likeNotifier,
//                 builder: (context, likeData, _) {
//                   final bool isLiked = likeData['isLiked'];
//
//                   return MaterialButton(
//                     onPressed: () {
//                       // 1. التحديث الفوري الموضعي (Optimistic Update) في جزء من الثانية
//                       final newLikedState = !isLiked;
//                       likeNotifier.value = {
//                         'isLiked': newLikedState,
//                         'count': newLikedState ? likeData['count'] + 1 : likeData['count'] - 1,
//                       };
//  context.read<ReactionsBloc>().add(ToggleLikeEvent(post.id));
//                     },
//                     minWidth: 0,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           isLiked ? Icons.favorite : Icons.favorite_border,
//                           color: isLiked ? Colors.red : Colors.grey[700],
//                           size: 22,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           'إعجاب',
//                           style: TextStyle(
//                             color: isLiked ? Colors.red : Colors.grey[700],
//                             fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//
//               MaterialButton(
//                 onPressed: onCommentPressed,
//                 minWidth: 0,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.chat_bubble_outline, color: Colors.grey[700], size: 20),
//                     const SizedBox(width: 6),
//                     Text(
//                       'تعليق',
//                       style: TextStyle(color: Colors.grey[700]),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/post_entity.dart';
import '../../bloc/reaction_bloc/reation_bloc.dart';
import '../../bloc/reaction_bloc/reation_event.dart';

class PostActions extends StatelessWidget {
  final PostEntity post;
  final VoidCallback onCommentPressed;

  const PostActions({
    super.key,
    required this.post,
    required this.onCommentPressed,
  });

  @override
  Widget build(BuildContext context) {
    // 👈 وسّعنا الـ Notifier ليشمل الـ likes والـ comments معاً في خريطة واحدة
    final ValueNotifier<Map<String, dynamic>> postNotifier = ValueNotifier({
      'isLiked': post.isLikedByMe,
      'likesCount': post.likesCount,
      'commentsCount': post.commentsCount,
    });

    return Column(
      children: [
        // 1. شريط العدادات (اللايكات والتعليقات المحدثة فوراً)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
          child: ValueListenableBuilder<Map<String, dynamic>>(
            valueListenable: postNotifier,
            builder: (context, data, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: Colors.red[400]),
                      const SizedBox(width: 4),
                      Text(
                        '${data['likesCount']}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  Text(
                    '${data['commentsCount']} تعليق', // 👈 يتحدث فوراً هنا
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              );
            },
          ),
        ),
        const Divider(height: 1, thickness: 0.5),

        // 2. أزرار التفاعل (إعجاب وتعليق)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // زر الإعجاب (كما هو، سريع ونظيف)
              ValueListenableBuilder<Map<String, dynamic>>(
                valueListenable: postNotifier,
                builder: (context, data, _) {
                  final bool isLiked = data['isLiked'];
                  return MaterialButton(
                    onPressed: () {
                      final bool newLikedState = !isLiked;
                      postNotifier.value = {
                        ...postNotifier.value,
                        'isLiked': newLikedState,
                        'likesCount': newLikedState ? data['likesCount'] + 1 : data['likesCount'] - 1,
                      };
                      context.read<ReactionsBloc>().add(ToggleLikeEvent(post.id));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey[700],
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'إعجاب',
                          style: TextStyle(
                            color: isLiked ? Colors.red : Colors.grey[700],
                            fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // زر التعليق المطور
              MaterialButton(
                onPressed: () async {
                  // 1. نستدعي دالة فتح صفحة التعليقات الأساسية الممررة من الخارج
                  onCommentPressed();

                  // 2. 💡 فكرة احترافية: إذا كانت صفحة التعليقات تعود بـ bool (مثلاً true عند إضافة تعليق جديد)
                  // يمكنكِ زيادة العداد هنا فوراً هكذا:
                  // final bool? commentAdded = await Navigator.push(...);
                  // if (commentAdded == true) {
                  //   postNotifier.value = {
                  //     ...postNotifier.value,
                  //     'commentsCount': postNotifier.value['commentsCount'] + 1,
                  //   };
                  // }
                },
                minWidth: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.grey[700], size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'تعليق',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}