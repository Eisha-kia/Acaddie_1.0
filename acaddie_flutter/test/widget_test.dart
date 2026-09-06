import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:acaddie/main.dart';
import 'package:acaddie/services/academic_engine.dart';
import 'package:acaddie/services/theme_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('AcademicEngine baseline data loads properly', () {
    final courses = AcademicEngine.courses;
    expect(courses.isNotEmpty, isTrue);
    expect(courses.any((c) => c.code.contains('CSE')), isTrue);
    expect(AcademicEngine.university.shortName, equals('AUST'));
  });

  testWidgets('AcaddieApp smoke test loads correctly', (WidgetTester tester) async {
    await ThemeService.init();
    await tester.pumpWidget(const AcaddieApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
