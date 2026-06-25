import '../../../../core/exports.dart';

abstract class RoomRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllUsers();

  Future<String> getOrCreateRoomId(String otherUserId);

  Stream<List<Map<String, dynamic>>> getRoomsStream();

  Future<String> createGroup(
    String name,
    String imageUrl,
    List<String> memberIds,
  );
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final SupabaseClient supabase;

  RoomRemoteDataSourceImpl(this.supabase);

  @override
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final myId = supabase.auth.currentUser!.id;
    return await supabase.from('profiles').select().neq('id', myId);
  }

  @override
  Future<String> getOrCreateRoomId(String otherUserId) async {
    final myId = supabase.auth.currentUser!.id;
    if (otherUserId == myId) throw ArgumentError('لا يمكنك بدء محادثة مع نفسك');

    final String user1 = myId.compareTo(otherUserId) <= 0 ? myId : otherUserId;
    final String user2 = myId.compareTo(otherUserId) <= 0 ? otherUserId : myId;

    final raw = await supabase.rpc(
      'get_or_create_room',
      params: {'user_id_1': user1, 'user_id_2': user2},
    );
    return raw.toString();
  }

  @override
  Future<String> createGroup(
    String name,
    String imageUrl,
    List<String> memberIds,
  ) async {
    final raw = await supabase.rpc(
      'create_group_with_members',
      params: {
        'p_group_name': name,
        'p_group_avatar_url': imageUrl,
        'p_member_ids': memberIds,
      },
    );
    return raw.toString();
  }
  @override
  Stream<List<Map<String, dynamic>>> getRoomsStream() {
    final myId = supabase.auth.currentUser!.id;
    return supabase
        .from('room_members')
        .stream(primaryKey: ['room_id', 'user_id'])
        .eq('user_id', myId)
        .asyncMap((myMemberships) async {
      List<Map<String, dynamic>> finalRooms = [];
      for (var membership in myMemberships) {
        final roomId = membership['room_id'];
        try {
          // جلب الغرفة والتأكد الصارم من نوعها
          final room = await supabase.from('rooms').select().eq('id', roomId).single();
          if (room['last_message'] == null) continue;

          // التأكد الصارم من القيمة البولينية لـ is_group
          final bool isGroup = room['is_group'] == true;

          if (isGroup) {
            List<String> memberNames = [];
            try {
              final membersData = await supabase
                  .from('room_members')
                  .select('profiles(full_name)')
                  .eq('room_id', roomId);

              memberNames = membersData
                  .map((m) => (m['profiles']?['full_name'] ?? '').toString())
                  .where((name) => name.isNotEmpty)
                  .toList();
            } catch (_) {}

            finalRooms.add({
              'id': roomId,
              'is_group': true,
              'group_name': room['group_name'] ?? 'مجموعة بدون اسم',
              'group_avatar_url': room['group_avatar_url'],
              'created_by': room['created_by'],
              'last_message': room['last_message'],
              'last_message_time': room['last_message_time'],
              'last_sender_id': room['last_sender_id'],
              'unread_count': membership['unread_count'] ?? 0,
              'member_names': memberNames,
            });
          } else {
            // للمحادثات الفردية: جلب الأعضاء الآخرين (تجنب الحلب العشوائي للمجموعات)
            final membersList = await supabase.from('room_members').select('user_id')
                .eq('room_id', roomId).neq('user_id', myId);

            // حماية: إذا كانت الغرفة تحتوي على أكثر من طرف آخر، فهي مجموعة وليست محادثة فردية!
            if (membersList.length > 1) continue;

            if (membersList.isNotEmpty) {
              final peerUserId = membersList.first['user_id'];
              final profile = await supabase.from('profiles').select().eq('id', peerUserId).maybeSingle();

              if (profile != null) {
                finalRooms.add({
                  'id': roomId,
                  'is_group': false,
                  'peer_id': peerUserId,
                  'full_name': profile['full_name'],
                  'avatar_url': profile['avatar_url'],
                  'last_message': room['last_message'],
                  'last_message_time': room['last_message_time'],
                  'last_sender_id': room['last_sender_id'],
                  'unread_count': membership['unread_count'] ?? 0,
                  'is_online': profile['is_online'],
                });
              }
            }
          }
        } catch (e) { continue; }
      }
      finalRooms.sort((a, b) => (b['last_message_time'] ?? '').compareTo(a['last_message_time'] ?? ''));
      return finalRooms;
    });
  }
}
