import '../../../../core/exports.dart';
import '../model/story_model.dart';

abstract class StoryRemoteDataSource {
  Future<List<StoryModel>> getActiveStories();

  Future<void> uploadImageStory(String filePath, {String? caption});

  Future<void> uploadTextStory({
    required String text,
    required String backgroundColor,
  });

  Future<void> markStoryAsViewed(String storyId);

  Future<List<Map<String, dynamic>>> getStoryViewers(String storyId);
}

class StoryRemoteDataSourceImpl implements StoryRemoteDataSource {
  final SupabaseClient _supabaseClient;

  StoryRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<Map<String, dynamic>>> getStoryViewers(String storyId) async {
    final response = await _supabaseClient
        .from('story_views')
        .select('''
          created_at,
          profiles:viewer_id (
            full_name,
            avatar_url
          )
        ''')
        .eq('story_id', storyId);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Future<List<StoryModel>> getActiveStories() async {

    final response = await _supabaseClient
        .from('stories')
        .select('''
          *,
          profiles:user_id (
            full_name,
            avatar_url
          )
        ''')
        .gt('expires_at', DateTime.now().toIso8601String())
        .order('created_at', ascending: false);

    return (response as List).map((json) => StoryModel.fromJson(json)).toList();
  }

  @override
  Future<void> uploadImageStory(String filePath, {String? caption}) async {
    final file = File(filePath);

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final userId = _supabaseClient.auth.currentUser!.id;


    await _supabaseClient.storage.from('stories').upload(fileName, file);

    final imageUrl = _supabaseClient.storage
        .from('stories')
        .getPublicUrl(fileName);


    await _supabaseClient.from('stories').insert({
      'user_id': userId,
      'content_type': 'image',
      'media_url': imageUrl,
      'caption': caption,
      'expires_at': DateTime.now()
          .add(const Duration(hours: 24))
          .toIso8601String(),
    });
  }

  @override
  Future<void> uploadTextStory({
    required String text,
    required String backgroundColor,
  }) async {

    final userId = _supabaseClient.auth.currentUser!.id;

    await _supabaseClient.from('stories').insert({
      'user_id': userId,
      'content_type': 'text',
      'caption': text,
      'background_color': backgroundColor,
      'expires_at': DateTime.now()
          .add(const Duration(hours: 24))
          .toIso8601String(),
    });
  }

  @override
  Future<void> markStoryAsViewed(String storyId) async {

    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    await _supabaseClient.from('story_views').upsert({
      'story_id': storyId,
      'viewer_id': userId,
    });
  }
}
