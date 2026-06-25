import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swift_chat/features/chat/presentation/widgets/chat_bubble_widget.dart';

void main() {
  group('ChatBubble Widget Tests', () {

    testWidgets('should display text message and read status correctly when isMe is true', (WidgetTester tester) async {
      final testTime = DateTime.now();

      // نقوم ببناء الـ ChatBubble داخل MaterialApp لأن أي ويدجت يحتوي على نصوص وألوان يحتاج لـ Scaffold و MaterialApp
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: 'Hello Swift Chat!',
              isMe: true,
              type: 'text',
              time: testTime,
              status: 'read', // الحالة مقروءة يعني نتوقع أيقونة صحين باللون الأزرق
            ),
          ),
        ),
      );

      // 2. Assert: نتحقق أن النص يظهر بشكل صحيح في الشاشة
      expect(find.text('Hello Swift Chat!'), findsOneWidget);

      // نتحقق من وجود أيقونة الصحين (Icons.done_all) لأن الحالة 'read'
      expect(find.byIcon(Icons.done_all), findsOneWidget);

      // نتحقق أن أيقونة الصح الواحد (Icons.done) غير موجودة بالمرة
      expect(find.byIcon(Icons.done), findsNothing);
    });

    testWidgets('should display single check icon when status is sent', (WidgetTester tester) async {
      // اختبار حالة أخرى: الرسالة أُرسلت فقط ولم تُقرأ بعد
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubble(
              message: 'Are you there?',
              isMe: true,
              type: 'text',
              time: DateTime.now(),
              status: 'sent', // الحالة مرسلة فقط
            ),
          ),
        ),
      );

      // نتحقق أن أيقونة الصح الواحد (Icons.done) هي التي تظهر الآن
      expect(find.byIcon(Icons.done), findsOneWidget);
      // أيقونة الصحين لا يجب أن تظهر
      expect(find.byIcon(Icons.done_all), findsNothing);
    });
  });
}