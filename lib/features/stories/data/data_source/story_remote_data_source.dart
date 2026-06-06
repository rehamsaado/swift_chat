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
    // استعلام مع جلب الاسم والصورة بوضوح عبر تحديد العمود الرابط
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
    // 1. توليد اسم فريد للملف باستخدام الوقت الحالي لتجنب تكرار الأسماء
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final userId = _supabaseClient.auth.currentUser!.id;

    // 2. رفع ملف الصورة إلى الـ Bucket اللي سميناه "stories"
    await _supabaseClient.storage.from('stories').upload(fileName, file);

    // 3. استخراج الرابط العمومي (Public URL) للصورة المرفوعة
    final imageUrl = _supabaseClient.storage
        .from('stories')
        .getPublicUrl(fileName);

    // 4. حفظ سجل القصة في جدول الداتابيز وربطه برابط الصورة والـ User ID
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
    // 1. جلب الـ ID تبع المستخدم الحالي من سوبابيس
    final userId = _supabaseClient.auth.currentUser!.id;

    // 2. إدخال سجل جديد في جدول stories
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
    // 1. جلب ID المستخدم الحالي اللي عم يشوف القصة
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    // 2. تسجيل المشاهدة (Insert) في جدول story_views
    // استخدمنا upsert عشان إذا رجع فتح نفس الستوري ما يرجع يضيف سطر مكرر ويضرب
    await _supabaseClient.from('story_views').upsert({
      'story_id': storyId,
      'viewer_id': userId,
    });
  }
}
