import '../../../../core/exports.dart';

abstract class RoomRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllUsers(); // دمجناها هنا كما طلبتِ
  Future<String> getOrCreateRoomId(String otherUserId);
  Stream<List<Map<String, dynamic>>> getRoomsStream();
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
          final room = await supabase.from('rooms').select().eq('id', roomId).single();
          if (room['last_message'] == null) continue;

          final peerData = await supabase.from('room_members').select('user_id')
              .eq('room_id', roomId).neq('user_id', myId).maybeSingle();

          if (peerData != null) {
            final profile = await supabase.from('profiles').select().eq('id', peerData['user_id']).maybeSingle();
            if (profile != null) {
              finalRooms.add({
                'id': roomId,
                'peer_id': peerData['user_id'],
                'full_name': profile['full_name'],
                'avatar_url': profile['avatar_url'],
                'last_message': room['last_message'],
                'last_message_time': room['last_message_time'],
                'unread_count': membership['unread_count'] ?? 0,
                'is_online': profile['is_online'],
              });
            }
          }
        } catch (e) { continue; }
      }
      finalRooms.sort((a, b) => (b['last_message_time'] ?? '').compareTo(a['last_message_time'] ?? ''));
      return finalRooms;
    });
  }
}