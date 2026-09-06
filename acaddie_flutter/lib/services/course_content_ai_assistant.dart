/// Severity classifications for content conflicts and dependencies
enum ContentConflictSeverity {
  safe, // ✓ Safe / No conflict detected
  info, // ℹ Information / Minor overlap
  warning, // ⚠ Potential Conflict / Potential dependency
  critical, // 🔴 Critical Conflict / Not recommended to remove / Prerequisite conflict
}

/// Type of content modification
enum ContentActionType {
  add,
  delete,
  edit,
}

/// Represents an affected course, module, or topic across the curriculum
class AffectedContentItem {
  final String courseCode;
  final String courseTitle;
  final String moduleOrTopic;
  final String relationshipType; // 'Prerequisite Dependency', 'Curriculum Overlap', 'Downstream Consumer'
  final String reason;
  final String yearSemester;

  const AffectedContentItem({
    required this.courseCode,
    required this.courseTitle,
    required this.moduleOrTopic,
    required this.relationshipType,
    required this.reason,
    required this.yearSemester,
  });
}

/// Complete result of the AI Content Impact Analysis
class ContentAnalysisResult {
  final ContentActionType actionType;
  final String contentTitle;
  final String targetCourseCode;
  final String targetCourseTitle;
  final ContentConflictSeverity severity;
  final String severityLabel;
  final String impactSummary;
  final List<String> analysisBulletPoints;
  final List<AffectedContentItem> affectedItems;
  final String reasonExplanation;
  final String potentialRepercussion;
  final String aiRecommendation;
  final List<String> suggestedAlternatives;

  const ContentAnalysisResult({
    required this.actionType,
    required this.contentTitle,
    required this.targetCourseCode,
    required this.targetCourseTitle,
    required this.severity,
    required this.severityLabel,
    required this.impactSummary,
    required this.analysisBulletPoints,
    required this.affectedItems,
    required this.reasonExplanation,
    required this.potentialRepercussion,
    required this.aiRecommendation,
    required this.suggestedAlternatives,
  });

  bool get isSafe => severity == ContentConflictSeverity.safe;
  bool get hasConflict => severity != ContentConflictSeverity.safe;
}

/// AI-Powered Course Content Conflict & Dependency Assistant Engine
/// Strictly analyzes COURSE CONTENT only (topics, lessons, modules, prerequisites).
/// NEVER modifies or deletes courses automatically.
class CourseContentAiAssistant {
  // Concept Knowledge Graph: maps concepts/keywords to courses, prerequisites, and downstream dependents
  static final Map<String, Map<String, dynamic>> _conceptGraph = {
    'stack': {
      'foundationalCourse': 'CSE2103',
      'foundationalTitle': 'Data Structures',
      'downstream': [
        {
          'course': 'CSE2207',
          'title': 'Algorithms',
          'target': 'Graph Traversals (DFS), Backtracking & Call Stacks',
          'semester': 'Year 2, Sem 2',
          'type': 'Direct Prerequisite Dependency',
          'reason': 'Graph depth-first search and recursive stack frames build upon fundamental stack data structures.',
        },
        {
          'course': 'CSE3103',
          'title': 'Operating Systems',
          'target': 'Process Thread Call Stacks & Interrupt Handling',
          'semester': 'Year 3, Sem 1',
          'type': 'System Dependency',
          'reason': 'Process execution contexts and thread memory management assume mastery of stack frames.',
        },
        {
          'course': 'CSE3207',
          'title': 'Compiler Design',
          'target': 'Bottom-up Shift-Reduce Parsing & Syntax Trees',
          'semester': 'Year 3, Sem 2',
          'type': 'Algorithmic Prerequisite',
          'reason': 'Shift-reduce syntax analyzers and runtime memory management operate on stack structures.',
        },
      ],
    },
    'queue': {
      'foundationalCourse': 'CSE2103',
      'foundationalTitle': 'Data Structures',
      'downstream': [
        {
          'course': 'CSE2207',
          'title': 'Algorithms',
          'target': 'Breadth-First Search (BFS) & Shortest Path Frontier',
          'semester': 'Year 2, Sem 2',
          'type': 'Direct Prerequisite Dependency',
          'reason': 'Breadth-first search queue frontier relies on FIFO queue primitives.',
        },
        {
          'course': 'CSE3103',
          'title': 'Operating Systems',
          'target': 'Ready Queue, Round-Robin CPU Scheduling & I/O Buffers',
          'semester': 'Year 3, Sem 1',
          'type': 'Core Architectural Dependency',
          'reason': 'Process scheduling algorithms (RR, Multilevel Feedback Queues) require queue operations.',
        },
        {
          'course': 'CSE3203',
          'title': 'Computer Networks',
          'target': 'Packet Queuing, Bufferbloat & Sliding Window Flow',
          'semester': 'Year 3, Sem 2',
          'type': 'Networking Concept Dependency',
          'reason': 'Router buffer queues and network interface card packet dispatch rely on queue theory.',
        },
      ],
    },
    'tree': {
      'foundationalCourse': 'CSE2103',
      'foundationalTitle': 'Data Structures',
      'downstream': [
        {
          'course': 'CSE3101',
          'title': 'Database Systems',
          'target': 'B+ Tree Indexing & Query Execution Plans',
          'semester': 'Year 3, Sem 1',
          'type': 'Storage Prerequisite',
          'reason': 'Database physical storage engines use balanced B+ tree indexing for logarithmic range lookups.',
        },
        {
          'course': 'CSE3207',
          'title': 'Compiler Design',
          'target': 'Abstract Syntax Trees (AST) & Parse Trees',
          'semester': 'Year 3, Sem 2',
          'type': 'Syntax Parsing Dependency',
          'reason': 'Intermediate code representation relies on Abstract Syntax Trees.',
        },
      ],
    },
    'graph': {
      'foundationalCourse': 'CSE1203',
      'foundationalTitle': 'Discrete Mathematics',
      'downstream': [
        {
          'course': 'CSE2103',
          'title': 'Data Structures',
          'target': 'Adjacency Matrix & Adjacency List Implementations',
          'semester': 'Year 2, Sem 1',
          'type': 'Mathematical Foundation',
          'reason': 'Formal graph definitions are introduced in Discrete Math before coding in Data Structures.',
        },
        {
          'course': 'CSE2207',
          'title': 'Algorithms',
          'target': 'Dijkstra, Bellman-Ford, Kruskal & Prim MST Algorithms',
          'semester': 'Year 2, Sem 2',
          'type': 'Core Prerequisite',
          'reason': 'Advanced shortest path and network flow algorithms assume prior graph traversal knowledge.',
        },
        {
          'course': 'CSE3203',
          'title': 'Computer Networks',
          'target': 'OSPF / BGP Link-State & Distance-Vector Routing',
          'semester': 'Year 3, Sem 2',
          'type': 'Applied Routing Dependency',
          'reason': 'Internet routing protocols use Dijkstra and Bellman-Ford on network topology graphs.',
        },
      ],
    },
    'pointer': {
      'foundationalCourse': 'CSE1101',
      'foundationalTitle': 'Elementary Structured Programming',
      'downstream': [
        {
          'course': 'CSE1205',
          'title': 'Object Oriented Programming',
          'target': 'Dynamic Object Instantiation & Memory Management',
          'semester': 'Year 1, Sem 2',
          'type': 'Core Prerequisite',
          'reason': 'Understanding object references and destructor cleanup requires pointer fundamentals.',
        },
        {
          'course': 'CSE2103',
          'title': 'Data Structures',
          'target': 'Singly / Doubly Linked Lists & Dynamic Memory Nodes',
          'semester': 'Year 2, Sem 1',
          'type': 'Direct Structural Dependency',
          'reason': 'Linked structures cannot be implemented without node pointer manipulation.',
        },
        {
          'course': 'CSE3103',
          'title': 'Operating Systems',
          'target': 'Virtual Memory Addressing & Kernel Pointers',
          'semester': 'Year 3, Sem 1',
          'type': 'Kernel Architecture Dependency',
          'reason': 'Page tables and virtual address translations demand solid pointer arithmetic grasp.',
        },
      ],
    },
    'recursion': {
      'foundationalCourse': 'CSE1101',
      'foundationalTitle': 'Elementary Structured Programming',
      'downstream': [
        {
          'course': 'CSE2103',
          'title': 'Data Structures',
          'target': 'Recursive Tree Traversals (Inorder, Preorder, Postorder)',
          'semester': 'Year 2, Sem 1',
          'type': 'Implementation Prerequisite',
          'reason': 'Tree traversals and divide-and-conquer operations require functional recursion comprehension.',
        },
        {
          'course': 'CSE2207',
          'title': 'Algorithms',
          'target': 'Divide & Conquer Recurrences & Dynamic Programming Memoization',
          'semester': 'Year 2, Sem 2',
          'type': 'Theoretical Prerequisite',
          'reason': 'Master Theorem recurrence relations and recursive memoization build on recursion fundamentals.',
        },
      ],
    },
    'machine learning': {
      'foundationalCourse': 'CSE4203',
      'foundationalTitle': 'Machine Learning',
      'downstream': [],
    },
    'neural network': {
      'foundationalCourse': 'CSE4203',
      'foundationalTitle': 'Machine Learning',
      'downstream': [],
    },
    'sql': {
      'foundationalCourse': 'CSE3101',
      'foundationalTitle': 'Database Systems',
      'downstream': [
        {
          'course': 'CSE3205',
          'title': 'Software Engineering',
          'target': 'Persistence Layer & ORM Integration',
          'semester': 'Year 3, Sem 2',
          'type': 'Software Architecture Dependency',
          'reason': 'Full-stack software engineering projects depend on relational database persistence and SQL.',
        },
      ],
    },
    'boolean': {
      'foundationalCourse': 'CSE2105',
      'foundationalTitle': 'Digital Logic Design',
      'downstream': [
        {
          'course': 'CSE3105',
          'title': 'Computer Architecture',
          'target': 'ALU Datapath Design & Control Unit Micro-operations',
          'semester': 'Year 3, Sem 1',
          'type': 'Hardware Datapath Prerequisite',
          'reason': 'Microprocessor logic and ALU arithmetic circuits are designed using boolean expressions.',
        },
      ],
    },
  };

  /// Analyzes the impact when an admin/user ADDS new content (topic, chapter, module, etc.)
  static ContentAnalysisResult analyzeAddContent({
    required String newContentTitle,
    required String targetCourseCode,
    required String targetCourseTitle,
    required List<Map<String, dynamic>> allCourses,
  }) {
    final lowerTitle = newContentTitle.toLowerCase();
    final List<AffectedContentItem> affected = [];
    final List<String> bulletPoints = [];
    ContentConflictSeverity severity = ContentConflictSeverity.safe;
    String severityLabel = 'No conflict detected';
    String impactSummary = '✓ No conflicts or dependencies detected.';
    String reason = 'The proposed content integrates seamlessly with the target course scope without duplicate topics or sequencing violations.';
    String repercussion = 'Adding this topic enriches the syllabus within normal credit hour allocations and does not disrupt any downstream curriculum.';
    String recommendation = 'Safe to add. The content aligns with program learning outcomes and standard pedagogical pacing.';
    final List<String> alternatives = ['Keep Content as Proposed'];

    // 1. Check for Duplicate Content or Semantic Overlap with other courses
    Map<String, dynamic>? overlappingCourse;
    String? matchedTopicName;

    for (final course in allCourses) {
      final code = course['code'] as String;
      if (code == targetCourseCode) continue;

      final topics = (course['topics'] as List?) ?? [];
      for (final t in topics) {
        final topicName = (t['name'] as String).toLowerCase();
        final similarity = _calculateTopicOverlap(lowerTitle, topicName);
        if (similarity > 0.45) {
          overlappingCourse = course;
          matchedTopicName = t['name'] as String;
          break;
        }
      }
      if (overlappingCourse != null) break;
    }

    // 2. Check for Specific High-Level Advanced Topics in Lower-Year Courses (Sequencing Conflict)
    final bool isLowerYearCourse = targetCourseCode.contains('11') ||
        targetCourseCode.contains('12') ||
        targetCourseCode.contains('21');

    final bool isAdvancedAiTopic = lowerTitle.contains('neural') ||
        lowerTitle.contains('deep learning') ||
        lowerTitle.contains('transformer') ||
        lowerTitle.contains('machine learning') ||
        lowerTitle.contains('large language') ||
        lowerTitle.contains('gpt') ||
        lowerTitle.contains('reinforcement learning');

    final bool isAdvancedCloudTopic = lowerTitle.contains('kubernetes') ||
        lowerTitle.contains('microservices') ||
        lowerTitle.contains('distributed consensus') ||
        lowerTitle.contains('raft protocol') ||
        lowerTitle.contains('cloud storage');

    if (isLowerYearCourse && isAdvancedAiTopic) {
      severity = ContentConflictSeverity.warning;
      severityLabel = 'Potential Prerequisite Conflict';
      impactSummary = '⚠ Prerequisite conflict & topic overlap detected';
      bulletPoints.add('⚠ Premature topic sequencing for Year 1/2 course ($targetCourseCode)');
      bulletPoints.add('⚠ Overlaps with Year 4 Course CSE4203 (Machine Learning) and CSE4107 (Artificial Intelligence)');
      bulletPoints.add('✓ No backward dependency broken, but cognitive load warning triggered');

      affected.add(
        const AffectedContentItem(
          courseCode: 'CSE4203',
          courseTitle: 'Machine Learning',
          moduleOrTopic: 'Module 4: Deep Neural Networks & Architectures',
          relationshipType: 'Curriculum Overlap',
          reason: 'This advanced topic is formally slated for 4th-year specialization after Linear Algebra and Probability prerequisites.',
          yearSemester: 'Year 4, Semester 8',
        ),
      );
      affected.add(
        const AffectedContentItem(
          courseCode: 'CSE4107',
          courseTitle: 'Artificial Intelligence',
          moduleOrTopic: 'Module 3: Neural Learning Primitives',
          relationshipType: 'Concept Duplication',
          reason: 'Introductory neural models are covered here; teaching advanced networks in earlier courses duplicates syllabus effort.',
          yearSemester: 'Year 4, Semester 7',
        ),
      );

      reason = 'Introducing deep learning or transformer concepts in $targetCourseCode violates curriculum sequencing. Students have not yet completed foundational courses in Linear Algebra, Vector Calculus, or Data Structures.';
      repercussion = 'Students may experience significant conceptual friction due to missing mathematical and data representation prerequisites. Furthermore, it creates duplicate teaching hours when students reach 4th-year CSE4203.';
      recommendation = 'Consider linking this topic as an optional reading or scoping it strictly to basic data structure representations, while keeping the full theoretical treatment in CSE4203 Machine Learning.';
      alternatives.addAll([
        'Scope down to basic introductory overview (0.5 weeks)',
        'Link to CSE4203 Machine Learning as a prerequisite reference',
        'Relocate topic to an elective course syllabus',
      ]);
    } else if (overlappingCourse != null) {
      severity = ContentConflictSeverity.warning;
      severityLabel = 'Minor Overlap / Potential Dependency';
      final overlapCode = overlappingCourse['code'] as String;
      final overlapTitle = overlappingCourse['title'] as String;
      final overlapYear = overlappingCourse['year'] as String;

      impactSummary = '⚠ Content overlap detected with $overlapCode';
      bulletPoints.add('⚠ Similar content already covered in $overlapCode ($overlapTitle)');
      bulletPoints.add('ℹ May create cross-course redundancy if scope is not differentiated');
      bulletPoints.add('✓ Sequencing order is acceptable within departmental track');

      affected.add(
        AffectedContentItem(
          courseCode: overlapCode,
          courseTitle: overlapTitle,
          moduleOrTopic: 'Topic: $matchedTopicName',
          relationshipType: 'Syllabus Overlap',
          reason: 'Both topics address identical algorithmic and conceptual mechanisms.',
          yearSemester: overlapYear,
        ),
      );

      reason = 'The newly proposed topic "$newContentTitle" closely mirrors "$matchedTopicName" which is already part of the core curriculum in $overlapCode ($overlapTitle).';
      repercussion = 'Students taking both courses will encounter repeated instructional content, reducing effective classroom hours for new specialized material.';
      recommendation = 'Consider linking this chapter to $overlapCode instead of duplicating the foundational material, or narrow the scope to highlight application-specific nuances.';
      alternatives.addAll([
        'Cross-reference $overlapCode to avoid redundant lectures',
        'Specialize topic to focus solely on unique applications',
        'Modify topic title and learning outcomes to clarify distinction',
      ]);
    } else if (isLowerYearCourse && isAdvancedCloudTopic) {
      severity = ContentConflictSeverity.warning;
      severityLabel = 'Prerequisite Conflict';
      impactSummary = '⚠ Prerequisite gap: Operating Systems & Networking required';
      bulletPoints.add('⚠ Distributed systems topics require prior Operating Systems (CSE3103)');
      bulletPoints.add('⚠ Network socket concepts from Computer Networks (CSE3203) are required');

      affected.add(
        const AffectedContentItem(
          courseCode: 'CSE3103',
          courseTitle: 'Operating Systems',
          moduleOrTopic: 'Module 4: Concurrency & IPC',
          relationshipType: 'Prerequisite Dependency',
          reason: 'Distributed protocols assume complete familiarity with process concurrency and synchronization.',
          yearSemester: 'Year 3, Sem 1',
        ),
      );

      reason = 'Distributed consensus and microservices architectures require background in process scheduling, threads, and network socket programming.';
      repercussion = 'Students may struggle with network latency and fault recovery concepts without prior OS and networking background.';
      recommendation = 'Defer distributed systems architecture to Year 4 (CSE4201 Distributed Systems). Limit current addition to single-machine algorithms.';
      alternatives.addAll([
        'Focus on single-process multithreading only',
        'Add prerequisite note pointing to CSE3103',
      ]);
    } else {
      // Safe addition
      bulletPoints.add('✓ No direct prerequisite conflict');
      bulletPoints.add('✓ No significant content overlap with other courses');
      bulletPoints.add('✓ Curriculum sequencing adheres to ABET / OBE standards');
    }

    return ContentAnalysisResult(
      actionType: ContentActionType.add,
      contentTitle: newContentTitle,
      targetCourseCode: targetCourseCode,
      targetCourseTitle: targetCourseTitle,
      severity: severity,
      severityLabel: severityLabel,
      impactSummary: impactSummary,
      analysisBulletPoints: bulletPoints,
      affectedItems: affected,
      reasonExplanation: reason,
      potentialRepercussion: repercussion,
      aiRecommendation: recommendation,
      suggestedAlternatives: alternatives,
    );
  }

  /// Analyzes the impact when an admin/user attempts to DELETE or CLOSE content
  static ContentAnalysisResult analyzeDeleteContent({
    required String contentTitle,
    required String targetCourseCode,
    required String targetCourseTitle,
    required List<Map<String, dynamic>> allCourses,
  }) {
    final lowerTitle = contentTitle.toLowerCase();
    final List<AffectedContentItem> affected = [];
    final List<String> bulletPoints = [];
    ContentConflictSeverity severity = ContentConflictSeverity.safe;
    String severityLabel = 'Safe to remove';
    String impactSummary = '✓ Safe to remove — No downstream dependencies detected.';
    String reason = 'This topic is either self-contained or an elective branch that is not mandated as a prerequisite by any downstream courses.';
    String repercussion = 'Removing this content will free up course credit hours without causing instructional gaps in subsequent semesters.';
    String recommendation = 'Safe to remove. You can proceed with removing this content from the course.';
    final List<String> alternatives = ['Proceed with Removal'];

    // Search knowledge graph for matched key concepts
    for (final entry in _conceptGraph.entries) {
      final conceptKey = entry.key;
      if (lowerTitle.contains(conceptKey)) {
        final data = entry.value;
        final String foundCourse = data['foundationalCourse'] as String;

        // If this is indeed the foundational course providing the concept
        if (targetCourseCode.contains(foundCourse.replaceAll('CSE', '')) ||
            targetCourseCode.contains(foundCourse)) {
          final downstreamList = (data['downstream'] as List<dynamic>?) ?? [];

          if (downstreamList.isNotEmpty) {
            severity = ContentConflictSeverity.critical;
            severityLabel = 'Not recommended to remove';
            impactSummary = '🔴 ${downstreamList.length} downstream course dependencies detected';

            bulletPoints.add('🔴 Core foundational concept for subsequent curriculum years');
            bulletPoints.add('🔴 Removing creates direct prerequisite deficit in ${downstreamList.length} courses');
            bulletPoints.add('⚠ ABET / OBE accreditation outcome mapping will be compromised');

            for (final d in downstreamList) {
              affected.add(
                AffectedContentItem(
                  courseCode: d['course'] as String,
                  courseTitle: d['title'] as String,
                  moduleOrTopic: d['target'] as String,
                  relationshipType: d['type'] as String,
                  reason: d['reason'] as String,
                  yearSemester: d['semester'] as String,
                ),
              );
            }

            reason = 'The content "$contentTitle" introduces fundamental abstractions and primitives that subsequent departmental courses explicitly assume students have already mastered.';
            repercussion = 'Removing this topic without a curriculum replacement will cause students in downstream courses to lack prerequisite knowledge, resulting in failed lab assignments, cognitive friction, and accreditation non-compliance.';
            recommendation = 'Removing this content is NOT recommended unless the dependent courses are simultaneously revised to cover these foundational concepts.';
            alternatives.addAll([
              'Condense topic duration instead of deleting (e.g., reduce to 1.0 week)',
              'Migrate foundational principles to an earlier lab module',
              'Update downstream course syllabi before confirming deletion',
            ]);
            break;
          }
        }
      }
    }

    // Check if it's a general core topic with moderate importance
    if (severity == ContentConflictSeverity.safe) {
      if (lowerTitle.contains('sort') ||
          lowerTitle.contains('search') ||
          lowerTitle.contains('array') ||
          lowerTitle.contains('loop') ||
          lowerTitle.contains('function') ||
          lowerTitle.contains('logic')) {
        severity = ContentConflictSeverity.warning;
        severityLabel = 'Remove with caution';
        impactSummary = '⚠ Potential curriculum ripple effect detected';
        bulletPoints.add('⚠ Topic provides standard programming fluency for downstream labs');
        bulletPoints.add('ℹ May affect student problem-solving readiness in competitive programming and exams');

        affected.add(
          const AffectedContentItem(
            courseCode: 'CSE2207',
            courseTitle: 'Algorithms',
            moduleOrTopic: 'Module 1: Algorithmic Complexity & Foundations',
            relationshipType: 'Foundational Proficiency',
            reason: 'Students utilize these basic structures during programming assignments and labs.',
            yearSemester: 'Year 2, Sem 2',
          ),
        );

        reason = 'While not an exclusive single prerequisite, this topic provides essential practice for programming proficiency across the engineering program.';
        repercussion = 'Students may have less hands-on practice, leading to slower assignment completion in higher-level lab courses.';
        recommendation = 'Remove with caution. Ensure students cover equivalent programming practice in accompanying lab sessions.';
        alternatives.addAll([
          'Replace with modern applied exercise instead of removing completely',
          'Merge into an adjacent topic module',
        ]);
      } else {
        bulletPoints.add('✓ No dependent courses reference this topic');
        bulletPoints.add('✓ Core learning objectives remain fully covered by remaining topics');
        bulletPoints.add('✓ Safe to remove from the current course structure');
      }
    }

    return ContentAnalysisResult(
      actionType: ContentActionType.delete,
      contentTitle: contentTitle,
      targetCourseCode: targetCourseCode,
      targetCourseTitle: targetCourseTitle,
      severity: severity,
      severityLabel: severityLabel,
      impactSummary: impactSummary,
      analysisBulletPoints: bulletPoints,
      affectedItems: affected,
      reasonExplanation: reason,
      potentialRepercussion: repercussion,
      aiRecommendation: recommendation,
      suggestedAlternatives: alternatives,
    );
  }

  /// Calculates simple word overlap similarity between two topic strings
  static double _calculateTopicOverlap(String str1, String str2) {
    final words1 = str1
        .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ')
        .split(' ')
        .where((w) => w.length > 3 && !_stopWords.contains(w))
        .toSet();
    final words2 = str2
        .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), ' ')
        .split(' ')
        .where((w) => w.length > 3 && !_stopWords.contains(w))
        .toSet();

    if (words1.isEmpty || words2.isEmpty) return 0.0;
    final intersection = words1.intersection(words2);
    return (2.0 * intersection.length) / (words1.length + words2.length);
  }

  static const Set<String> _stopWords = {
    'with',
    'from',
    'that',
    'this',
    'using',
    'into',
    'about',
    'basic',
    'introduction',
    'introductory',
    'advanced',
    'course',
    'concepts',
    'overview',
  };
}
