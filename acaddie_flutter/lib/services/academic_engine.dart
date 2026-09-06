import 'dart:math';
import '../models/curriculum_models.dart';

class AcademicEngine {
  static final UniversityMetadata university = UniversityMetadata(
    name: "Ahsanullah University of Science and Technology",
    shortName: "AUST",
    department: "Department of Computer Science and Engineering",
    program: "Bachelor of Science in Computer Science and Engineering",
    curriculumVersion: "2025-2026 Outcome-Based Education (OBE) Standard",
  );

  static final List<Course> courses = [
    Course(
      id: "CSE-101",
      code: "CSE 101",
      name: "Programming Fundamentals",
      semester: 1,
      credit: 3.0,
      type: "Core",
      description: "Procedural problem solving, syntax, pointers, memory allocation, and structured programming paradigms in C/C++.",
      prerequisites: [],
      theoryPercentage: 85,
      practicalPercentage: 15,
      clos: [
        CLO(id: "CSE101-CLO1", description: "Construct structured algorithms to solve fundamental computational tasks.", bloomLevel: "Apply", importance: 30),
        CLO(id: "CSE101-CLO2", description: "Implement modular, bug-free C/C++ programs utilizing control flows and arrays.", bloomLevel: "Apply", importance: 35),
        CLO(id: "CSE101-CLO3", description: "Demonstrate manual memory management through pointer manipulation and dynamic memory allocation.", bloomLevel: "Analyze", importance: 35),
      ],
      topics: [
        Topic(id: "PF-1", name: "Variables, Primitive Types & Expressions", weeks: 1.5, importance: "Core", cloId: "CSE101-CLO1"),
        Topic(id: "PF-2", name: "Control Structures, Branching & Loops", weeks: 2.0, importance: "Core", cloId: "CSE101-CLO1"),
        Topic(id: "PF-3", name: "Modular Functions & Scope", weeks: 2.5, importance: "Core", cloId: "CSE101-CLO2"),
        Topic(id: "PF-4", name: "Pointers, References & Heap Allocation", weeks: 3.0, importance: "Critical", cloId: "CSE101-CLO3"),
        Topic(id: "PF-5", name: "Multi-dimensional Arrays & Strings", weeks: 3.0, importance: "Core", cloId: "CSE101-CLO2"),
      ],
    ),
    Course(
      id: "CSE-207",
      code: "CSE 207",
      name: "Data Structures",
      semester: 3,
      credit: 3.0,
      type: "Core",
      description: "Linear and hierarchical data structures, abstract data types, recursive formulations, graph algorithms, and asymptotic complexity.",
      prerequisites: ["CSE-101"],
      theoryPercentage: 65,
      practicalPercentage: 35,
      clos: [
        CLO(id: "CSE207-CLO1", description: "Analyze asymptotic computational time and space bounds for operations on diverse data structures.", bloomLevel: "Analyze", importance: 20),
        CLO(id: "CSE207-CLO2", description: "Implement fundamental linear data structures (arrays, linked lists, stacks, queues).", bloomLevel: "Apply", importance: 25),
        CLO(id: "CSE207-CLO3", description: "Design efficient recursive, tree, and graph algorithms for network traversals and shortest paths.", bloomLevel: "Create", importance: 35),
        CLO(id: "CSE207-CLO4", description: "Evaluate trade-offs between memory footprint and access speed in hashing.", bloomLevel: "Evaluate", importance: 20),
      ],
      topics: [
        Topic(id: "DS-1", name: "Asymptotic Analysis & Dynamic Arrays", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO1"),
        Topic(id: "DS-2", name: "Linked Lists (Singly, Doubly, Circular)", weeks: 2.0, importance: "Core", cloId: "CSE207-CLO2"),
        Topic(id: "DS-3", name: "Stacks, Queues & Deques with Applications", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO2"),
        Topic(id: "DS-4", name: "Recursion & Backtracking Techniques", weeks: 2.0, importance: "Critical", cloId: "CSE207-CLO3"),
        Topic(id: "DS-5", name: "Trees & Binary Search Trees (BST, AVL)", weeks: 2.5, importance: "Critical", cloId: "CSE207-CLO3"),
        Topic(id: "DS-6", name: "Graph Algorithms (BFS, DFS, Dijkstra, MST)", weeks: 3.5, importance: "Critical", cloId: "CSE207-CLO3", downstreamTopicPrereqs: ["ALG-3", "AI-2", "ML-6"]),
        Topic(id: "DS-7", name: "Foundations of Dynamic Programming", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO3"),
        Topic(id: "DS-8", name: "Hashing & Collision Resolution", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO4"),
      ],
    ),
    Course(
      id: "CSE-301",
      code: "CSE 301",
      name: "Algorithms",
      semester: 4,
      credit: 3.0,
      type: "Core",
      description: "Advanced algorithms design: divide-and-conquer, greedy heuristics, advanced graph network flows, dynamic programming, and intractability.",
      prerequisites: ["CSE-207"],
      theoryPercentage: 60,
      practicalPercentage: 40,
      clos: [
        CLO(id: "CSE301-CLO1", description: "Formulate optimal algorithmic strategies for complex combinatorial and network flow challenges.", bloomLevel: "Create", importance: 35),
        CLO(id: "CSE301-CLO2", description: "Implement and benchmark advanced graph traversal, max-flow, and shortest-path algorithms.", bloomLevel: "Apply", importance: 35),
        CLO(id: "CSE301-CLO3", description: "Prove algorithmic correctness and analyze complexity bounds for polynomial vs NP-complete problems.", bloomLevel: "Evaluate", importance: 30),
      ],
      topics: [
        Topic(id: "ALG-1", name: "Recurrence Relations & Master Theorem", weeks: 1.5, importance: "Core", cloId: "CSE301-CLO3"),
        Topic(id: "ALG-2", name: "Advanced Divide & Conquer Paradigm", weeks: 2.0, importance: "Core", cloId: "CSE301-CLO1"),
        Topic(id: "ALG-3", name: "Advanced Graph Algorithms (Bellman-Ford, Floyd-Warshall, Max-Flow)", weeks: 3.5, importance: "Critical", cloId: "CSE301-CLO2", requiresTopic: "DS-6"),
        Topic(id: "ALG-4", name: "Multi-stage Dynamic Programming", weeks: 3.0, importance: "Critical", cloId: "CSE301-CLO1"),
        Topic(id: "ALG-5", name: "Greedy Algorithms (Huffman, Task Scheduling)", weeks: 2.0, importance: "Core", cloId: "CSE301-CLO1"),
        Topic(id: "ALG-6", name: "NP-Completeness, Reductions & Approximation", weeks: 2.0, importance: "Advanced", cloId: "CSE301-CLO3"),
      ],
    ),
    Course(
      id: "CSE-305",
      code: "CSE 305",
      name: "Database Systems",
      semester: 4,
      credit: 3.0,
      type: "Core",
      description: "Relational database design, relational algebra, SQL optimization, physical storage, B+ Tree indexing, and transactions.",
      prerequisites: ["CSE-207"],
      theoryPercentage: 60,
      practicalPercentage: 40,
      clos: [
        CLO(id: "CSE305-CLO1", description: "Design normalized relational schemas satisfying BCNF constraints.", bloomLevel: "Create", importance: 30),
        CLO(id: "CSE305-CLO2", description: "Formulate complex SQL queries and analyze execution plans for indexing optimizations.", bloomLevel: "Analyze", importance: 40),
        CLO(id: "CSE305-CLO3", description: "Evaluate ACID compliance and concurrency serialization mechanisms.", bloomLevel: "Evaluate", importance: 30),
      ],
      topics: [
        Topic(id: "DB-1", name: "Relational Data Model & Relational Algebra", weeks: 2.0, importance: "Core", cloId: "CSE305-CLO1"),
        Topic(id: "DB-2", name: "Physical File Storage & B+ Tree Indexing", weeks: 3.0, importance: "Critical", cloId: "CSE305-CLO2"),
        Topic(id: "DB-3", name: "SQL Query Formulation & Cost Optimization", weeks: 3.5, importance: "Core", cloId: "CSE305-CLO2"),
        Topic(id: "DB-4", name: "Transaction Management & Concurrency", weeks: 3.0, importance: "Critical", cloId: "CSE305-CLO3"),
      ],
    ),
    Course(
      id: "CSE-307",
      code: "CSE 307",
      name: "Operating Systems",
      semester: 5,
      credit: 3.0,
      type: "Core",
      description: "Kernel architecture, multiprocessing, process synchronization, CPU scheduling, memory management, and file systems.",
      prerequisites: ["CSE-207", "CSE-101"],
      theoryPercentage: 70,
      practicalPercentage: 30,
      clos: [
        CLO(id: "CSE307-CLO1", description: "Analyze process lifecycle, thread synchronization, and race conditions using semaphores.", bloomLevel: "Analyze", importance: 35),
        CLO(id: "CSE307-CLO2", description: "Design CPU scheduling and deadlock handling routines using resource allocation graph models.", bloomLevel: "Create", importance: 35),
        CLO(id: "CSE307-CLO3", description: "Evaluate paging and virtual memory replacement algorithms under heavy workloads.", bloomLevel: "Evaluate", importance: 30),
      ],
      topics: [
        Topic(id: "OS-1", name: "OS Architectures & System Calls", weeks: 2.0, importance: "Core", cloId: "CSE307-CLO1"),
        Topic(id: "OS-2", name: "Process Synchronization & Mutexes", weeks: 3.0, importance: "Critical", cloId: "CSE307-CLO1"),
        Topic(id: "OS-3", name: "Deadlock Detection & Resource Allocation Graphs", weeks: 2.5, importance: "Critical", cloId: "CSE307-CLO2"),
        Topic(id: "OS-4", name: "CPU Scheduling Algorithms", weeks: 2.5, importance: "Core", cloId: "CSE307-CLO2"),
        Topic(id: "OS-5", name: "Virtual Memory & Demand Paging", weeks: 3.0, importance: "Core", cloId: "CSE307-CLO3"),
      ],
    ),
    Course(
      id: "CSE-401",
      code: "CSE 401",
      name: "Artificial Intelligence",
      semester: 6,
      credit: 3.0,
      type: "Core",
      description: "Heuristic state-space search, adversarial game trees, knowledge representation, Bayesian reasoning, and agent architectures.",
      prerequisites: ["CSE-301"],
      theoryPercentage: 65,
      practicalPercentage: 35,
      clos: [
        CLO(id: "CSE401-CLO1", description: "Design heuristic state-space graph search agents (A*, IDA*, Greedy Best-First).", bloomLevel: "Create", importance: 35),
        CLO(id: "CSE401-CLO2", description: "Implement minimax search with alpha-beta pruning in competitive game-playing systems.", bloomLevel: "Apply", importance: 35),
        CLO(id: "CSE401-CLO3", description: "Formulate probabilistic inference models using Directed Acyclic Belief Networks.", bloomLevel: "Evaluate", importance: 30),
      ],
      topics: [
        Topic(id: "AI-1", name: "Intelligent Agent Models", weeks: 1.5, importance: "Core", cloId: "CSE401-CLO1"),
        Topic(id: "AI-2", name: "Heuristic State-Space Search (A*, IDA*)", weeks: 3.5, importance: "Critical", cloId: "CSE401-CLO1", requiresTopic: "ALG-3"),
        Topic(id: "AI-3", name: "Adversarial Search & Game Trees (Minimax, Alpha-Beta)", weeks: 2.5, importance: "Critical", cloId: "CSE401-CLO2"),
        Topic(id: "AI-4", name: "Propositional & First-Order Logic", weeks: 2.5, importance: "Core", cloId: "CSE401-CLO2"),
        Topic(id: "AI-5", name: "Bayesian Reasoning & Belief Networks", weeks: 2.5, importance: "Core", cloId: "CSE401-CLO3"),
      ],
    ),
    Course(
      id: "CSE-405",
      code: "CSE 405",
      name: "Machine Learning",
      semester: 7,
      credit: 3.0,
      type: "Core Specialization",
      description: "Statistical learning paradigms, parametric and non-parametric algorithms, loss functions, gradient descent, deep neural networks, and graph embeddings.",
      prerequisites: ["CSE-401", "CSE-301"],
      theoryPercentage: 60,
      practicalPercentage: 40,
      clos: [
        CLO(id: "CSE405-CLO1", description: "Implement and tune supervised and unsupervised statistical learning algorithms.", bloomLevel: "Apply", importance: 35),
        CLO(id: "CSE405-CLO2", description: "Design multi-layer neural network architectures and optimize backpropagation losses.", bloomLevel: "Create", importance: 35),
        CLO(id: "CSE405-CLO3", description: "Critique model evaluation metrics, generalization boundaries, and algorithmic bias.", bloomLevel: "Evaluate", importance: 30),
      ],
      topics: [
        Topic(id: "ML-1", name: "Supervised Learning: Linear & Logistic Regression", weeks: 2.5, importance: "Core", cloId: "CSE405-CLO1"),
        Topic(id: "ML-2", name: "Decision Trees & Random Forests", weeks: 2.5, importance: "Core", cloId: "CSE405-CLO1"),
        Topic(id: "ML-3", name: "Artificial Neural Networks & Backpropagation", weeks: 3.0, importance: "Critical", cloId: "CSE405-CLO2"),
        Topic(id: "ML-4", name: "Unsupervised Clustering & Graph Clustering", weeks: 2.0, importance: "Core", cloId: "CSE405-CLO1"),
        Topic(id: "ML-5", name: "Model Evaluation & Cross-Validation", weeks: 1.5, importance: "Core", cloId: "CSE405-CLO3"),
        Topic(id: "ML-6", name: "Graph Neural Networks & Node Embeddings", weeks: 2.5, importance: "Advanced", cloId: "CSE405-CLO2", requiresTopic: "ALG-3"),
      ],
    ),
  ];

  static List<SimulationResult> history = [
    _createInitialSimulation(
      courseId: "CSE-207",
      action: "REMOVE_TOPIC",
      topicId: "DS-6",
      facultyReason: "Curriculum review: Testing offloading graphs to save 3.5 weeks.",
    )
  ];

  static Course getCourse(String id) {
    return courses.firstWhere((c) => c.id == id, orElse: () => courses[1]);
  }

  static SimulationResult runSimulation({
    required String courseId,
    required String action,
    String? topicId,
    String? newTopicName,
    double? newTopicWeeks,
    int? practicalMarks,
    String? facultyReason,
  }) {
    final course = getCourse(courseId);
    Topic? targetTopic;
    if (topicId != null) {
      try {
        targetTopic = course.topics.firstWhere((t) => t.id == topicId);
      } catch (_) {
        targetTopic = course.topics.first;
      }
    } else if (course.topics.isNotEmpty) {
      targetTopic = course.topics.first;
    }

    SimulationResult result;

    if (action == "REMOVE_TOPIC") {
      result = _simulateRemoveTopic(course, targetTopic!, facultyReason ?? "");
    } else if (action == "CHANGE_ASSESSMENT") {
      result = _simulateAssessmentChange(course, practicalMarks ?? 25, facultyReason ?? "");
    } else {
      // ADD_TOPIC or default
      result = _simulateAddTopic(course, newTopicName ?? "Python Programming for Scientific Computing", newTopicWeeks ?? 2.0, facultyReason ?? "");
    }

    history.insert(0, result);
    return result;
  }

  static SimulationResult _createInitialSimulation({
    required String courseId,
    required String action,
    required String topicId,
    required String facultyReason,
  }) {
    final course = getCourse(courseId);
    final topic = course.topics.firstWhere((t) => t.id == topicId);
    return _simulateRemoveTopic(course, topic, facultyReason);
  }

  static SimulationResult _simulateRemoveTopic(Course course, Topic topic, String reason) {
    // 1. Downstream Impact
    final downstreamCourses = [
      DownstreamImpactItem(
        courseId: "CSE-301",
        courseCode: "CSE 301",
        courseName: "Algorithms",
        semester: 4,
        distance: 1,
        impactScore: 85,
        riskLevel: "HIGH",
        affectedTopics: ["Advanced Graph Algorithms (Bellman-Ford, Floyd-Warshall, Max-Flow)"],
        reason: "Direct child course: CSE 301 assumes students have already mastered fundamental BFS/DFS and adjacency lists.",
      ),
      DownstreamImpactItem(
        courseId: "CSE-401",
        courseCode: "CSE 401",
        courseName: "Artificial Intelligence",
        semester: 6,
        distance: 2,
        impactScore: 65,
        riskLevel: "MEDIUM",
        affectedTopics: ["Heuristic State-Space Search (A*, IDA*)"],
        reason: "Heuristic search algorithms model state spaces as directed graphs; lacks foundational traversal exposure.",
      ),
      DownstreamImpactItem(
        courseId: "CSE-405",
        courseCode: "CSE 405",
        courseName: "Machine Learning",
        semester: 7,
        distance: 3,
        impactScore: 35,
        riskLevel: "LOW",
        affectedTopics: ["Graph Neural Networks & Node Embeddings"],
        reason: "Advanced elective topics in GNNs rely on structural graph representations.",
      ),
    ];

    // 2. CLO Impact
    final cloImpact = course.clos.map((clo) {
      final isTarget = clo.id == topic.cloId;
      final before = 85;
      final after = isTarget ? 62 : 82;
      return CloImpactItem(
        cloId: clo.id,
        description: clo.description,
        bloomLevel: clo.bloomLevel,
        beforeCoverage: isTarget ? before : 82,
        afterCoverage: after,
        delta: after - (isTarget ? before : 82),
        severity: isTarget ? "HIGH" : "LOW",
        explanation: isTarget
          ? "Coverage for ${clo.id} drops by 23% (85% ➔ 62%) due to removal of dedicated instruction on '${topic.name}'."
          : "Unaffected by this topic modification.",
      );
    }).toList();

    // 3. Ripple Effect Nodes
    final ripple = [
      RippleNode(
        nodeId: course.id,
        name: "${course.code}: ${course.name}",
        level: "SOURCE_CHANGE",
        color: "crimson",
        impactScore: 78,
        badge: "Proposed Deletion",
        role: "Origin Course",
        details: "Topic '${topic.name}' deleted (3.5 weeks lost)",
      ),
      RippleNode(
        nodeId: "CSE-301",
        name: "CSE 301: Algorithms",
        level: "HIGH",
        color: "crimson",
        impactScore: 85,
        badge: "High Impact (Distance: 1)",
        role: "Direct Child Prerequisite",
        details: "Advanced graph network flows lose foundational BFS/DFS prerequisites.",
      ),
      RippleNode(
        nodeId: "CSE-401",
        name: "CSE 401: Artificial Intelligence",
        level: "MEDIUM",
        color: "amber",
        impactScore: 65,
        badge: "Medium Impact (Distance: 2)",
        role: "Transitive Dependent",
        details: "Heuristic search algorithms (A*, IDA*) impacted.",
      ),
      RippleNode(
        nodeId: "CSE-405",
        name: "CSE 405: Machine Learning",
        level: "LOW",
        color: "emerald",
        impactScore: 35,
        badge: "Low Impact (Distance: 3)",
        role: "Transitive Dependent",
        details: "Graph neural network representations impacted.",
      ),
    ];

    // 4. Evidence Items ("Why?")
    final evidence = [
      EvidenceItem(
        id: "ev-prereq",
        dimension: "Prerequisite Risk",
        evidenceType: "VERIFIED_STRUCTURAL_RELATION",
        title: "Downstream Prerequisite Disruption for 3 Courses",
        summary: "Removing '${topic.name}' breaks the structural prerequisite sequence articulated in the OBE curriculum map.",
        graphChain: [
          "CSE 207: Graph Algorithms",
          "CSE 301: Advanced Graph Algorithms",
          "CSE 401: State-Space Search",
          "CSE 405: Graph Neural Networks",
        ],
        paths: [
          EvidencePath(
            fromCourse: "CSE 207 (Data Structures)",
            fromTopic: topic.name,
            relation: "IS_FOUNDATIONAL_PREREQUISITE_FOR",
            toCourse: "CSE 301 (Algorithms)",
            toTopic: "Shortest Paths & Network Flow",
            academicReason: "CSE 301 syllabus assumes prior mastery of basic graph representations and queue-based BFS.",
          ),
          EvidencePath(
            fromCourse: "CSE 301 (Algorithms)",
            fromTopic: "Graph Algorithms",
            relation: "REQUIRED_BY_ADVANCED_AI",
            toCourse: "CSE 401 (Artificial Intelligence)",
            toTopic: "State-Space Search (A*, IDA*)",
            academicReason: "Heuristic pathfinding is framed as search over directed graph vertices and edge costs.",
          ),
        ],
        academicStandardReference: "ABET Criterion 3: Curriculum Structure & IEEE/ACM CS2023 Knowledge Area: AL/Fundamental Data Structures.",
      ),
    ];

    // 5. Alternatives (Plan A, B, C)
    final alternatives = [
      AlternativePlan(
        id: "plan-a",
        name: "Plan A: Full Deletion",
        tag: "Proposed Action",
        description: "Permanently delete '${topic.name}' from ${course.code}.",
        overallImpact: 78,
        riskLevel: "HIGH",
        cloImpact: "High (Severe 23% drop)",
        prerequisiteRisk: "High (3 downstream courses affected)",
        downstreamRisk: "High (Algorithms & AI disrupted)",
        curriculumGap: "High (Critical traversal untaught)",
        assessmentRisk: "Medium (Theory/Practical skew)",
        studentReadiness: "High (Cohort enters Algorithms under-prepared)",
        pros: ["Frees up 3.5 weeks in CSE 207 for remaining linear structures."],
        cons: ["Severe downstream disruption across 3 subsequent semesters.", "Breaks CLO-3 accreditation alignment."],
        recommendationRationale: "Not recommended due to severe ripple disruption across the entire degree program.",
      ),
      AlternativePlan(
        id: "plan-b",
        name: "Plan B: Scope Reduction",
        tag: "Balanced Compromise",
        description: "Retain essential subset (BFS, DFS, Adjacency List) in 1.5 weeks; omit advanced MST and Bellman-Ford.",
        overallImpact: 42,
        riskLevel: "MEDIUM",
        cloImpact: "Medium (Essential concepts preserved)",
        prerequisiteRisk: "Medium (Basic traversal maintained)",
        downstreamRisk: "Medium (Algorithms can build on basic BFS)",
        curriculumGap: "Low (Core foundations intact)",
        assessmentRisk: "Low (Minor re-weighting)",
        studentReadiness: "Medium (Students know basic representations)",
        pros: ["Frees 2.0 weeks of syllabus contact time.", "Preserves prerequisite readiness for CSE 301."],
        cons: ["Leaves less time for hands-on graph programming projects."],
        recommendationRationale: "Feasible compromise that relieves syllabus congestion while retaining necessary entry competencies.",
      ),
      AlternativePlan(
        id: "plan-c",
        name: "Plan C: Relocate to Algorithms",
        tag: "Lowest Modeled Impact",
        isSafest: true,
        description: "Transfer in-depth Graph Algorithms to CSE 301 (Algorithms), keeping only 1 week conceptual overview in CSE 207.",
        overallImpact: 26,
        riskLevel: "LOW",
        cloImpact: "Low (Reallocated to CSE 301)",
        prerequisiteRisk: "Low (Taught at immediate point of need in Algorithms)",
        downstreamRisk: "Low (Algorithms absorbs and structures the topic)",
        curriculumGap: "Low (Zero net loss in degree curriculum)",
        assessmentRisk: "Low (Harmonized credits)",
        studentReadiness: "Low (Continuous reinforcement)",
        pros: ["Zero total knowledge loss in the degree program.", "Eliminates conceptual redundancy between courses."],
        cons: ["Requires joint syllabus approval between both course instructors."],
        recommendationRationale: "Lowest modeled structural risk (26/100). Preserves student mastery with zero downstream breakage.",
      ),
    ];

    return SimulationResult(
      simulationId: "SIM-${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}",
      timestamp: DateTime.now(),
      university: university,
      course: course,
      action: "REMOVE_TOPIC",
      targetTopic: topic,
      facultyReason: reason.isNotEmpty ? reason : "Routine curriculum review and syllabus optimization.",
      confidence: 98,
      overallScore: 78,
      riskLevel: "HIGH",
      riskLabel: "High Risk / Critical Curriculum Disruption",
      cloImpact: cloImpact,
      prereqScore: 85,
      prereqRiskLevel: "HIGH",
      prereqSummary: "Foundational knowledge gap: 3 downstream courses depend on '${topic.name}'.",
      brokenTopics: [
        "CSE 301: Advanced Graph Algorithms (Bellman-Ford, Floyd-Warshall)",
        "CSE 401: Heuristic State-Space Search (A*, IDA*)",
        "CSE 405: Graph Neural Networks & Node Embeddings",
      ],
      downstreamImpact: downstreamCourses,
      currentTheory: 65,
      currentPractical: 35,
      predictedTheory: 75,
      predictedPractical: 25,
      assessmentExplanation: "Removing practical graph implementations skews grading by 10% toward written theory exams.",
      curriculumGaps: [
        CurriculumGapItem(
          severity: "CRITICAL",
          concept: "Graph Representations & Traversal Fundamentals",
          description: "Students will graduate without structured coursework in BFS, DFS, and adjacency matrix/list algorithms.",
          suggestedRemedy: "Transfer foundational graph algorithms to CSE 301 (Algorithms) before pruning from CSE 207.",
        ),
      ],
      readinessScore: 75,
      readinessRiskLevel: "HIGH",
      readinessFriction: "High entry friction in CSE 301 (Algorithms). Faculty will face 25-35% initial assignment failure rates.",
      rippleEffect: ripple,
      evidenceItems: evidence,
      alternatives: alternatives,
      executiveHeadline: "High-Risk Modification: Removing '${topic.name}' triggers cascade across 3 subsequent courses.",
      executiveOverall: "The proposed deletion of '${topic.name}' from ${course.code} carries an overall modeled impact score of 78/100 (HIGH RISK). While it relieves 3.5 weeks of syllabus density, it destabilizes prerequisite readiness for CSE 301 (Algorithms) and CSE 401 (Artificial Intelligence).",
      executiveRisks: [
        "CLO Coverage Reduction: CLO-3 drops by 23% (85% ➔ 62%).",
        "Prerequisite Invalidation: 3 downstream courses lose foundational graph representations.",
        "Downstream Cascade: Direct child course CSE 301 (Algorithms) suffers instructional disruption.",
        "Critical Knowledge Gap: Standard OBE competencies in search spaces omitted.",
      ],
      recommendedAction: "Adopt Plan C (Relocate topic to CSE 301 Algorithms) or Plan B (Retain 1.5-week core subset).",
    );
  }

  static SimulationResult _simulateAssessmentChange(Course course, int practicalMarks, String reason) {
    final newTheory = 100 - practicalMarks;
    return SimulationResult(
      simulationId: "SIM-${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}",
      timestamp: DateTime.now(),
      university: university,
      course: course,
      action: "CHANGE_ASSESSMENT",
      targetTopic: null,
      facultyReason: reason.isNotEmpty ? reason : "Industry recruiters emphasize hands-on model training.",
      confidence: 92,
      overallScore: 42,
      riskLevel: "MEDIUM",
      riskLabel: "Medium Risk / Balanced Re-weighting",
      cloImpact: course.clos.map((clo) {
        return CloImpactItem(
          cloId: clo.id,
          description: clo.description,
          bloomLevel: clo.bloomLevel,
          beforeCoverage: 80,
          afterCoverage: clo.bloomLevel == "Apply" ? 90 : 75,
          delta: clo.bloomLevel == "Apply" ? 10 : -5,
          severity: "LOW",
          explanation: clo.bloomLevel == "Apply"
            ? "Practical mark increase directly strengthens attainment evidence for implementation-oriented CLOs."
            : "Slight reduction in written theoretical evaluation weight.",
        );
      }).toList(),
      prereqScore: 10,
      prereqRiskLevel: "LOW",
      prereqSummary: "Assessment mark redistribution does not alter topic dependencies.",
      brokenTopics: [],
      downstreamImpact: [],
      currentTheory: course.theoryPercentage,
      currentPractical: course.practicalPercentage,
      predictedTheory: newTheory,
      predictedPractical: practicalMarks,
      assessmentExplanation: "Significant shift in grading: Practical component expands to $practicalMarks%. Requires lab capacity review.",
      curriculumGaps: [],
      readinessScore: 25,
      readinessRiskLevel: "LOW",
      readinessFriction: "Students need transparent grading rubrics for expanded practical testing.",
      rippleEffect: [
        RippleNode(
          nodeId: course.id,
          name: "${course.code}: ${course.name}",
          level: "SOURCE_CHANGE",
          color: "amber",
          impactScore: 42,
          badge: "Assessment Mark Shift",
          role: "Origin Course",
          details: "Practical marks shifted to $practicalMarks%",
        ),
      ],
      evidenceItems: [],
      alternatives: [
        AlternativePlan(
          id: "plan-a",
          name: "Plan A: Direct Shift to $practicalMarks%",
          tag: "Proposed Action",
          description: "Immediately shift practical marks from ${course.practicalPercentage}% to $practicalMarks%.",
          overallImpact: 42,
          riskLevel: "MEDIUM",
          cloImpact: "Low (CLO alignment preserved)",
          prerequisiteRisk: "Low (Zero content modified)",
          downstreamRisk: "Low (No topics pruned)",
          curriculumGap: "Low (Zero gaps)",
          assessmentRisk: "Medium (Lab grading load increases)",
          studentReadiness: "Low (Positive coding skill boost)",
          pros: ["Improves hands-on implementation capabilities."],
          cons: ["Increases lab equipment and TA grading burden."],
          recommendationRationale: "Constructive modification with moderate operational lab overhead.",
        ),
        AlternativePlan(
          id: "plan-b",
          name: "Plan B: Phased Rollout (18%)",
          tag: "Recommended Feasibility",
          isSafest: true,
          description: "Moderate practical increase to 18% with peer-reviewed assignments.",
          overallImpact: 22,
          riskLevel: "LOW",
          cloImpact: "Low",
          prerequisiteRisk: "Low",
          downstreamRisk: "Low",
          curriculumGap: "Low",
          assessmentRisk: "Low",
          studentReadiness: "Positive",
          pros: ["Boosts hands-on learning without overburdening TAs."],
          cons: ["Smaller practical boost than Plan A."],
          recommendationRationale: "Lowest operational friction while still improving practical learning outcomes.",
        ),
      ],
      executiveHeadline: "Moderate Assessment Rebalancing: Practical marks expanded to $practicalMarks%.",
      executiveOverall: "The shift to $practicalMarks% practical evaluation carries an impact score of 42/100 (MEDIUM RISK). While it promotes hands-on problem solving, it increases grading overhead on departmental laboratory infrastructure.",
      executiveRisks: [
        "Laboratory equipment and TA grading hours may need augmentation.",
        "Written final exam paper will have compressed coverage of theoretical proofs.",
      ],
      recommendedAction: "Adopt Plan B (Phased rollout to 18% with automated autograders) before full expansion to $practicalMarks%.",
    );
  }

  static SimulationResult _simulateAddTopic(Course course, String newTopicTitle, double weeks, String reason) {
    return SimulationResult(
      simulationId: "SIM-${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}",
      timestamp: DateTime.now(),
      university: university,
      course: course,
      action: "ADD_TOPIC",
      targetTopic: Topic(id: "NEW", name: newTopicTitle, weeks: weeks, importance: "Core", cloId: course.clos.first.id),
      facultyReason: reason.isNotEmpty ? reason : "Modernize AI tooling with NumPy, PyTorch, and search scripts.",
      confidence: 96,
      overallScore: 22,
      riskLevel: "LOW",
      riskLabel: "Low Risk / Positive Enrichment",
      cloImpact: course.clos.map((clo) {
        return CloImpactItem(
          cloId: clo.id,
          description: clo.description,
          bloomLevel: clo.bloomLevel,
          beforeCoverage: 80,
          afterCoverage: clo.id == course.clos.first.id ? 92 : 80,
          delta: clo.id == course.clos.first.id ? 12 : 0,
          severity: "LOW",
          explanation: clo.id == course.clos.first.id
            ? "Positive enrichment: Adding '$newTopicTitle' expands hands-on coverage for ${clo.id} by +12%."
            : "Maintains existing curriculum alignment.",
        );
      }).toList(),
      prereqScore: 15,
      prereqRiskLevel: "LOW",
      prereqSummary: "Addition does not invalidate any existing prerequisite chains.",
      brokenTopics: [],
      downstreamImpact: [
        DownstreamImpactItem(
          courseId: "CSE-405",
          courseCode: "CSE 405",
          courseName: "Machine Learning",
          semester: 7,
          distance: 1,
          impactScore: 20,
          riskLevel: "LOW",
          affectedTopics: ["Neural Networks", "Model Training"],
          reason: "Beneficial impact: Students learn necessary toolkits earlier, saving lab setup time in CSE 405.",
        ),
      ],
      currentTheory: course.theoryPercentage,
      currentPractical: course.practicalPercentage,
      predictedTheory: course.theoryPercentage - 5,
      predictedPractical: course.practicalPercentage + 5,
      assessmentExplanation: "Slightly elevates practical programming weight (+5%), which is pedagogically healthy.",
      curriculumGaps: [],
      readinessScore: 20,
      readinessRiskLevel: "LOW",
      readinessFriction: "Minimal friction. Enhances student confidence and industry alignment.",
      rippleEffect: [
        RippleNode(
          nodeId: course.id,
          name: "${course.code}: ${course.name}",
          level: "SOURCE_CHANGE",
          color: "emerald",
          impactScore: 22,
          badge: "Proposed Addition",
          role: "Enriched Course",
          details: "New topic '$newTopicTitle' (+$weeks weeks)",
        ),
        RippleNode(
          nodeId: "CSE-405",
          name: "CSE 405: Machine Learning",
          level: "LOW",
          color: "emerald",
          impactScore: 18,
          badge: "Positive Readiness",
          role: "Beneficiary Course",
          details: "Students enter Machine Learning proficient in $newTopicTitle.",
        ),
      ],
      evidenceItems: [],
      alternatives: [
        AlternativePlan(
          id: "plan-a",
          name: "Plan A: Full Integration",
          tag: "Proposed Action",
          description: "Integrate '$newTopicTitle' for $weeks weeks in ${course.code}.",
          overallImpact: 22,
          riskLevel: "LOW",
          isSafest: true,
          cloImpact: "Positive Enrichment",
          prerequisiteRisk: "Low",
          downstreamRisk: "Low",
          curriculumGap: "Low",
          assessmentRisk: "Low",
          studentReadiness: "Positive",
          pros: ["Modernizes curriculum with in-demand script toolkits."],
          cons: ["May cause minor syllabus cramming if no other topic is trimmed."],
          recommendationRationale: "Constructive modification with low structural risk.",
        ),
      ],
      executiveHeadline: "Constructive Curriculum Update: Adding '$newTopicTitle' provides positive reinforcement.",
      executiveOverall: "The addition of '$newTopicTitle' to ${course.code} carries a low impact score of 22/100 (LOW RISK). It modernizes student skillsets and positively enriches downstream Machine Learning readiness.",
      executiveRisks: [
        "Potential syllabus congestion (+$weeks weeks). Prune minor obsolete sub-topics.",
        "Requires TA preparation for lab environment support.",
      ],
      recommendedAction: "Approve the addition. Couple with 1.0 week reduction of legacy theoretical topics to preserve credit hours.",
    );
  }
}
