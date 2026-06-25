import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/auth/data/data_source/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/presentation/blocs/auth_bloc.dart';
import '../features/chat/data/data_source/message_remote_data_source.dart';
import '../features/chat/data/data_source/room_remote_data_source.dart';
import '../features/chat/data/repositories/message_repository_impl.dart';
import '../features/chat/data/repositories/room_repository_impl.dart';
import '../features/chat/domain/repositories/message_repository.dart';
import '../features/chat/domain/repositories/room_repository.dart';
import '../features/chat/domain/usecases/messages/get_message_usecase.dart';
import '../features/chat/domain/usecases/messages/mark_messages_as_read_usecase.dart';
import '../features/chat/domain/usecases/messages/send_message_usecase.dart';
import '../features/chat/domain/usecases/messages/upload_chat_image_use_case.dart';
import '../features/chat/domain/usecases/rooms/create_group_usecase.dart';
import '../features/chat/domain/usecases/rooms/get_or_create_room_id_use_case.dart';
import '../features/chat/domain/usecases/rooms/get_rooms_usecase.dart';
import '../features/chat/domain/usecases/rooms/get_users_usecase.dart';
import '../features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import '../features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import '../features/profile/data/data_source/profile_remote_data_source.dart';
import '../features/profile/data/repositories/profile_repositories_imp.dart';
import '../features/profile/domain/repository/profile_repository.dart';
import '../features/profile/domain/usecases/user/get_profile_details_usecase.dart';
import '../features/profile/domain/usecases/user/update_profile_details_use_case.dart';
import '../features/profile/domain/usecases/user/upload_profile_image_use_case.dart';
import '../features/profile/presentation/bloc/profile_bloc.dart';
import '../features/stories/data/data_source/story_remote_data_source.dart';
import '../features/stories/data/repositories/story_repository_impl.dart';
import '../features/stories/domain/repositories/story_repository.dart';
import '../features/stories/domain/usecases/get_active_stories.dart';
import '../features/stories/domain/usecases/get_story_viewers_use_case.dart';
import '../features/stories/domain/usecases/mark_story_as_viewed.dart';
import '../features/stories/domain/usecases/upload_image_story.dart';
import '../features/stories/domain/usecases/upload_text_story.dart';
import '../features/stories/presentation/blocs/story_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // --- External ---
  sl.registerLazySingleton(() => Supabase.instance.client);

  // ================= AUTH FEATURE =================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => AuthBloc(sl()));

  // ================= PROFILE FEATURE (الجديد هنا) =================

  // 1. Data Sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );

  // 2. Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton(() => GetProfileDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UploadProfileImageUseCase(sl()));

  // 4. Bloc
  sl.registerFactory(
    () => ProfileBloc(
      getProfileDetailsUseCase: sl(),
      updateProfileDetailsUseCase: sl(),
      uploadProfileImageUseCase: sl(),
    ),
  );

  // ================= CHAT & MESSAGE FEATURE (Clean Architecture) =================

  // 1. Data Sources (المصادر مفصولة الآن)
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<MessageRemoteDataSource>(
    () => MessageRemoteDataSourceImpl(sl()),
  );

  // 2. Repositories (كل ريبوزيتوري يأخذ مصدره الخاص)
  sl.registerLazySingleton<RoomRepository>(() => RoomRepositoryImpl(sl()));
  sl.registerLazySingleton<MessageRepository>(
    () => MessageRepositoryImpl(sl()),
  );

  // 3. Use Cases (مقسمة حسب الريبوزيتوري المسؤول)

  // --- Use Cases الخاصة بالـ RoomRepository ---
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl<RoomRepository>()));
  sl.registerLazySingleton(() => GetRoomsUseCase(sl<RoomRepository>()));
  sl.registerLazySingleton(
    () => GetOrCreateRoomIdUseCase(sl<RoomRepository>()),
  );sl.registerLazySingleton(
    () => CreateGroupUseCase(sl<RoomRepository>()),
  );

  // --- Use Cases الخاصة بالـ MessageRepository ---
  sl.registerLazySingleton(() => GetMessagesUseCase(sl<MessageRepository>()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl<MessageRepository>()));
  sl.registerLazySingleton(
    () => UploadChatImageUseCase(sl<MessageRepository>()),
  );
  sl.registerLazySingleton(
    () => MarkMessagesAsReadUseCase(sl<MessageRepository>()),
  );

  // 4. Blocs (تبقى كما هي، لكنها الآن تعتمد على Use Cases نظيفة ومفصولة)
  sl.registerFactory(
    () => ChatBloc(
      getAllUsersUseCase: sl(),
      getRoomsUseCase: sl(),
      getOrCreateRoomIdUseCase: sl(),
      createGroupUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => MessageBloc(
      getMessagesUseCase: sl(),
      sendMessageUseCase: sl(),
      uploadChatImageUseCase: sl(),
      markMessagesAsReadUseCase: sl(),
    ),
  );

  ////////////// story ////////////
  // 1. البلوك (Bloc)

  sl.registerFactory(
    () => StoryBloc(
      getActiveStoriesUseCase: sl(),
      uploadImageStoryUseCase: sl(),
      uploadTextStoryUseCase: sl(),
      markStoryAsViewedUseCase: sl(),
      getStoryViewersUseCase: sl(),
    ),
  );

  // 2. حالات الاستخدام (Use Cases)
  sl.registerLazySingleton(() => GetActiveStories(sl()));
  sl.registerLazySingleton(() => UploadImageStory(sl()));
  sl.registerLazySingleton(() => UploadTextStory(sl()));
  sl.registerLazySingleton(() => MarkStoryAsViewed(sl()));
  sl.registerLazySingleton(() => GetStoryViewers(sl()));


  // 3. المستودع (Repository)
  // بنربط الـ Interface بالـ Implementation (التنفيذ الفعلي)
  sl.registerLazySingleton<StoryRepository>(
    () => StoryRepositoryImpl(remoteDataSource: sl()),
  );

  // 4. مصدر البيانات (Data Source)
  sl.registerLazySingleton<StoryRemoteDataSource>(
    () => StoryRemoteDataSourceImpl(sl()),
  );
}
