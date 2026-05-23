import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final StreamSubscription<AuthState> _authStateSubscription;
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (_redirecting || !mounted) return;

      final session = data.session;

      // فحص الجلسة والتوجيه
      Future.delayed(const Duration(seconds: 2), () { // تأخير بسيط لرؤية اللوجو
        if (!mounted || _redirecting) return;

        _redirecting = true;
        if (session == null) {
          // إذا لا توجد جلسة، اذهب لتسجيل الدخول
          Navigator.of(context).pushReplacementNamed('/login');
        } else {
          // إذا الجلسة موجودة، اذهب للقائمة مباشرة
          Navigator.of(context).pushReplacementNamed( '/home_page');
        }
      });
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // يمكنك وضع لوجو تطبيقك هنا
            Icon(Icons.bolt, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Swift Chat", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}