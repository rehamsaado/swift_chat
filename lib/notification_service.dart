import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;


  static Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }


  static Future<void> saveTokenToSupabase() async {

    String? token = await _messaging.getToken();


    final user = Supabase.instance.client.auth.currentUser;


    if (token != null && user != null) {
      try {
        await Supabase.instance.client
            .from('profiles')
            .update({'fcm_token': token})
            .eq('id', user.id);

        debugPrint('تم ربط جهازك بالحساب بنجاح');
      } catch (e) {
        debugPrint('حدث خطأ أثناء الحفظ: $e');
      }
    }
  }
}