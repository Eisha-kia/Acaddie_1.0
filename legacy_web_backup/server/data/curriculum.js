export const universityMetadata = {
  name: "Ahsanullah University of Science and Technology",
  shortName: "AUST",
  department: "Department of Computer Science and Engineering",
  program: "Bachelor of Science in Computer Science and Engineering",
  degree: "BSc in CSE",
  curriculumVersion: "2025-2026 Outcome-Based Education (OBE) Standard",
  totalCredits: 160,
  passingGrade: 2.0
};

export const courses = [
  {
    id: "CSE-101",
    code: "CSE 101",
    name: "Programming Fundamentals",
    semester: 1,
    credit: 3.0,
    type: "Core",
    description: "Introduction to procedural problem solving, syntax, pointers, memory allocation, and structured programming paradigms in C/C++.",
    prerequisites: [],
    assessments: [
      { type: "Final Examination", percentage: 40, category: "Theory" },
      { type: "Midterm Examination", percentage: 30, category: "Theory" },
      { type: "Continuous Quizzes", percentage: 15, category: "Theory" },
      { type: "Laboratory & Hands-on Coding", percentage: 15, category: "Practical" }
    ],
    assessmentRatio: { theory: 85, practical: 15 },
    clos: [
      { id: "CSE101-CLO1", description: "Construct structured algorithms to solve fundamental computational tasks.", bloomLevel: "Apply", importance: 30 },
      { id: "CSE101-CLO2", description: "Implement modular, bug-free C/C++ programs utilizing control flows and arrays.", bloomLevel: "Apply", importance: 35 },
      { id: "CSE101-CLO3", description: "Demonstrate manual memory management through pointer manipulation and dynamic memory allocation.", bloomLevel: "Analyze", importance: 35 }
    ],
    topics: [
      { id: "PF-1", name: "Variables, Primitive Types & Expressions", weeks: 1.5, importance: "Core", cloId: "CSE101-CLO1", downstreamTopicPrereqs: ["DS-1"] },
      { id: "PF-2", name: "Control Structures, Branching & Loops", weeks: 2.0, importance: "Core", cloId: "CSE101-CLO1", downstreamTopicPrereqs: ["DS-1", "DS-2"] },
      { id: "PF-3", name: "Modular Functions, Scope & Parameter Passing", weeks: 2.5, importance: "Core", cloId: "CSE101-CLO2", downstreamTopicPrereqs: ["DS-4"] },
      { id: "PF-4", name: "Pointers, References & Heap Allocation", weeks: 3.0, importance: "Critical", cloId: "CSE101-CLO3", downstreamTopicPrereqs: ["DS-1", "DS-2", "DS-5"] },
      { id: "PF-5", name: "Multi-dimensional Arrays, Strings & Structures", weeks: 3.0, importance: "Core", cloId: "CSE101-CLO2", downstreamTopicPrereqs: ["DS-1", "DS-3"] }
    ]
  },
  {
    id: "CSE-207",
    code: "CSE 207",
    name: "Data Structures",
    semester: 3,
    credit: 3.0,
    type: "Core",
    description: "Comprehensive exploration of linear and hierarchical data organizations, abstract data types, recursive formulations, graph algorithms, and asymptotic complexity.",
    prerequisites: ["CSE-101"],
    assessments: [
      { type: "Final Examination", percentage: 40, category: "Theory" },
      { type: "Midterm Examination", percentage: 25, category: "Theory" },
      { type: "Quizzes & Class Tests", percentage: 15, category: "Theory" },
      { type: "Data Structure Lab & Project", percentage: 20, category: "Practical" }
    ],
    assessmentRatio: { theory: 65, practical: 35 },
    clos: [
      { id: "CSE207-CLO1", description: "Analyze asymptotic computational time and space bounds for operations on diverse data structures.", bloomLevel: "Analyze", importance: 20 },
      { id: "CSE207-CLO2", description: "Implement fundamental linear data structures (arrays, linked lists, stacks, queues) to solve real-world processing bottlenecks.", bloomLevel: "Apply", importance: 25 },
      { id: "CSE207-CLO3", description: "Design efficient recursive, tree, and graph algorithms for network traversals, shortest paths, and search spaces.", bloomLevel: "Create", importance: 35 },
      { id: "CSE207-CLO4", description: "Evaluate trade-offs between memory footprint and access speed in hashing and balanced search trees.", bloomLevel: "Evaluate", importance: 20 }
    ],
    topics: [
      { id: "DS-1", name: "Asymptotic Analysis & Dynamic Arrays", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO1", downstreamTopicPrereqs: ["ALG-1"] },
      { id: "DS-2", name: "Linked Lists (Singly, Doubly, Circular)", weeks: 2.0, importance: "Core", cloId: "CSE207-CLO2", downstreamTopicPrereqs: ["ALG-2", "OS-1"] },
      { id: "DS-3", name: "Stacks, Queues & Deques with Applications", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO2", downstreamTopicPrereqs: ["OS-2", "AI-2"] },
      { id: "DS-4", name: "Recursion & Backtracking Techniques", weeks: 2.0, importance: "Critical", cloId: "CSE207-CLO3", downstreamTopicPrereqs: ["ALG-2", "ALG-4", "AI-3"] },
      { id: "DS-5", name: "Trees & Binary Search Trees (BST, AVL)", weeks: 2.5, importance: "Critical", cloId: "CSE207-CLO3", downstreamTopicPrereqs: ["ALG-3", "DB-2", "ML-2"] },
      { 
        id: "DS-6", 
        name: "Graph Algorithms (Representations, BFS, DFS, Dijkstra, MST)", 
        weeks: 3.5, 
        importance: "Critical", 
        cloId: "CSE207-CLO3", 
        downstreamTopicPrereqs: ["ALG-3", "AI-2", "OS-3", "ML-6"] 
      },
      { id: "DS-7", name: "Foundations of Dynamic Programming", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO3", downstreamTopicPrereqs: ["ALG-4"] },
      { id: "DS-8", name: "Hashing, Hash Tables & Collision Resolution", weeks: 1.5, importance: "Core", cloId: "CSE207-CLO4", downstreamTopicPrereqs: ["DB-5", "ALG-5"] }
    ]
  },
  {
    id: "CSE-301",
    code: "CSE 301",
    name: "Algorithms",
    semester: 4,
    credit: 3.0,
    type: "Core",
    description: "Design and rigorous analysis of advanced algorithms: divide-and-conquer, greedy heuristics, advanced graph network flows, dynamic programming, and intractability (NP-completeness).",
    prerequisites: ["CSE-207"],
    assessments: [
      { type: "Final Examination", percentage: 40, category: "Theory" },
      { type: "Midterm Examination", percentage: 25, category: "Theory" },
      { type: "Quizzes", percentage: 15, category: "Theory" },
      { type: "Competitive Programming Lab", percentage: 20, category: "Practical" }
    ],
    assessmentRatio: { theory: 60, practical: 40 },
    clos: [
      { id: "CSE301-CLO1", description: "Formulate optimal algorithmic strategies for complex combinatorial and network flow challenges.", bloomLevel: "Create", importance: 35 },
      { id: "CSE301-CLO2", description: "Implement and benchmark advanced graph traversal, max-flow, and shortest-path algorithms.", bloomLevel: "Apply", importance: 35 },
      { id: "CSE301-CLO3", description: "Prove algorithmic correctness and analyze complexity bounds for polynomial vs NP-complete problems.", bloomLevel: "Evaluate", importance: 30 }
    ],
    topics: [
      { id: "ALG-1", name: "Recurrence Relations & Master Theorem", weeks: 1.5, importance: "Core", cloId: "CSE301-CLO3", requiresTopic: "DS-1" },
      { id: "ALG-2", name: "Advanced Divide & Conquer Paradigm", weeks: 2.0, importance: "Core", cloId: "CSE301-CLO1", requiresTopic: "DS-4" },
      { 
        id: "ALG-3", 
        name: "Advanced Graph Algorithms (Bellman-Ford, Floyd-Warshall, Max-Flow Ford-Fulkerson)", 
        weeks: 3.5, 
        importance: "Critical", 
        cloId: "CSE301-CLO2", 
        requiresTopic: "DS-6",
        downstreamTopicPrereqs: ["AI-2", "ML-6"] 
      },
      { id: "ALG-4", name: "Multi-stage Dynamic Programming (Knapsack, LCS, Matrix Chain)", weeks: 3.0, importance: "Critical", cloId: "CSE301-CLO1", requiresTopic: "DS-7" },
      { id: "ALG-5", name: "Greedy Algorithms (Huffman Coding, Task Scheduling)", weeks: 2.0, importance: "Core", cloId: "CSE301-CLO1", requiresTopic: "DS-8" },
      { id: "ALG-6", name: "NP-Completeness, Reductions & Approximation", weeks: 2.0, importance: "Advanced", cloId: "CSE301-CLO3", requiresTopic: "ALG-3" }
    ]
  },
  {
    id: "CSE-305",
    code: "CSE 305",
    name: "Database Systems",
    semester: 4,
    credit: 3.0,
    type: "Core",
    description: "Relational database design, relational algebra, SQL optimization, physical storage, B+ Tree indexing, ACID transactions, and concurrency control.",
    prerequisites: ["CSE-207"],
    assessments: [
      { type: "Final Examination", percentage: 40, category: "Theory" },
      { type: "Midterm Examination", percentage: 25, category: "Theory" },
      { type: "Quizzes", percentage: 10, category: "Theory" },
      { type: "Database Project & Lab", percentage: 25, category: "Practical" }
    ],
    assessmentRatio: { theory: 60, practical: 40 },
    clos: [
      { id: "CSE305-CLO1", description: "Design normalized relational schemas satisfying Boyce-Codd Normal Form constraints.", bloomLevel: "Create", importance: 30 },
      { id: "CSE305-CLO2", description: "Formulate complex SQL queries and analyze execution plans for indexing optimizations.", bloomLevel: "Analyze", importance: 40 },
      { id: "CSE305-CLO3", description: "Evaluate ACID compliance and concurrency serialization mechanisms in transaction managers.", bloomLevel: "Evaluate", importance: 30 }
    ],
    topics: [
      { id: "DB-1", name: "Relational Data Model & Formal Relational Algebra", weeks: 2.0, importance: "Core", cloId: "CSE305-CLO1" },
      { id: "DB-2", name: "Physical File Storage & B+ Tree Multi-level Indexing", weeks: 3.0, importance: "Critical", cloId: "CSE305-CLO2", requiresTopic: "DS-5" },
      { id: "DB-3", name: "SQL Query Formulation & Cost-Based Query Optimization", weeks: 3.5, importance: "Core", cloId: "CSE305-CLO2" },
      { id: "DB-4", name: "Transaction Management, Concurrency & 2PL Locks", weeks: 3.0, importance: "Critical", cloId: "CSE305-CLO3" },
      { id: "DB-5", name: "Distributed Databases & Consistent Hashing", weeks: 2.5, importance: "Core", cloId: "CSE305-CLO3", requiresTopic: "DS-8" }
    ]
  },
  {
    id: "CSE-307",
    code: "CSE 307",
    name: "Operating Systems",
    semester: 5,
    credit: 3.0,
    type: "Core",
    description: "Fundamental architectural concepts of computer operating systems: kernel architecture, multiprocessing, process synchronization, CPU scheduling, memory management, and file systems.",
    prerequisites: ["CSE-207", "CSE-101"],
    assessments: [
      { type: "Final Examination", percentage: 40, category: "Theory" },
      { type: "Midterm Examination", percentage: 25, category: "Theory" },
      { type: "Quizzes", percentage: 15, category: "Theory" },
      { type: "OS Kernel / Shell Lab", percentage: 20, category: "Practical" }
    ],
    assessmentRatio: { theory: 70, practical: 30 },
    clos: [
      { id: "CSE307-CLO1", description: "Analyze process lifecycle, thread synchronization, and race conditions using semaphores.", bloomLevel: "Analyze", importance: 35 },
      { id: "CSE307-CLO2", description: "Design CPU scheduling and deadlock handling routines using resource allocation graph models.", bloomLevel: "Create", importance: 35 },
      { id: "CSE307-CLO3", description: "Evaluate paging and virtual memory replacement algorithms under heavy workloads.", bloomLevel: "Evaluate", importance: 30 }
    ],
    topics: [
      { id: "OS-1", name: "OS Architectures, System Calls & Interrupt Handling", weeks: 2.0, importance: "Core", cloId: "CSE307-CLO1", requiresTopic: "DS-2" },
      { id: "OS-2", name: "Process Synchronization, Semaphores & Mutexes", weeks: 3.0, importance: "Critical", cloId: "CSE307-CLO1", requiresTopic: "DS-3" },
      { id: "OS-3", name: "Deadlock Detection & Resource Allocation Directed Graphs", weeks: 2.5, importance: "Critical", cloId: "CSE307-CLO2", requiresTopic: "DS-6" },
      { id: "OS-4", name: "CPU Scheduling Algorithms (Priority, Multi-level Feedback)", weeks: 2.5, importance: "Core", cloId: "CSE307-CLO2" },
      { id: "OS-5", name: "Virtual Memory, Demand Paging & Page Replacement", weeks: 3.0, importance: "Core", cloId: "CSE307-CLO3" }
    ]
  },
  {
    id: "CSE-401",
    code: "CSE 401",
    name: "Artificial Intelligence",
    semester: 6,
    credit: 3.0,
    type: "Core",
    description: "Theoretical and algorithmic foundations of artificial intelligence: heuristic state-space search, adversarial game trees, knowledge representation, Bayesian reasoning, and agent architectures.",
    prerequisites: ["CSE-301"],
    assessments: [
      { type: "Final Examination", percentage: 40, category: "Theory" },
      { type: "Midterm Examination", percentage: 25, category: "Theory" },
      { type: "Class Tests & Quizzes", percentage: 10, category: "Theory" },
      { type: "AI Project & Lab Assignments", percentage: 25, category: "Practical" }
    ],
    assessmentRatio: { theory: 65, practical: 35 },
    clos: [
      { id: "CSE401-CLO1", description: "Design heuristic state-space graph search agents (A*, IDA*, Greedy Best-First) for pathfinding.", bloomLevel: "Create", importance: 35 },
      { id: "CSE401-CLO2", description: "Implement minimax search with alpha-beta pruning in competitive game-playing systems.", bloomLevel: "Apply", importance: 35 },
      { id: "CSE401-CLO3", description: "Formulate probabilistic inference models using Directed Acyclic Belief Networks.", bloomLevel: "Evaluate", importance: 30 }
    ],
    topics: [
      { id: "AI-1", name: "Intelligent Agent Models & Problem Formulations", weeks: 1.5, importance: "Core", cloId: "CSE401-CLO1" },
      { 
        id: "AI-2", 
        name: "Heuristic State-Space Search (A*, IDA*, Graph Traversals)", 
        weeks: 3.5, 
        importance: "Critical", 
        cloId: "CSE401-CLO1", 
        requiresTopic: "ALG-3", 
        indirectRequiresTopic: "DS-6" 
      },
      { id: "AI-3", name: "Adversarial Search & Game Trees (Minimax, Alpha-Beta Pruning)", weeks: 2.5, importance: "Critical", cloId: "CSE401-CLO2", requiresTopic: "DS-4" },
      { id: "AI-4", name: "Propositional & First-Order Predicate Logic Resolution", weeks: 2.5, importance: "Core", cloId: "CSE401-CLO2" },
      { id: "AI-5", name: "Bayesian Reasoning & Directed Acyclic Belief Graphs", weeks: 2.5, importance: "Core", cloId: "CSE401-CLO3", requiresTopic: "DS-6" },
      { id: "AI-6", name: "Constraint Satisfaction Problems & Backtracking Search", weeks: 1.5, importance: "Core", cloId: "CSE401-CLO1", requiresTopic: "DS-4" }
    ]
  },
  {
    id: "CSE-405",
    code: "CSE 405",
    name: "Machine Learning",
    semester: 7,
    credit: 3.0,
    type: "Elective / Core Specialization",
    description: "Statistical learning paradigms, parametric and non-parametric algorithms, loss functions, gradient descent, deep neural networks, clustering, and graph representations.",
    prerequisites: ["CSE-401", "CSE-301"],
    assessments: [
      { type: "Final Examination", percentage: 40, category: "Theory" },
      { type: "Midterm Examination", percentage: 25, category: "Theory" },
      { type: "Quizzes", percentage: 10, category: "Theory" },
      { type: "Machine Learning Capstone Lab", percentage: 25, category: "Practical" }
    ],
    assessmentRatio: { theory: 60, practical: 40 },
    clos: [
      { id: "CSE405-CLO1", description: "Implement and tune supervised and unsupervised statistical learning algorithms.", bloomLevel: "Apply", importance: 35 },
      { id: "CSE405-CLO2", description: "Design multi-layer neural network architectures and optimize backpropagation losses.", bloomLevel: "Create", importance: 35 },
      { id: "CSE405-CLO3", description: "Critique model evaluation metrics, generalization boundaries, and algorithmic bias.", bloomLevel: "Evaluate", importance: 30 }
    ],
    topics: [
      { id: "ML-1", name: "Supervised Learning: Linear & Logistic Regression with Gradient Descent", weeks: 2.5, importance: "Core", cloId: "CSE405-CLO1" },
      { id: "ML-2", name: "Decision Trees, Information Gain & Random Forests", weeks: 2.5, importance: "Core", cloId: "CSE405-CLO1", requiresTopic: "DS-5" },
      { id: "ML-3", name: "Artificial Neural Networks & Backpropagation Mechanisms", weeks: 3.0, importance: "Critical", cloId: "CSE405-CLO2" },
      { id: "ML-4", name: "Unsupervised Clustering (K-Means, Hierarchical & Graph Clustering)", weeks: 2.0, importance: "Core", cloId: "CSE405-CLO1" },
      { id: "ML-5", name: "Model Evaluation, Regularization (L1/L2) & Cross-Validation", weeks: 1.5, importance: "Core", cloId: "CSE405-CLO3" },
      { 
        id: "ML-6", 
        name: "Graph Neural Networks & Node Embedding Representations", 
        weeks: 2.5, 
        importance: "Advanced", 
        cloId: "CSE405-CLO2", 
        requiresTopic: "ALG-3",
        indirectRequiresTopic: "DS-6"
      }
    ]
  }
];

// Helper to quickly look up courses, topics, and CLOs
export const getCourseById = (id) => courses.find(c => c.id === id || c.code === id);

export const getAllCourses = () => courses;
