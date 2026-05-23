import 'dart:async';

import '../../../../core/exports.dart';
import '../model/message_model.dart';

abstract class MessageRemoteDataSource {
  Future<void> sendMessage({
    required String roomId,
    required String content,
    String type = 'text',
  });
  Stream<List<MessageModel>> getMessages(String roomId);
  // Stream<List<Map<String, dynamic>>> getMessages(String roomId);

  Future<void> markMessagesAsRead(String roomId);

  Future<String> uploadChatImage(File imageFile, String roomId);
}

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final SupabaseClient supabase;

  MessageRemoteDataSourceImpl(this.supabase);

  @override
  Future<void> sendMessage({
    required String roomId,
    required String content,
    String type = 'text',
  }) async {
    final myId = supabase.auth.currentUser!.id;
    await supabase.from('messages').insert({
      'room_id': roomId,
      'sender_id': myId,
      'content': content,
      'type': type,
    });
    // تصفير العداد للمرسل لضمان مزامنة الواجهة فوراً
    await supabase
        .from('room_members')
        .update({'unread_count': 0})
        .eq('room_id', roomId)
        .eq('user_id', myId);
  }
  @override
// 1. غيري النوع هنا من Map إلى MessageModel
  Stream<List<MessageModel>> getMessages(String roomId) {
    return supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at', ascending: false)
    // 2. هلق الـ map هاد صار متوافق مع نوع الدالة
        .map((data) => data.map((json) => MessageModel.fromMap(json)).toList());
  }
  // @override
  // Stream<List<Map<String, dynamic>>> getMessages(String roomId) {
  //   return supabase
  //       .from('messages')
  //       .stream(primaryKey: ['id'])
  //       .eq('room_id', roomId)
  //       .order('created_at', ascending: false)
  //       .map((data) => data.map((json) => MessageModel.fromMap(json)).toList());
  // }

  @override
  Future<void> markMessagesAsRead(String roomId) async {
    final myId = supabase.auth.currentUser!.id;
    await supabase
        .from('room_members')
        .update({'unread_count': 0})
        .eq('room_id', roomId)
        .eq('user_id', myId);
    await supabase
        .from('messages')
        .update({'status': 'read'})
        .eq('room_id', roomId)
        .neq('sender_id', myId);
  }

  @override
  Future<String> uploadChatImage(File imageFile, String roomId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_chat.jpg';
    final storagePath = '$roomId/$fileName';
    await supabase.storage
        .from('chat_images_bucket')
        .upload(storagePath, imageFile);
    return supabase.storage
        .from('chat_images_bucket')
        .getPublicUrl(storagePath);
  }
}
