import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swift_chat/core/exports.dart';
import 'package:swift_chat/core/theme/constants/theme_manager.dart';
import 'package:swift_chat/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:swift_chat/features/chat/presentation/pages/chats_page.dart';
import 'package:swift_chat/features/home/presentation/home_page.dart';
import 'package:swift_chat/features/stories/presentation/blocs/story_bloc.dart';
import 'core/injection_container.dart';
import 'core/theme/blocs/theme/theme_bloc.dart';
import 'core/theme/blocs/theme/theme_event.dart';
import 'core/theme/blocs/theme/theme_state.dart';
import 'core/theme/constants/app_theme.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final themeManager = ThemeManager();
  await themeManager.initialize();
  await Supabase.initialize(
    url: "https://shcrhucwakyevewtjmvf.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNoY3JodWN3YWt5ZXZld3RqbXZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg4MjUzMTksImV4cCI6MjA4NDQwMTMxOX0.uOxCr71vtlCE2-UL6PUoQjhddLJCMkpcXl5sf6_6GqU",
  );
  await initServiceLocator();
  runApp(
    BlocProvider(
      create: (context) => ThemeBloc()..add(InitializeTheme()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        ThemeMode currentMode = ThemeMode.system;

        if (state is ThemeLoaded) {
          currentMode = state.themeMode;
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<AuthBloc>(),
            ),
            BlocProvider(create: (context) => sl<ChatBloc>()),
            BlocProvider(create: (context) => sl<MessageBloc>()),
            BlocProvider(create: (context) => sl<ProfileBloc>()),
            BlocProvider(create: (context) => sl<StoryBloc>()),
          ],
          child: MaterialApp(
            title: 'Swift Chat',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: currentMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashPage(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/chat_list': (context) => const ChatListScreen(),
              '/home_page': (context) => const HomeScreen(),
            },
          ),
        );
      },
    );
  }
}
