import 'package:flutter/material.dart';
import 'services/course_content_ai_assistant.dart';
import 'widgets/content_conflict_assistant_modal.dart';

void main() {
  runApp(const AcaddieApp());
}

class AcaddieApp extends StatelessWidget {
  const AcaddieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACADDIE 1.0 — Academic Decision Co-Pilot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF2563EB),
          surface: Colors.white,
        ),
      ),
      home: const AcaddiePrototype(),
    );
  }
}

class AcaddiePrototype extends StatefulWidget {
  const AcaddiePrototype({super.key});

  @override
  State<AcaddiePrototype> createState() => _AcaddiePrototypeState();
}

class _AcaddiePrototypeState extends State<AcaddiePrototype> {
  // Main 5-view router state:
  // 'dashboard', 'change-select', 'change-manage', 'add-step1', 'add-step2'
  String currentView = 'dashboard';

  bool isGenerating = false;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String selectedFilter = 'All';

  // Selected course index in change-manage view
  int selectedCourseIndex = 4; // Defaults to CSE2103 Data Structures

  // Multi-AI Failover Management
  final List<String> aiProviders = [
    'Gemini 1.5 Pro (Primary)',
    'Gemini 1.5 Flash (Fast Fallback)',
    'Claude 3.5 Sonnet (Secondary)',
    'Offline Deterministic Engine (Guaranteed)',
  ];
  int currentAiProviderIndex = 0;

  // Interactive Gemini Chat History
  final List<Map<String, String>> chatMessages = [
    {
      'sender': 'ai',
      'text': 'Hello Professor Shilpo! I am your ACADDIE Curriculum Co-Pilot powered by Gemini. Ask me anything about your 22 departmental courses, ABET accreditation, prerequisite ripple effects, or syllabus optimization.',
    },
  ];
  final TextEditingController chatInputCtrl = TextEditingController();
  bool isAiThinking = false;

  // Authentic 22 Courses Departmental Syllabus Dataset
  final List<Map<String, dynamic>> syllabusCourses = [
    {
      'code': 'CSE1101',
      'title': 'Elementary Structured Programming',
      'year': 'Year 1',
      'semester': 'Semester 1 (1.1)',
      'credits': '3.0 Cr',
      'summary': 'Basic programming concepts, variables, control structures, and structured data processing.',
      'color': Color(0xFF0284C7),
      'topics': [
        {'name': 'Basic Programming Concepts & Syntax', 'weeks': '2.0w', 'blooms': 'K2 Understand'},
        {'name': 'Variables, Data Types & Formatted I/O', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Control Structures & Conditional Branching', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Iterative Loops & Nested Iterations', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Functions, Scope & Recursion', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Structured Data Processing & Pointers', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE1108',
      'title': 'Introduction to Computer Systems',
      'year': 'Year 1',
      'semester': 'Semester 1 (1.1)',
      'credits': '3.0 Cr',
      'summary': 'Principles of digital computation, hardware peripherals, memory systems, and basic operating systems.',
      'color': Color(0xFF0284C7),
      'topics': [
        {'name': 'Principles of Digital Computation & Binary Arithmetic', 'weeks': '3.0w', 'blooms': 'K2 Understand'},
        {'name': 'Hardware Peripherals & System Bus Architecture', 'weeks': '3.0w', 'blooms': 'K2 Understand'},
        {'name': 'Memory Systems Hierarchy (Cache, RAM, ROM)', 'weeks': '3.5w', 'blooms': 'K3 Apply'},
        {'name': 'Basic Operating System Interfaces & BIOS', 'weeks': '3.5w', 'blooms': 'K3 Apply'},
      ],
    },
    {
      'code': 'CSE1203',
      'title': 'Discrete Mathematics',
      'year': 'Year 1',
      'semester': 'Semester 2 (1.2)',
      'credits': '3.0 Cr',
      'summary': 'Set theory, mathematical logic, counting, graph theory, and introduction to finite automata.',
      'color': Color(0xFF0284C7),
      'topics': [
        {'name': 'Set Theory, Relations & Functions', 'weeks': '2.5w', 'blooms': 'K2 Understand'},
        {'name': 'Propositional & Predicate Mathematical Logic', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Combinatorics, Permutations & Counting Principles', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Graph Theory Foundations & Trees', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Introduction to Finite Automata & State Machines', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE1205',
      'title': 'Object Oriented Programming',
      'year': 'Year 1',
      'semester': 'Semester 2 (1.2)',
      'credits': '3.0 Cr',
      'summary': 'OOP concepts, classes, objects, inheritance, overloading, and polymorphism.',
      'color': Color(0xFF0284C7),
      'topics': [
        {'name': 'OOP Paradigms, Abstraction & Encapsulation', 'weeks': '2.5w', 'blooms': 'K2 Understand'},
        {'name': 'Classes, Objects, Constructors & Destructors', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Single & Multi-level Inheritance Hierarchies', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Method Overloading & Operator Overloading', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Polymorphism, Virtual Functions & Interfaces', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE2103',
      'title': 'Data Structures',
      'year': 'Year 2',
      'semester': 'Semester 3 (2.1)',
      'credits': '3.0 Cr',
      'summary': 'Basic notation, arrays, lists, stacks, queues, trees, sorting, and searching.',
      'color': Color(0xFF2563EB),
      'topics': [
        {'name': 'Asymptotic Notations & Space-Time Analysis', 'weeks': '2.0w', 'blooms': 'K3 Apply'},
        {'name': 'Dynamic Arrays & Singly/Doubly Linked Lists', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Stacks, Queues & Evaluation of Expressions', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Binary Trees, BSTs & AVL Balanced Trees', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Searching & Sorting Algorithms (Quick, Merge, Heap)', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Graph Representation & Traversals (BFS / DFS)', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE2105',
      'title': 'Digital Logic Design',
      'year': 'Year 2',
      'semester': 'Semester 3 (2.1)',
      'credits': '3.0 Cr',
      'summary': 'Boolean algebra, logic gates, combinational logic, and synchronous sequential logic circuits.',
      'color': Color(0xFF2563EB),
      'topics': [
        {'name': 'Boolean Algebra & Karnaugh Map Simplification', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Logic Gates, De Morgan Laws & Universal Gates', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Combinational Circuits: Adders, Multiplexers & Decoders', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Synchronous Sequential Circuits: Flip-Flops & Registers', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE2201',
      'title': 'Numerical Methods',
      'year': 'Year 2',
      'semester': 'Semester 4 (2.2)',
      'credits': '3.0 Cr',
      'summary': 'Iterative methods, interpolation, numerical integration, and solving linear and differential equations.',
      'color': Color(0xFF2563EB),
      'topics': [
        {'name': 'Iterative Root Finding (Newton-Raphson, Bisection)', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Interpolation Polynomials (Lagrange, Newton Divided)', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Numerical Integration (Trapezoidal & Simpson Rules)', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Numerical Solutions for Systems of Linear Equations', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Numerical Ordinary Differential Equations (Euler, RK4)', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE2207',
      'title': 'Algorithms',
      'year': 'Year 2',
      'semester': 'Semester 4 (2.2)',
      'credits': '3.0 Cr',
      'summary': 'Algorithmic complexity, divide and conquer, dynamic programming, backtracking, and lower bound theory.',
      'color': Color(0xFF2563EB),
      'topics': [
        {'name': 'Algorithmic Complexity & Master Theorem', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Divide and Conquer Paradigms', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Dynamic Programming & Optimal Substructure', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Backtracking & Branch-and-Bound State Space Search', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Lower Bound Theory, P, NP & NP-Completeness', 'weeks': '2.5w', 'blooms': 'K5 Evaluate'},
      ],
    },
    {
      'code': 'CSE2211',
      'title': 'Data Communication',
      'year': 'Year 2',
      'semester': 'Semester 4 (2.2)',
      'credits': '3.0 Cr',
      'summary': 'Signal encoding, transmission channels, multiplexing, and basic switching techniques.',
      'color': Color(0xFF2563EB),
      'topics': [
        {'name': 'Signal Encoding, Modulation & Sampling Theorem', 'weeks': '3.5w', 'blooms': 'K3 Apply'},
        {'name': 'Transmission Channels & Physical Media Characteristics', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Multiplexing Techniques (FDM, TDM, WDM)', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Circuit Switching, Packet Switching & Network Topologies', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE2213',
      'title': 'Computer Architecture',
      'year': 'Year 2',
      'semester': 'Semester 4 (2.2)',
      'credits': '3.0 Cr',
      'summary': 'Basic computer structures, memory organization, control units, pipelining, and parallel processing.',
      'color': Color(0xFF2563EB),
      'topics': [
        {'name': 'Basic Computer Structures & Von Neumann Architecture', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Memory Organization, Interleaving & Cache Coherence', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Hardwired & Microprogrammed Control Unit Design', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Instruction Pipelining, Hazards & Branch Prediction', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'SIMD, Multi-core & Parallel Processing Models', 'weeks': '2.5w', 'blooms': 'K5 Evaluate'},
      ],
    },
    {
      'code': 'CSE2214',
      'title': 'Assembly Language Programming',
      'year': 'Year 2',
      'semester': 'Semester 4 (2.2)',
      'credits': '3.0 Cr',
      'summary': 'System architecture for assembly, instruction formats, procedures, and interfacing.',
      'color': Color(0xFF2563EB),
      'topics': [
        {'name': 'System Architecture for Assembly & Register Models', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Instruction Formats, Addressing Modes & Op-codes', 'weeks': '3.5w', 'blooms': 'K3 Apply'},
        {'name': 'Subroutines, Modular Procedures & Stack Frames', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Hardware Port Interfacing, BIOS/DOS Interrupts', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3101',
      'title': 'Mathematical Analysis for CS',
      'year': 'Year 3',
      'semester': 'Semester 5 (3.1)',
      'credits': '3.0 Cr',
      'summary': 'Recurrence relations, binomial coefficients, probability distributions, and stochastic processes.',
      'color': Color(0xFF4F46E5),
      'topics': [
        {'name': 'Homogeneous & Inhomogeneous Recurrence Relations', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Generating Functions & Binomial Coefficients', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Probability Distributions, Expectation & Variance', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Markov Chains & Stochastic Modeling in Computing', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3103',
      'title': 'Database',
      'year': 'Year 3',
      'semester': 'Semester 5 (3.1)',
      'credits': '3.0 Cr',
      'summary': 'Data models, SQL, relational algebra, query processing, and database management.',
      'color': Color(0xFF4F46E5),
      'topics': [
        {'name': 'ER & Relational Data Models and Constraint Rules', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Relational Algebra & Formal Query Languages', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Advanced SQL Queries, DDL, DML & Triggers', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Query Optimization & Cost-Based Execution Plans', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'ACID Properties, Concurrency Control & Recovery', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3109',
      'title': 'Digital System Design',
      'year': 'Year 3',
      'semester': 'Semester 5 (3.1)',
      'credits': '3.0 Cr',
      'summary': 'Logic families, timing circuits, PLA design, and hardwired/microprogrammed control units.',
      'color': Color(0xFF4F46E5),
      'topics': [
        {'name': 'Digital Logic Families (TTL, CMOS) & Noise Margins', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Clock Generation, Setup/Hold Timing & Multivibrators', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Programmable Logic Devices: PLA, PAL & FPGA Fabrics', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Microprogrammed Control Units & Hardware Synthesis', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3117',
      'title': 'Microprocessors & Microcontrollers',
      'year': 'Year 3',
      'semester': 'Semester 5 (3.1)',
      'credits': '3.0 Cr',
      'summary': 'Processor architecture, instruction sets, interrupts, and controlling I/O devices.',
      'color': Color(0xFF4F46E5),
      'topics': [
        {'name': 'Microprocessor Architecture & Internal Bus Control', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Instruction Set Architectures & Machine Cycle Timing', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Vectored Interrupt Handling & Exception Routines', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Programmable Peripheral Interfacing & Timers', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3201',
      'title': 'Intro to Computer Networks',
      'year': 'Year 3',
      'semester': 'Semester 6 (3.2)',
      'credits': '3.0 Cr',
      'summary': 'OSI/TCP IP reference models, data link, network, transport layer protocols, and routing.',
      'color': Color(0xFF0D9488),
      'topics': [
        {'name': 'OSI 7-Layer & TCP/IP Protocol Architectures', 'weeks': '2.5w', 'blooms': 'K2 Understand'},
        {'name': 'Data Link Layer: Framing, Flow Control & CSMA/CD', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Network Layer: IPv4/IPv6 Subnetting & IP Routing', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Routing Protocols (OSPF, BGP, Distance-Vector)', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Transport Layer: TCP Congestion Control & UDP', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3207',
      'title': 'Intro to Artificial Intelligence',
      'year': 'Year 3',
      'semester': 'Semester 6 (3.2)',
      'credits': '3.0 Cr',
      'summary': 'Knowledge representation, search strategies, perception, natural language processing, and machine learning.',
      'color': Color(0xFF0D9488),
      'topics': [
        {'name': 'Informed & Uninformed Search Strategies (A*, BFS, DFS)', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Knowledge Representation & First-Order Propositional Logic', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Perception, Computer Vision & Sensory Feature Models', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Natural Language Processing & Syntactic Parsing', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Foundations of Machine Learning & Decision Boundaries', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3213',
      'title': 'Operating System',
      'year': 'Year 3',
      'semester': 'Semester 6 (3.2)',
      'credits': '3.0 Cr',
      'summary': 'Process management, concurrency, virtual memory techniques, file systems, and deadlocks.',
      'color': Color(0xFF0D9488),
      'topics': [
        {'name': 'Process Lifecycle, Thread Pools & Context Switching', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'Concurrency, Semaphores & Critical Section Mutual Exclusion', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Deadlock Prevention, Detection & Recovery Protocols', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Virtual Memory Architecture, Paging & Segmentation', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'File Systems, Inodes, Directory Allocations & Disk I/O', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE3223',
      'title': 'Info System Design & Software Eng',
      'year': 'Year 3',
      'semester': 'Semester 6 (3.2)',
      'credits': '3.0 Cr',
      'summary': 'Systems analysis, cost-benefit analysis, software requirements, modeling, and testing.',
      'color': Color(0xFF0D9488),
      'topics': [
        {'name': 'Systems Analysis, Feasibility & Cost-Benefit Audits', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': 'Software Requirements Engineering & SRS Documentation', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': 'UML Structural & Behavioral System Modeling', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Software Testing Methodologies (Unit, Integration, CI/CD)', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE4113',
      'title': 'Pattern Recognition & Machine Learning',
      'year': 'Year 4',
      'semester': 'Semester 7 (4.1)',
      'credits': '3.0 Cr',
      'summary': 'Object similarity, Bayesian classifiers, neural networks, decision trees, and cluster analysis.',
      'color': Color(0xFF7C3AED),
      'topics': [
        {'name': 'Feature Vectors, Distance Metrics & Object Similarity', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Bayesian Classifiers & Maximum Likelihood Estimation', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Feedforward Neural Networks & Backpropagation Optimization', 'weeks': '3.5w', 'blooms': 'K5 Evaluate'},
        {'name': 'Decision Trees, Random Forests & Gradient Boosting', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Unsupervised Cluster Analysis (K-Means, DBSCAN, PCA)', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
      ],
    },
    {
      'code': 'CSE4129',
      'title': 'Formal Languages and Compilers',
      'year': 'Year 4',
      'semester': 'Semester 7 (4.1)',
      'credits': '3.0 Cr',
      'summary': 'Finite automata, Turing machines, compiler structure, parsing, and code generation.',
      'color': Color(0xFF7C3AED),
      'topics': [
        {'name': 'Regular Expressions, DFA, NFA & Myhill-Nerode Theorem', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Context-Free Grammars, Pushdown Automata & Turing Machines', 'weeks': '3.0w', 'blooms': 'K4 Analyze'},
        {'name': 'Compiler Structure & Lexical Analysis (Flex/Lex)', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Syntax Analysis: LL(1), LR(1), LALR Parsers & AST Generation', 'weeks': '3.5w', 'blooms': 'K5 Evaluate'},
        {'name': 'Intermediate Code Generation & Target Machine Optimization', 'weeks': '3.0w', 'blooms': 'K5 Evaluate'},
      ],
    },
    {
      'code': 'CSE4203',
      'title': 'Computer Graphics',
      'year': 'Year 4',
      'semester': 'Semester 8 (4.2)',
      'credits': '3.0 Cr',
      'summary': '2D/3D viewing, clipping, object representations, hidden line algorithms, and raster graphics.',
      'color': Color(0xFF7C3AED),
      'topics': [
        {'name': 'Raster Graphics, Scan Conversion & Bresenham Line Drawing', 'weeks': '2.5w', 'blooms': 'K3 Apply'},
        {'name': '2D/3D Affine Transformations & Homogeneous Coordinates', 'weeks': '3.0w', 'blooms': 'K3 Apply'},
        {'name': '3D Viewing Pipelines, Projections & Line Clipping', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Object Representations, Splines & Polygonal Meshes', 'weeks': '2.5w', 'blooms': 'K4 Analyze'},
        {'name': 'Visible Surface Determination & Hidden Line/Surface Algorithms', 'weeks': '3.5w', 'blooms': 'K4 Analyze'},
      ],
    },
  ];

  // Dynamic list for curriculum in View 4
  late List<Map<String, dynamic>> generatedCurriculum;

  @override
  void initState() {
    super.initState();
    _initDefaultCurriculum();
  }

  void _initDefaultCurriculum() {
    generatedCurriculum = [
      {
        'module': 'Module 1: Foundations & Core Mathematical Models',
        'lessons': [
          'Lesson 1.1: Asymptotic Analysis & Recurrence Relations',
          'Lesson 1.2: State Space Search & Invariant Verification',
          'Lesson 1.3: Empirical Complexity Profiling Lab',
        ],
      },
      {
        'module': 'Module 2: Advanced Data Flow & Distributed Paradigms',
        'lessons': [
          'Lesson 2.1: Fault-Tolerant Consensus & State Replication',
          'Lesson 2.2: Reactive Event Streaming & Message Brokering',
          'Lesson 2.3: Hands-on Microservice Stress Testing',
        ],
      },
      {
        'module': 'Module 3: Industry Synthesis & Capstone Readiness',
        'lessons': [
          'Lesson 3.1: ABET Criterion 3 Outcome Verification',
          'Lesson 3.2: Final Peer Code Review & Artifact Evaluation',
        ],
      },
    ];
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    chatInputCtrl.dispose();
    super.dispose();
  }

  // ==========================================
  // FUNCTIONAL EDIT TOPIC MODAL (View 2) WITH AI CONFLICT ASSISTANT
  // ==========================================
  void _showEditTopicDialog(int topicIndex, Map<String, dynamic> topic) {
    final TextEditingController nameCtrl = TextEditingController(text: topic['name'] as String);
    final TextEditingController weeksCtrl = TextEditingController(text: topic['weeks'] as String);
    String selectedBlooms = topic['blooms'] as String;

    final List<String> bloomsOptions = [
      'K2 Understand',
      'K3 Apply',
      'K4 Analyze',
      'K5 Evaluate',
      'K6 Create',
    ];

    if (!bloomsOptions.contains(selectedBlooms)) {
      selectedBlooms = bloomsOptions[2]; // K4 Analyze default
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit_note, color: Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text('Edit Course Content Topic', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Topic Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Duration (Weeks)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                              const SizedBox(height: 6),
                              TextField(
                                controller: weeksCtrl,
                                decoration: InputDecoration(
                                  hintText: 'e.g., 3.0w',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bloom\'s Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedBlooms,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: bloomsOptions.map((opt) {
                                  return DropdownMenuItem(value: opt, child: Text(opt, style: const TextStyle(fontSize: 13)));
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setDialogState(() => selectedBlooms = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 16, color: Color(0xFF7C3AED)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'AI automatically verifies prerequisite consistency across all 22 courses when saved.',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                ),
                ElevatedButton(
                  onPressed: () {
                    final String newName = nameCtrl.text.trim();
                    final String newWeeks = weeksCtrl.text.trim().isEmpty ? '2.5w' : weeksCtrl.text.trim();
                    if (newName.isEmpty) return;

                    final course = syllabusCourses[selectedCourseIndex];
                    Navigator.pop(context);

                    // Automatic AI analysis if content title changed
                    if (newName.toLowerCase() != (topic['name'] as String).toLowerCase()) {
                      final analysis = CourseContentAiAssistant.analyzeAddContent(
                        newContentTitle: newName,
                        targetCourseCode: course['code'] as String,
                        targetCourseTitle: course['title'] as String,
                        allCourses: syllabusCourses,
                      );

                      if (analysis.hasConflict) {
                        ContentConflictAssistantModal.show(
                          context: context,
                          analysis: analysis,
                          onConfirm: () {
                            Navigator.pop(context);
                            setState(() {
                              final List topics = course['topics'] as List;
                              topics[topicIndex] = {
                                'name': newName,
                                'weeks': newWeeks,
                                'blooms': selectedBlooms,
                              };
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Updated topic: "$newName" (with acknowledged AI advisory)'),
                                backgroundColor: const Color(0xFF059669),
                              ),
                            );
                          },
                          onEditAlternative: () {
                            Navigator.pop(context);
                            _showEditTopicDialog(topicIndex, {
                              'name': newName,
                              'weeks': newWeeks,
                              'blooms': selectedBlooms,
                            });
                          },
                          onCancel: () {
                            Navigator.pop(context);
                          },
                        );
                        return;
                      }
                    }

                    // Safe update
                    setState(() {
                      final List topics = course['topics'] as List;
                      topics[topicIndex] = {
                        'name': newName,
                        'weeks': newWeeks,
                        'blooms': selectedBlooms,
                      };
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ AI verified: Updated topic "$newName"'),
                        backgroundColor: const Color(0xFF059669),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Automatically triggers AI Dependency Analysis before deleting any course content topic
  void _handleDeleteTopicWithAiAssistant(int topicIndex, Map<String, dynamic> topic, Map<String, dynamic> course) {
    final analysis = CourseContentAiAssistant.analyzeDeleteContent(
      contentTitle: topic['name'] as String,
      targetCourseCode: course['code'] as String,
      targetCourseTitle: course['title'] as String,
      allCourses: syllabusCourses,
    );

    ContentConflictAssistantModal.show(
      context: context,
      analysis: analysis,
      onConfirm: () {
        Navigator.pop(context); // Close dialog
        setState(() {
          final List topics = course['topics'] as List;
          topics.removeAt(topicIndex);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed topic: "${topic['name']}" (Action confirmed by admin)'),
            backgroundColor: const Color(0xFF0F172A),
          ),
        );
      },
      onCancel: () {
        Navigator.pop(context); // Safe cancel, keep topic
      },
    );
  }

  /// Automatically triggers AI Dependency Analysis before deleting any curriculum module or lesson
  void _handleDeleteCurriculumItemWithAiAssistant({
    required String itemName,
    required bool isModule,
    required VoidCallback onProceed,
  }) {
    final String currentTitle = titleController.text.trim().isEmpty
        ? 'New Course Curriculum'
        : titleController.text.trim();

    final analysis = CourseContentAiAssistant.analyzeDeleteContent(
      contentTitle: itemName,
      targetCourseCode: 'NEW-COURSE',
      targetCourseTitle: currentTitle,
      allCourses: syllabusCourses,
    );

    ContentConflictAssistantModal.show(
      context: context,
      analysis: analysis,
      onConfirm: () {
        Navigator.pop(context);
        onProceed();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed ${isModule ? "module" : "lesson"}: "$itemName"'),
            backgroundColor: const Color(0xFF0F172A),
          ),
        );
      },
      onCancel: () {
        Navigator.pop(context);
      },
    );
  }

  // ==========================================
  // FUNCTIONAL EDIT CURRICULUM ITEM (View 4)
  // ==========================================
  void _showEditCurriculumDialog({
    required String initialTitle,
    required bool isModule,
    required Function(String newTitle) onSaved,
  }) {
    final TextEditingController editCtrl = TextEditingController(text: initialTitle);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isModule ? 'Edit Module Title' : 'Edit Lesson Title', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: editCtrl,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (editCtrl.text.trim().isNotEmpty) {
                  onSaved(editCtrl.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Curriculum item updated!'), backgroundColor: Color(0xFF059669)),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // MULTI-AI INTERACTIVE GEMINI CHAT
  // ==========================================
  void _handleSendChatMessage(String query, {String? courseContext}) {
    if (query.trim().isEmpty) return;

    setState(() {
      chatMessages.add({'sender': 'user', 'text': query.trim()});
      isAiThinking = true;
    });
    chatInputCtrl.clear();

    // Multi-AI response simulation with dynamic reasoning across all 22 courses
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      String aiReply = '';
      final String lowerQuery = query.toLowerCase();

      // Check if user is asking about a specific course
      if (lowerQuery.contains('cse2103') || lowerQuery.contains('data structure')) {
        aiReply = '📘 **CSE2103 Data Structures Analysis**:\n'
            '• **Prerequisite Link**: Foundational to CSE2207 (Algorithms), CSE3103 (Database), CSE3213 (Operating Systems), and CSE3207 (AI).\n'
            '• **Ripple Risk**: Removing *BFS/DFS* causes high cascade failure (Risk Score: 78/100). Graph traversal is mandated by ABET SO-1.\n'
            '• **Recommendation**: Keep Trees and Graphs intact. Add 2 practical lab hours for AVL balancing.';
      } else if (lowerQuery.contains('cse2207') || lowerQuery.contains('algorithm')) {
        aiReply = '⚡ **CSE2207 Algorithms Attainment**:\n'
            '• **Bloom\'s Level**: Requires K4 (Analyze) & K5 (Evaluate) for Dynamic Programming and NP-Completeness.\n'
            '• **Prerequisites Needed**: CSE2103 (Data Structures) and CSE1203 (Discrete Mathematics).\n'
            '• **ABET Criterion 3**: Maps directly into Student Outcome 1 (Complex Computing Solutions).';
      } else if (lowerQuery.contains('edit') || lowerQuery.contains('change')) {
        aiReply = '✏️ **Syllabus Editing Guidance**:\n'
            'You can directly edit any topic in **View 2 (Change Course)** by clicking the 3-dot menu beside each item and selecting **"Edit Topic"**. You can adjust the topic name, duration weeks, and Bloom\'s taxonomy level in real time!';
      } else if (lowerQuery.contains('limit') || lowerQuery.contains('quota') || lowerQuery.contains('multiple ai')) {
        // Multi-AI Failover demonstration
        setState(() {
          currentAiProviderIndex = (currentAiProviderIndex + 1) % aiProviders.length;
        });
        aiReply = '🔄 **Multi-AI Engine Failover Activated**:\n'
            '• Previous engine limit reached or rate-throttled.\n'
            '• Automatically switched to: **${aiProviders[currentAiProviderIndex]}**.\n'
            '• Zero downtime: All contextual syllabus queries remain fully synchronized!';
      } else {
        aiReply = '🎓 **ACADDIE Academic Intelligence (${aiProviders[currentAiProviderIndex]})**:\n'
            'Regarding "$query":\n'
            '• **Curriculum Alignment**: Aligned with the 22 courses in the 4-year AUST CSE Department syllabus.\n'
            '• **ABET & IEEE CS2023**: Continuous attainment requires balancing theoretical lectures with verified laboratory implementations.\n'
            '• **Action**: Would you like me to generate a customized lesson module or simulate downstream impact?';
      }

      setState(() {
        isAiThinking = false;
        chatMessages.add({'sender': 'ai', 'text': aiReply});
      });
    });
  }

  void _openInteractiveAiChatModal({String? initialPrompt, String? courseContext}) {
    if (initialPrompt != null && initialPrompt.isNotEmpty) {
      _handleSendChatMessage(initialPrompt, courseContext: courseContext);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Modal Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFF2563EB), Color(0xFF7C3AED)]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Gemini Curriculum Co-Pilot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    aiProviders[currentAiProviderIndex],
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Failover Switcher Chip
                        ActionChip(
                          avatar: const Icon(Icons.swap_horiz, size: 14),
                          label: const Text('Switch AI', style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            setState(() {
                              currentAiProviderIndex = (currentAiProviderIndex + 1) % aiProviders.length;
                            });
                            setSheetState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Active AI Provider switched to: ${aiProviders[currentAiProviderIndex]}')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  // Chat Messages List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        final msg = chatMessages[index];
                        final bool isAi = msg['sender'] == 'ai';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isAi) ...[
                                const CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Color(0xFF2563EB),
                                  child: Icon(Icons.psychology, color: Colors.white, size: 16),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isAi ? const Color(0xFFF1F5F9) : const Color(0xFF0F172A),
                                    borderRadius: BorderRadius.circular(14),
                                    border: isAi ? Border.all(color: const Color(0xFFE2E8F0)) : null,
                                  ),
                                  child: Text(
                                    msg['text']!,
                                    style: TextStyle(
                                      color: isAi ? const Color(0xFF0F172A) : Colors.white,
                                      fontSize: 13.5,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (isAiThinking)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF2563EB)),
                          ),
                          const SizedBox(width: 10),
                          Text('Gemini AI is analyzing syllabus graph...', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  // Quick Prompt Chips
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: const Color(0xFFF8FAFC),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildQuickPromptChip('Analyze Prerequisite Ripple', setSheetState),
                          const SizedBox(width: 8),
                          _buildQuickPromptChip('How to Edit Syllabus?', setSheetState),
                          const SizedBox(width: 8),
                          _buildQuickPromptChip('Check ABET Criterion 3', setSheetState),
                          const SizedBox(width: 8),
                          _buildQuickPromptChip('Test Multi-AI Failover', setSheetState),
                        ],
                      ),
                    ),
                  ),
                  // Chat Input Field
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: chatInputCtrl,
                            onSubmitted: (val) {
                              _handleSendChatMessage(val);
                              setSheetState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'Ask Gemini about any course, topic, or OBE policy...',
                              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send, color: Color(0xFF2563EB)),
                          onPressed: () {
                            _handleSendChatMessage(chatInputCtrl.text);
                            setSheetState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickPromptChip(String label, void Function(void Function()) setSheetState) {
    return ActionChip(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      label: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF334155), fontWeight: FontWeight.w600)),
      onPressed: () {
        _handleSendChatMessage(label);
        setSheetState(() {});
      },
    );
  }

  void _generateAiOutline() async {
    setState(() {
      isGenerating = true;
    });

    // 1-second AI loading delay
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final String courseTitle = titleController.text.trim().isEmpty
        ? 'Distributed Systems & Cloud Computing'
        : titleController.text.trim();

    setState(() {
      isGenerating = false;
      generatedCurriculum = [
        {
          'module': 'Module 1: Theoretical Foundations of $courseTitle',
          'lessons': [
            'Lesson 1.1: Fundamental Principles, Taxonomy & Formal Primitives',
            'Lesson 1.2: Architectural Invariants & Mathematical Formulations',
            'Lesson 1.3: Hands-on Baseline Simulation Lab',
          ],
        },
        {
          'module': 'Module 2: High-Performance Implementation & Scalability',
          'lessons': [
            'Lesson 2.1: Concurrent Thread Synchronization & Data Integrity',
            'Lesson 2.2: Fault Detection, Resiliency & Recovery Protocols',
            'Lesson 2.3: Production Benchmark Profiling & Load Testing',
          ],
        },
        {
          'module': 'Module 3: OBE Capstone & Accreditation Alignment',
          'lessons': [
            'Lesson 3.1: Industry Standards (IEEE/ACM CS2023 Guidelines)',
            'Lesson 3.2: ABET Criterion 3 Student Outcome Attainment Audit',
          ],
        },
      ];
      currentView = 'add-step2';
    });
  }

  void _showAddContentDialog({String? prefillName, String? prefillWeeks, String? prefillBlooms}) {
    final TextEditingController newContentCtrl = TextEditingController(text: prefillName ?? '');
    final TextEditingController weeksCtrl = TextEditingController(text: prefillWeeks ?? '2.5w');
    String selectedBlooms = prefillBlooms ?? 'K4 Analyze';

    final course = syllabusCourses[selectedCourseIndex];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_task, color: Color(0xFF2563EB), size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text('Add Course Content Topic', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adding to ${course['code']}: ${course['title']}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),
                    const Text('Topic Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: newContentCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g., Graph Neural Networks & Transformers',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Duration (Weeks)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                              const SizedBox(height: 6),
                              TextField(
                                controller: weeksCtrl,
                                decoration: InputDecoration(
                                  hintText: '2.5w',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bloom\'s Level', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: selectedBlooms,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                ),
                                items: ['K2 Understand', 'K3 Apply', 'K4 Analyze', 'K5 Evaluate', 'K6 Create']
                                    .map((opt) => DropdownMenuItem(value: opt, child: Text(opt, style: const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setDialogState(() => selectedBlooms = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_awesome, size: 16, color: Color(0xFF7C3AED)),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'AI automatically analyzes prerequisite relationships, sequencing, and cross-course overlap across 22 courses upon saving.',
                              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    final String topicTitle = newContentCtrl.text.trim();
                    if (topicTitle.isEmpty) return;

                    final String finalWeeks = weeksCtrl.text.trim().isEmpty ? '2.5w' : weeksCtrl.text.trim();
                    Navigator.pop(context); // Close add input dialog

                    // Automatically trigger the AI analysis
                    final analysis = CourseContentAiAssistant.analyzeAddContent(
                      newContentTitle: topicTitle,
                      targetCourseCode: course['code'] as String,
                      targetCourseTitle: course['title'] as String,
                      allCourses: syllabusCourses,
                    );

                    if (analysis.hasConflict) {
                      // Show interactive AI advisory modal
                      ContentConflictAssistantModal.show(
                        context: context,
                        analysis: analysis,
                        onConfirm: () {
                          Navigator.pop(context);
                          setState(() {
                            final List topics = course['topics'] as List;
                            topics.add({
                              'name': topicTitle,
                              'weeks': finalWeeks,
                              'blooms': selectedBlooms,
                            });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Topic added: "$topicTitle" (with acknowledged AI advisory)'),
                              backgroundColor: const Color(0xFF059669),
                            ),
                          );
                        },
                        onEditAlternative: () {
                          Navigator.pop(context);
                          _showAddContentDialog(
                            prefillName: topicTitle,
                            prefillWeeks: finalWeeks,
                            prefillBlooms: selectedBlooms,
                          );
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      // Safe addition: automatically save and show concise notification
                      setState(() {
                        final List topics = course['topics'] as List;
                        topics.add({
                          'name': topicTitle,
                          'weeks': finalWeeks,
                          'blooms': selectedBlooms,
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text('✓ AI analysis complete — No conflicts or dependencies detected. Topic added.'),
                              ),
                            ],
                          ),
                          backgroundColor: Color(0xFF059669),
                          duration: Duration(seconds: 4),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 16),
                      SizedBox(width: 6),
                      Text('Save & Analyze Content'),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      // Global Element (Always visible): Top Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black12,
        shape: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF0F172A)),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Navigation Menu',
          ),
        ),
        title: InkWell(
          onTap: () => setState(() => currentView = 'dashboard'),
          borderRadius: BorderRadius.circular(8),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.auto_stories, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Acaddie',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                      fontSize: 21,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: const Text(
                      '1.0',
                      style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          // Interactive Gemini Multi-AI Assistant
          ElevatedButton.icon(
            onPressed: () => _openInteractiveAiChatModal(),
            icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            label: const Text('Gemini Co-Pilot', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Firebase Cloud Auth: Professor Shilpo (AUST CSE) Connected'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: const Color(0xFF0F172A),
                    child: const Text(
                      'PS',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prof. Shilpo',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      Text(
                        'AUST CSE',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.school, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ACADDIE 1.0',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'OBE Curriculum Decision Co-Pilot',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Ahsanullah University of Science & Tech',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined, color: Color(0xFF0F172A)),
              title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.w600)),
              selected: currentView == 'dashboard',
              onTap: () {
                setState(() => currentView = 'dashboard');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Color(0xFF2563EB)),
              title: const Text('Add a Course', style: TextStyle(fontWeight: FontWeight.w600)),
              selected: currentView == 'add-step1' || currentView == 'add-step2',
              onTap: () {
                setState(() => currentView = 'add-step1');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tune_outlined, color: Color(0xFF0D9488)),
              title: const Text('Change a Course', style: TextStyle(fontWeight: FontWeight.w600)),
              selected: currentView == 'change-select' || currentView == 'change-manage',
              onTap: () {
                setState(() => currentView = 'change-select');
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline, color: Color(0xFF7C3AED)),
              title: const Text('Gemini Co-Pilot Chat', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                _openInteractiveAiChatModal();
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Official AUST CSE Syllabus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('${syllabusCourses.length} Courses across 8 Semesters loaded with ABET Criterion 3 rules.',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openInteractiveAiChatModal(),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.auto_awesome, color: Color(0xFF60A5FA), size: 18),
        label: const Text('Ask AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: _buildCurrentView(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (currentView) {
      case 'dashboard':
        return _buildDashboardView();
      case 'change-select':
        return _buildChangeSelectView();
      case 'change-manage':
        return _buildChangeManageView();
      case 'add-step1':
        return _buildAddStep1View();
      case 'add-step2':
        return _buildAddStep2View();
      default:
        return _buildDashboardView();
    }
  }

  // ==========================================
  // VIEW 0: Dashboard
  // ==========================================
  Widget _buildDashboardView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: Color(0xFF60A5FA), size: 14),
                        SizedBox(width: 6),
                        Text(
                          'AUST CSE • 22 Courses Loaded • OBE Active',
                          style: TextStyle(color: Color(0xFFBFDBFE), fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Welcome Back, Professor Shilpo',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'How can I help you with your curriculum today?',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF94A3B8),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => setState(() => currentView = 'add-step1'),
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    label: const Text(
                      'Add a course',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      shadowColor: const Color(0xFF2563EB).withOpacity(0.4),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => setState(() => currentView = 'change-select'),
                    icon: const Icon(Icons.tune, size: 20),
                    label: const Text(
                      'Change a course',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF475569), width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Live Department Syllabus Stats
        Row(
          children: [
            Expanded(
              child: _buildMetricCard('${syllabusCourses.length} Courses', 'Full 4-Year Sequence', Icons.auto_stories, const Color(0xFF2563EB)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard('8 Semesters', 'ABET & IEEE Accredited', Icons.verified_user, const Color(0xFF059669)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildMetricCard(aiProviders[currentAiProviderIndex], 'Multi-AI Failover Active', Icons.psychology, const Color(0xFF7C3AED)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 1: Change Select
  // ==========================================
  Widget _buildChangeSelectView() {
    final filteredCourses = selectedFilter == 'All'
        ? syllabusCourses
        : syllabusCourses.where((c) => c['year'] == selectedFilter).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
              onPressed: () => setState(() => currentView = 'dashboard'),
              tooltip: 'Back to Dashboard',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select the course',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    'Choose a course from your official departmental syllabus (${syllabusCourses.length} Courses)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Year filter chips
        Row(
          children: ['All', 'Year 1', 'Year 2', 'Year 3', 'Year 4'].map((filter) {
            final bool isSelected = selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                selectedColor: const Color(0xFF0F172A),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF334155),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)),
                ),
                onSelected: (val) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        // Responsive Course Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final int crossAxisCount = constraints.maxWidth > 700 ? 3 : (constraints.maxWidth > 450 ? 2 : 1);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                final Color courseColor = course['color'] as Color;
                final int originalIndex = syllabusCourses.indexOf(course);

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCourseIndex = originalIndex;
                      currentView = 'change-manage';
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: courseColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                course['code'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: courseColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              course['semester'] as String,
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          course['title'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF0F172A),
                            height: 1.25,
                          ),
                        ),
                        Text(
                          course['summary'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[600], fontSize: 11, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // ==========================================
  // VIEW 2: Change Manage
  // ==========================================
  Widget _buildChangeManageView() {
    final course = syllabusCourses[selectedCourseIndex];
    final List topics = course['topics'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
              onPressed: () => setState(() => currentView = 'change-select'),
              tooltip: 'Back to Course List',
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Existing contents of ${course['code']}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    course['title'] as String,
                    style: const TextStyle(fontSize: 15, color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Official Course Summary:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
              const SizedBox(height: 4),
              Text(
                course['summary'] as String,
                style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // AI Content Conflict & Dependency Assistant Ambient Status Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.auto_awesome, color: Color(0xFF2563EB), size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Content Conflict & Dependency Assistant Active',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Automatic cross-course dependency & overlap checks on every Add, Edit, or Delete.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 13, color: Color(0xFF16A34A)),
                    SizedBox(width: 4),
                    Text(
                      'Auto-Guard Active',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: topics.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final topic = topics[index] as Map<String, dynamic>;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic['name'] as String,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                topic['weeks'] as String,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDF4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                topic['blooms'] as String,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Direct Functional Edit Icon Button
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF2563EB)),
                    tooltip: 'Edit Topic',
                    onPressed: () => _showEditTopicDialog(index, topic),
                  ),
                  // Direct Functional Delete Icon Button with Automatic AI Dependency Check
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFEF4444)),
                    tooltip: 'Delete Topic (AI Protected)',
                    onPressed: () => _handleDeleteTopicWithAiAssistant(index, topic, course),
                  ),
                  // Functional Popup Menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Color(0xFF64748B)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onSelected: (val) {
                      if (val == 'Edit') {
                        _showEditTopicDialog(index, topic);
                      } else if (val == 'Delete') {
                        _handleDeleteTopicWithAiAssistant(index, topic, course);
                      } else if (val == 'AI Analysis') {
                        _openInteractiveAiChatModal(
                          initialPrompt: 'Provide OBE analysis and recommendations for topic: "${topic['name']}" in course ${course['code']}',
                          courseContext: course['code'] as String,
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'Edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 16, color: Color(0xFF2563EB)),
                            SizedBox(width: 8),
                            Text('Edit Topic'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'AI Analysis',
                        child: Row(
                          children: [
                            Icon(Icons.auto_awesome, size: 16, color: Color(0xFF7C3AED)),
                            SizedBox(width: 8),
                            Text('Ask Gemini About Topic'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 16, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete Topic (AI Analysis)', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _showAddContentDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add new', style: TextStyle(fontWeight: FontWeight.w700)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // VIEW 3: Add Step 1
  // ==========================================
  Widget _buildAddStep1View() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
              onPressed: () => setState(() => currentView = 'dashboard'),
              tooltip: 'Back to Dashboard',
            ),
            const SizedBox(width: 8),
            const Text(
              'Add a Course',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Modern Stepper
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_note, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Step 1: Basic Information',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            const Text(
              'Step 2: Curriculum Builder',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Preset Suggestions from user syllabus
        const Text('Quick Suggestions from CSE Advanced Electives:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ActionChip(
              label: const Text('Natural Language Processing & LLMs', style: TextStyle(fontSize: 12)),
              onPressed: () {
                setState(() {
                  titleController.text = 'Natural Language Processing & LLMs';
                  descController.text = 'Covers tokenization, transformer attention heads, vector databases, and retrieval augmented generation (RAG).';
                });
              },
            ),
            ActionChip(
              label: const Text('Cloud Computing & Distributed Systems', style: TextStyle(fontSize: 12)),
              onPressed: () {
                setState(() {
                  titleController.text = 'Distributed Systems & Cloud Computing';
                  descController.text = 'Covers distributed consensus, Raft protocol, microservices fault tolerance, and cloud scale storage.';
                });
              },
            ),
            ActionChip(
              label: const Text('Cybersecurity & Modern Cryptography', style: TextStyle(fontSize: 12)),
              onPressed: () {
                setState(() {
                  titleController.text = 'Cybersecurity & Modern Cryptography';
                  descController.text = 'Covers zero-trust architecture, symmetric/asymmetric encryption, side-channel attacks, and network defense.';
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Course Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'e.g., Advanced Distributed Systems',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Course Description & Learning Outcomes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        TextField(
          controller: descController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe course goals, student learning objectives, prerequisites, and evaluation expectations...',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: isGenerating ? null : _generateAiOutline,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 2,
          ),
          child: isGenerating
              ? const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Gemini AI is analyzing ABET syllabus standards...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 18, color: Color(0xFF60A5FA)),
                    SizedBox(width: 10),
                    Text(
                      'Generate course outline using AI',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  // ==========================================
  // VIEW 4: Add Step 2
  // ==========================================
  Widget _buildAddStep2View() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
              onPressed: () => setState(() => currentView = 'add-step1'),
              tooltip: 'Back to Step 1',
            ),
            const SizedBox(width: 8),
            const Text(
              'Add a Course',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Stepper: Step 2 Active
        Row(
          children: [
            InkWell(
              onTap: () => setState(() => currentView = 'add-step1'),
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Text(
                  'Step 1: Basic Information',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_tree, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Step 2: Curriculum Builder',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Success Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            border: Border.all(color: const Color(0xFFBBF7D0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Success: AI generated outline aligned with IEEE CS2023 & ABET Criterion 3.',
                  style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Dynamic Nested List with Working Edit and Delete
        ...generatedCurriculum.asMap().entries.map((entry) {
          final int modIdx = entry.key;
          final Map<String, dynamic> mod = entry.value;
          final String modTitle = mod['module'] as String;
          final List<String> lessons = List<String>.from(mod['lessons'] as List);

          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Module Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.folder_outlined, color: Color(0xFF2563EB), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          modTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
                        ),
                      ),
                      _buildRowActionIcons(
                        modTitle,
                        onEdit: () {
                          _showEditCurriculumDialog(
                            initialTitle: modTitle,
                            isModule: true,
                            onSaved: (newTitle) {
                              setState(() {
                                mod['module'] = newTitle;
                              });
                            },
                          );
                        },
                        onDelete: () {
                          _handleDeleteCurriculumItemWithAiAssistant(
                            itemName: modTitle,
                            isModule: true,
                            onProceed: () {
                              setState(() {
                                generatedCurriculum.removeAt(modIdx);
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Lessons
                ...lessons.asMap().entries.map((lessonEntry) {
                  final int lessonIdx = lessonEntry.key;
                  final String lesson = lessonEntry.value;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.subdirectory_arrow_right, size: 18, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            lesson,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF334155), fontWeight: FontWeight.w500),
                          ),
                        ),
                        _buildRowActionIcons(
                          lesson,
                          onEdit: () {
                            _showEditCurriculumDialog(
                              initialTitle: lesson,
                              isModule: false,
                              onSaved: (newTitle) {
                                setState(() {
                                  lessons[lessonIdx] = newTitle;
                                  mod['lessons'] = lessons;
                                });
                              },
                            );
                          },
                          onDelete: () {
                            _handleDeleteCurriculumItemWithAiAssistant(
                              itemName: lesson,
                              isModule: false,
                              onProceed: () {
                                setState(() {
                                  lessons.removeAt(lessonIdx);
                                  mod['lessons'] = lessons;
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            final String newModTitle = 'Module ${generatedCurriculum.length + 1}: Emerging Technology & Capstone Lab';
            final analysis = CourseContentAiAssistant.analyzeAddContent(
              newContentTitle: newModTitle,
              targetCourseCode: 'NEW-COURSE',
              targetCourseTitle: titleController.text.trim().isEmpty ? 'Draft Course' : titleController.text.trim(),
              allCourses: syllabusCourses,
            );

            if (analysis.hasConflict) {
              ContentConflictAssistantModal.show(
                context: context,
                analysis: analysis,
                onConfirm: () {
                  Navigator.pop(context);
                  setState(() {
                    generatedCurriculum.add({
                      'module': newModTitle,
                      'lessons': [
                        'Lesson ${generatedCurriculum.length + 1}.1: Practical Implementation & Rigorous Testing',
                        'Lesson ${generatedCurriculum.length + 1}.2: Peer Defense & Evaluation',
                      ],
                    });
                  });
                },
                onCancel: () => Navigator.pop(context),
              );
            } else {
              setState(() {
                generatedCurriculum.add({
                  'module': newModTitle,
                  'lessons': [
                    'Lesson ${generatedCurriculum.length + 1}.1: Practical Implementation & Rigorous Testing',
                    'Lesson ${generatedCurriculum.length + 1}.2: Peer Defense & Evaluation',
                  ],
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✓ AI verified: Added new module without cross-course conflicts.'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            }
          },
          icon: const Icon(Icons.add, color: Color(0xFF0F172A)),
          label: const Text('Add New Module', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildRowActionIcons(
    String itemName, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF2563EB)),
          tooltip: 'Edit item',
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
          tooltip: 'Delete item',
          onPressed: onDelete,
        ),
        IconButton(
          icon: const Icon(Icons.auto_awesome_outlined, size: 18, color: Color(0xFF7C3AED)),
          tooltip: 'Ask Gemini AI',
          onPressed: () => _openInteractiveAiChatModal(
            initialPrompt: 'Review and optimize pedagogical clarity for item: "$itemName"',
          ),
        ),
      ],
    );
  }
}
