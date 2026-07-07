import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/injection_container.dart';
import '../../../domain/entities/post_entity.dart';
import '../../bloc/post_bloc/post_bloc.dart';
import '../../bloc/post_bloc/post_event.dart';
import '../../bloc/post_bloc/post_state.dart';
import '../../widgets/post_widgets/selected_images_grid.dart';

class CreatePostPage extends StatefulWidget {
  final PostEntity? postToEdit;

  const CreatePostPage({super.key, this.postToEdit});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final List<File> _selectedImageFiles = [];
  final List<String> _uploadedImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingToStorage = false;
  String? _currentUserAvatar;
  String _currentUserName = 'أنا';

  @override
  void initState() {
    super.initState();
    _loadCurrentUserProfile();
    _checkIfEditMode();
  }

  void _checkIfEditMode() {
    if (widget.postToEdit != null) {
      _contentController.text = widget.postToEdit!.content;
      _uploadedImageUrls.addAll(widget.postToEdit!.imageUrls);
    }
  }

  void _loadCurrentUserProfile() {
    final user = sl<SupabaseClient>().auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUserAvatar = user.userMetadata?['avatar_url'] as String?;
        _currentUserName = user.userMetadata?['full_name'] as String? ?? 'أنا';
      });
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _selectedImageFiles.addAll(images.map((img) => File(img.path)));
          });
        }
      } else {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedImageFiles.add(File(image.path));
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في اختيار الصور: $e')),
      );
    }
  }

  Future<bool> _uploadImagesToSupabase() async {
    setState(() {
      _isUploadingToStorage = true;
    });

    final supabase = sl<SupabaseClient>();

    try {
      for (var file in _selectedImageFiles) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        final path = 'post_images/$fileName';

        await supabase.storage.from('posts').upload(path, file);

        final String publicUrl = supabase.storage.from('posts').getPublicUrl(path);
        _uploadedImageUrls.add(publicUrl);
      }
      return true;
    } catch (e) {
      if (!mounted) return false;

      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('خطأ أثناء رفع الصور إلى السيرفر: $e')),
      );
      return false;
    } finally {
      setState(() {
        _isUploadingToStorage = false;
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditMode = widget.postToEdit != null;

    return BlocConsumer<PostsBloc, PostsState>(
      listener: (context, state) {
        if (state is PostActionSuccess) {
          Navigator.pop(context, true);
        } else if (state is PostsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isBlocLoading = state is PostActionLoading;
        final isFullLoading = isBlocLoading || _isUploadingToStorage;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isEditMode ? 'تعديل المنشور' : 'إنشاء منشور',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: ElevatedButton(
                  onPressed: isFullLoading || (_contentController.text.trim().isEmpty && _selectedImageFiles.isEmpty && _uploadedImageUrls.isEmpty)
                      ? null
                      : () async {
                    bool proceed = true;
                    if (_selectedImageFiles.isNotEmpty) {
                      proceed = await _uploadImagesToSupabase();
                    }
                    if (proceed && context.mounted) {
                      if (isEditMode) {
                        context.read<PostsBloc>().add(
                          UpdatePostEvent(
                            postId: widget.postToEdit!.id,
                            content: _contentController.text.trim(),
                          ),
                        );
                      } else {
                        context.read<PostsBloc>().add(
                          CreatePostEvent(
                            content: _contentController.text.trim(),
                            imageUrls: _uploadedImageUrls,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: isFullLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text(isEditMode ? 'تعديل' : 'نشر', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          body: IgnorePointer(
            ignoring: isFullLoading,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: theme.colorScheme.surfaceContainerHigh,
                            backgroundImage: _currentUserAvatar != null && _currentUserAvatar!.isNotEmpty
                                ? NetworkImage(_currentUserAvatar!)
                                : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUserName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.public, size: 12, color: theme.hintColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      'عام',
                                      style: TextStyle(fontSize: 11, color: theme.hintColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _contentController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'بماذا تفكر؟',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: theme.hintColor),
                        ),
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                      if (_selectedImageFiles.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SelectedImagesGrid(
                          imageFiles: _selectedImageFiles,
                          onRemove: (index) {
                            setState(() {
                              _selectedImageFiles.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.bottomAppBarTheme.color,
                    border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library, color: Colors.green),
                        onPressed: () => _pickImages(ImageSource.gallery),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.blue),
                        onPressed: () => _pickImages(ImageSource.camera),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}