import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // 1. طلب إذن الإشعارات من المستخدم
  static Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // 2. جلب التوكن وحفظه في سوبابيس
  static Future<void> saveTokenToSupabase() async {
    // جلب التوكن من فيربيز
    String? token = await _messaging.getToken();

    // جلب رقم تعريف المستخدم الحالي (المسجل دخوله)
    final user = Supabase.instance.client.auth.currentUser;

    // إذا وجدنا توكن ومستخدم مسجل، نقوم بالتحديث
    if (token != null && user != null) {
      try {
        await Supabase.instance.client
            .from('profiles') // اسم الجدول عندك
            .update({'fcm_token': token}) // تحديث العمود بالتوكن
            .eq('id', user.id); // للمستخدم الحالي فقط

        debugPrint('تم ربط جهازك بالحساب بنجاح');
      } catch (e) {
        debugPrint('حدث خطأ أثناء الحفظ: $e');
      }
    }
  }
}