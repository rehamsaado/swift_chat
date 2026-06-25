import 'package:flutter_test/flutter_test.dart';

// دالة برمجية بسيطة للتحقق من الإيميل (تخيلي أنها موجودة في الـ core عندكِ)
bool isValidEmail(String email) {
  return email.contains('@') && email.endsWith('.com');
}

void main() {
  // دالة group تستخدم لجمع الاختبارات المتشابهة معاً
  group('Email Validator Tests', () {

    // الاختبار الأول: حالة الإيميل الصحيح
    test('should return true when email is valid', () {
      // 1. الترتيب والمدخلات (Arrange)
      const email = 'reham@example.com';

      // 2. تشغيل الدالة المراد اختبارها (Act)
      final result = isValidEmail(email);

      // 3. التحقق من النتيجة المتوقعة (Assert)
      expect(result, isTrue); // نتوقع أن تكون النتيجة true
    });

    // الاختبار الثاني: حالة الإيميل الخاطئ (بدون @)
    test('should return false when email misses @ symbol', () {
      const email = 'reham-example.com';
      final result = isValidEmail(email);
      expect(result, isFalse); // نتوقع أن تكون النتيجة false
    });

  });
}