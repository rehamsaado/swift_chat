import '../../../../core/exports.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfileDetails(String userId);

  Future<void> updateProfileDetails({
   required  String fieldName,
  required  dynamic value,
   required String userId,
  });

  Future<String> uploadProfileImage(File imageFile, String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient supabase;

  ProfileRemoteDataSourceImpl(this.supabase);

  // @override
  // Future<ProfileModel> getProfileDetails(String userId) async {
  //   final data = await supabase
  //       .from('profiles')
  //       .select()
  //       .eq('id', userId)
  //       .maybeSingle();
  //   return ProfileModel.fromJson(data!);
  // }
  @override
  Future<ProfileModel> getProfileDetails(String userId) async {
    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (data == null) {

        throw Exception("المستخدم غير موجود في قاعدة البيانات");
      }

      return ProfileModel.fromJson(data);
    } catch (e) {

      rethrow;
    }
  }
  @override
  Future<void> updateProfileDetails({
    required String fieldName,
  required  dynamic value,
 required   String userId,
  }) async {
    await supabase.from('profiles').update({fieldName: value}).eq('id', userId);
  }

  @override
  Future<String> uploadProfileImage(File imageFile, String userId) async {
    final String fileName =
        'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String storagePath = '$userId/$fileName';

    await supabase.storage
        .from('profiles_images')
        .upload(
          storagePath,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    return supabase.storage.from('profiles_images').getPublicUrl(storagePath);
  }
}
