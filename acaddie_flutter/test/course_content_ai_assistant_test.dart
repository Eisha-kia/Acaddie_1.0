import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:acaddie/services/course_content_ai_assistant.dart';
import 'package:acaddie/widgets/content_conflict_assistant_modal.dart';

void main() {
  final List<Map<String, dynamic>> mockCourses = [
    {
      'code': 'CSE1101',
      'title': 'Elementary Structured Programming',
      'year': 'Year 1',
      'topics': [
        {'name': 'Variables, Data Types & Formatted I/O', 'weeks': '2.0w', 'blooms': 'K3 Apply'},
        {'name': 'Functions, Scope & Recursion', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE2103',
      'title': 'Data Structures',
      'year': 'Year 2',
      'topics': [
        {'name': 'Stacks, Queues & Evaluation of Expressions', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Binary Trees, BSTs & AVL Balanced Trees', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE2207',
      'title': 'Algorithms',
      'year': 'Year 2',
      'topics': [
        {'name': 'Divide and Conquer & Dynamic Programming', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE4203',
      'title': 'Machine Learning',
      'year': 'Year 4',
      'topics': [
        {'name': 'Supervised Learning & Decision Trees', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Deep Neural Networks & Architectures', 'weeks': '3.0w', 'blooms': 'K5 Evaluate'},
      ],
    },
  ];

  group('CourseContentAiAssistant Engine Tests', () {
    test('Addition of standard course-appropriate topic is classified as safe', () {
      final result = CourseContentAiAssistant.analyzeAddContent(
        newContentTitle: 'Sorting Algorithmic Invariants & Stability',
        targetCourseCode: 'CSE2207',
        targetCourseTitle: 'Algorithms',
        allCourses: mockCourses,
      );

      expect(result.actionType, equals(ContentActionType.add));
      expect(result.isSafe, isTrue);
      expect(result.severity, equals(ContentConflictSeverity.safe));
      expect(result.analysisBulletPoints.any((b) => b.contains('No direct prerequisite conflict')), isTrue);
    });

    test('Addition of Year 4 advanced AI topic into Year 1 course triggers prerequisite conflict', () {
      final result = CourseContentAiAssistant.analyzeAddContent(
        newContentTitle: 'Deep Neural Networks & Transformer Attention Heads',
        targetCourseCode: 'CSE1101',
        targetCourseTitle: 'Elementary Structured Programming',
        allCourses: mockCourses,
      );

      expect(result.isSafe, isFalse);
      expect(result.hasConflict, isTrue);
      expect(result.severity, equals(ContentConflictSeverity.warning));
      expect(result.affectedItems.any((i) => i.courseCode == 'CSE4203'), isTrue);
      expect(result.reasonExplanation.contains('violates curriculum sequencing'), isTrue);
      expect(result.suggestedAlternatives.isNotEmpty, isTrue);
    });

    test('Addition of topic overlapping another course triggers overlap advisory', () {
      final result = CourseContentAiAssistant.analyzeAddContent(
        newContentTitle: 'Binary Trees and Balanced Search Trees',
        targetCourseCode: 'CSE1101',
        targetCourseTitle: 'Elementary Structured Programming',
        allCourses: mockCourses,
      );

      expect(result.hasConflict, isTrue);
      expect(result.affectedItems.any((i) => i.courseCode == 'CSE2103'), isTrue);
    });

    test('Deletion of foundational Stack/Queue topic triggers critical downstream dependency', () {
      final result = CourseContentAiAssistant.analyzeDeleteContent(
        contentTitle: 'Stacks, Queues & Evaluation of Expressions',
        targetCourseCode: 'CSE2103',
        targetCourseTitle: 'Data Structures',
        allCourses: mockCourses,
      );

      expect(result.severity, equals(ContentConflictSeverity.critical));
      expect(result.severityLabel, equals('Not recommended to remove'));
      expect(result.affectedItems.isNotEmpty, isTrue);
      expect(result.affectedItems.any((i) => i.courseCode == 'CSE2207'), isTrue);
      expect(result.reasonExplanation.contains('assume students have already mastered'), isTrue);
    });

    test('Deletion of standalone elective topic is safe to remove', () {
      final result = CourseContentAiAssistant.analyzeDeleteContent(
        contentTitle: 'Historical Milestones of Computational Technology',
        targetCourseCode: 'CSE1101',
        targetCourseTitle: 'Elementary Structured Programming',
        allCourses: mockCourses,
      );

      expect(result.isSafe, isTrue);
      expect(result.severity, equals(ContentConflictSeverity.safe));
      expect(result.severityLabel, equals('Safe to remove'));
    });
  });

  group('ContentConflictAssistantModal Widget Tests', () {
    testWidgets('Modal displays critical delete conflict advisory and interactive buttons', (WidgetTester tester) async {
      final analysis = CourseContentAiAssistant.analyzeDeleteContent(
        contentTitle: 'Stacks, Queues & Evaluation of Expressions',
        targetCourseCode: 'CSE2103',
        targetCourseTitle: 'Data Structures',
        allCourses: mockCourses,
      );

      bool confirmed = false;
      bool cancelled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ContentConflictAssistantModal.show(
                    context: context,
                    analysis: analysis,
                    onConfirm: () => confirmed = true,
                    onCancel: () => cancelled = true,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      // Open the modal
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      // Check for title and advisory elements
      expect(find.text('AI Content Impact Analysis'), findsOneWidget);
      expect(find.text('NOT RECOMMENDED TO REMOVE'), findsOneWidget);
      expect(find.text('Continue Anyway'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Click "Continue Anyway"
      await tester.tap(find.text('Continue Anyway'));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
      expect(cancelled, isFalse);
    });
  });
}
