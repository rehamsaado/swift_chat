import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/exports.dart' hide State;
import '../../../chat/presentation/widgets/profile_widget/editable_info_tile_widget.dart';
import '../../../chat/presentation/widgets/profile_widget/profile_image_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final bool isReadOnly;

  const ProfileScreen({
    super.key,
    required this.currentUserId,
    this.isReadOnly = false,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(
      GetProfileDetailsEvent(widget.currentUserId),
    );
  }

  Future<void> _pickAndUploadImage(String userId) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      if (!mounted) return;
      // إرسال حدث رفع الصورة للـ ProfileBloc
      context.read<ProfileBloc>().add(
        UploadProfileImageEvent(imageFile: File(image.path), userId: userId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isReadOnly ? "ملف المستخدم" : "ملفي الشخصي"),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("تم تحديث البيانات بنجاح")),
            );
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // 1. تحديد الـ User بشكل آمن
          ProfileEntity? user;

          if (state is ProfileLoaded) {
            user = state.profile;
          } else {
            // إذا كانت الحالة Success أو Uploading، نحاول استرجاع آخر بروفايل كان موجوداً
            final currentState = context.read<ProfileBloc>().state;
            if (currentState is ProfileLoaded) {
              user = currentState.profile;
            }
          }

          // 2. التحقق إذا كان لدينا بيانات لعرضها
          if (user != null) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileImageWidget(
                    imageUrl: user.avatarUrl ?? '',
                    isLoading: state is ProfileImageUploading,
                    onEditTap: widget.isReadOnly
                        ? null
                        : () => _pickAndUploadImage(user!.id),
                    fullName: user.fullName,
                  ),
                  const SizedBox(height: 30),
                  EditableInfoTile(
                    label: "الاسم",
                    value: user.fullName,
                    icon: Icons.person,
                    onSave: widget.isReadOnly
                        ? null
                        : (newValue) {
                            context.read<ProfileBloc>().add(
                              UpdateProfileDetailsEvent(
                                userId: user!.id,
                                fieldName: 'full_name',
                                value: newValue,
                              ),
                            );
                          },
                  ),
                  const Divider(),
                  EditableInfoTile(
                    label: "نبذة عني",
                    value: user.bio ?? "لا توجد نبذة",
                    icon: Icons.info_outline,
                    onSave: widget.isReadOnly
                        ? null
                        : (newValue) {
                            context.read<ProfileBloc>().add(
                              UpdateProfileDetailsEvent(
                                userId: user!.id,
                                fieldName: 'bio',
                                value: newValue,
                              ),
                            );
                          },
                  ),
                ],
              ),
            );
          }

          // 3. التعامل مع حالة الخطأ
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }

          // 4. حالة التحميل الأولية
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
