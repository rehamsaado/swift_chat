import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. تخيلي أن هذا هو الـ Repository الحقيقي الموجود في كودك
abstract class ChatRepository {
  Future<String> getUserName(String userId);
}

// 2. هنا ننشئ الطبقة الوهمية (Mock) باستخدام Mocktail
class MockChatRepository extends Mock implements ChatRepository {}

// 3. هذا هو الـ UseCase الذي نريد اختباره، وهو يعتمد على الـ Repository
class GetUserNameUseCase {
  final ChatRepository repository;

  GetUserNameUseCase(this.repository);

  Future<String> call(String userId) async {
    // هنا منطق العمل (مثلاً: إضافة كلمة "Welcome" قبل الاسم)
    final name = await repository.getUserName(userId);
    return 'Welcome, $name';
  }
}

void main() {
  // تعريف المتغيرات التي سنستخدمها في الاختبار
  late MockChatRepository mockChatRepository;
  late GetUserNameUseCase getUserNameUseCase;

  // دالة setUp تعمل تلقائياً قبل تشغيل أي تيست لتهيئة المتغيرات
  setUp(() {
    mockChatRepository = MockChatRepository();
    getUserNameUseCase = GetUserNameUseCase(mockChatRepository);
  });

  group('GetUserNameUseCase Tests', () {
    const tUserId = '123';
    const tResponseName = 'Reham';

    test('should return welcome message with user name from repository', () async {
      // [Arrange] السحر هنا: نُخبر الـ Mock أنه عندما يُستدعى بأي شكل، يعيد اسم "Reham" جاهزاً بدون إنترنت
      when(() => mockChatRepository.getUserName(tUserId))
          .thenAnswer((_) async => tResponseName);

      // [Act] نشغل الـ UseCase الحقيقي الذي نريد اختباره
      final result = await getUserNameUseCase(tUserId);

      // [Assert] نتحقق أن الـ UseCase قام بعمله وأضاف كلمة Welcome
      expect(result, 'Welcome, Reham');

      // نتحقق أيضاً أن الـ UseCase استدعى الدالة من الـ Repository لمرة واحدة فقط وبشكل صحيح
      verify(() => mockChatRepository.getUserName(tUserId)).called(1);
    });
  });
}